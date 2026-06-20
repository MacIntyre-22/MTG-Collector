//
//  CollectionShareService.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Publishes a collection snapshot to the CloudKit *public* database and mints a Universal Link
//      that opens it in-app (with a web fallback). The snapshot JSON (just IDs/quantities, < 1 MB)
//      lives in a record field; the optional cover photo travels as a CKAsset so the full deck —
//      name, metadata, cover image, and re-fetched card art — rebuilds on the receiving device.
//
//      SETUP REQUIRED (device only, can't be done from code):
//        • Add the CloudKit container `iCloud.net.benmacintyre.cardhold` in Signing & Capabilities
//          (and to the entitlements icloud-container-identifiers array).
//        • Add the Associated Domains entitlement `applinks:cardhold.ca`.
//        • Point the subdomain cardhold.ca at a static host (e.g. Cloudflare Pages —
//          NOT the main server) and host an apple-app-site-association file at
//          cardhold.ca/.well-known/ mapping `/share/*`, plus a static "get the app"
//          page at /share for non-installers.
//      Until then the share sheet still produces a link, but tapping it opens the web fallback
//      rather than the app.
//  External Types:
//      CollectionSnapshot
//

// MARK: Imports

import Foundation
import CloudKit
import UIKit

// MARK: Service

enum CollectionShareService {

    /// Universal Link host + path. Tapping `https://cardhold.ca/share/<id>` opens the app.
    static let linkHost = "https://cardhold.ca"
    static let linkPath = "/share"

    /// CloudKit container backing the public share store. Must match the capability in Xcode.
    private static let container = CKContainer(identifier: "iCloud.net.benmacintyre.cardhold")
    private static let recordType = "SharedCollection"

    enum ShareError: LocalizedError {
        case encodeFailed
        case notFound
        case cloudKit(String)

        var errorDescription: String? {
            switch self {
            case .encodeFailed:        return "Couldn't package this collection to share."
            case .notFound:            return "This shared link is no longer available."
            case .cloudKit(let msg):   return msg
            }
        }
    }

    // MARK: Upload

    /// Publish a snapshot and return its Universal Link. The cover image (if any) is attached as a
    /// CKAsset and kept out of the JSON field.
    static func publish(_ snapshot: CollectionSnapshot, cover: UIImage?) async throws -> URL {
        var payload = snapshot
        payload.coverImageData = nil   // image goes as an asset, not in the JSON field

        guard let data = try? JSONEncoder().encode(payload) else { throw ShareError.encodeFailed }

        let recordID = CKRecord.ID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record["snapshot"] = data as CKRecordValue
        record["name"] = snapshot.name as CKRecordValue
        record["kind"] = snapshot.kind.rawValue as CKRecordValue

        if let cover, let asset = makeAsset(from: cover) {
            record["cover"] = asset
        }

        do {
            _ = try await container.publicCloudDatabase.save(record)
        } catch {
            throw ShareError.cloudKit(error.localizedDescription)
        }

        guard let url = URL(string: "\(linkHost)\(linkPath)/\(recordID.recordName)") else {
            throw ShareError.encodeFailed
        }
        return url
    }

    // MARK: Fetch

    /// Resolve a share id (the last path component of a Universal Link) back into a snapshot and
    /// its cover image.
    static func fetch(id: String) async throws -> (snapshot: CollectionSnapshot, cover: UIImage?) {
        let recordID = CKRecord.ID(recordName: id)
        let record: CKRecord
        do {
            record = try await container.publicCloudDatabase.record(for: recordID)
        } catch let error as CKError where error.code == .unknownItem {
            throw ShareError.notFound
        } catch {
            throw ShareError.cloudKit(error.localizedDescription)
        }

        guard let data = record["snapshot"] as? Data,
              let snapshot = try? JSONDecoder().decode(CollectionSnapshot.self, from: data) else {
            throw ShareError.notFound
        }

        var cover: UIImage?
        if let asset = record["cover"] as? CKAsset, let url = asset.fileURL,
           let imageData = try? Data(contentsOf: url) {
            cover = UIImage(data: imageData)
        }
        return (snapshot, cover)
    }

    /// Extract the share id from an incoming Universal Link, if it's one of ours.
    static func shareID(from url: URL) -> String? {
        guard url.host() == "cardhold.ca" else { return nil }
        let parts = url.pathComponents.filter { $0 != "/" }
        guard parts.count >= 2, "/\(parts[0])" == linkPath else { return nil }
        return parts[1]
    }

    // MARK: Helpers

    /// Write a cover image to a temp file and wrap it as a CKAsset.
    private static func makeAsset(from image: UIImage) -> CKAsset? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        guard (try? data.write(to: url)) != nil else { return nil }
        return CKAsset(fileURL: url)
    }
}

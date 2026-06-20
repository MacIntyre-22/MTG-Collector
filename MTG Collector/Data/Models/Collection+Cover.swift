//
//  Collection+Cover.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Cover-image accessors for Collection. The cover is stored as external-storage Data on the
//      synced model (so it travels via CloudKit to every device) and downscaled on write to keep
//      the synced size reasonable. Replaces the old local-file ImageManager approach for covers.
//  External Types:
//      Collection
//

// MARK: Imports

import UIKit

// MARK: Cover access

@available(iOS 26, *)
extension Collection {

    /// The cover photo, if one is set.
    var coverUIImage: UIImage? {
        coverImageData.flatMap { UIImage(data: $0) }
    }

    /// Set (or clear) the cover photo. Downscales to a sensible max size and JPEG-encodes so the
    /// synced data stays small.
    func setCover(_ image: UIImage?) {
        guard let image else { coverImageData = nil; return }
        coverImageData = image.coverResized().jpegData(compressionQuality: 0.8)
    }
}

// MARK: Resize

extension UIImage {

    /// Downscale so the longest side is at most `maxDimension`, preserving aspect ratio. Covers are
    /// shown small, so there's no need to sync full-resolution photos.
    func coverResized(maxDimension: CGFloat = 1000) -> UIImage {
        let longest = max(size.width, size.height)
        guard longest > maxDimension else { return self }
        let scale = maxDimension / longest
        let target = CGSize(width: size.width * scale, height: size.height * scale)
        return UIGraphicsImageRenderer(size: target).image { _ in
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
}

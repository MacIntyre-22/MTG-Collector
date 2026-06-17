import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AccentColor" asset catalog color resource.
    static let accent = DeveloperToolsSupport.ColorResource(name: "AccentColor", bundle: resourceBundle)

    /// The "Blue Theme" asset catalog color resource.
    static let blueTheme = DeveloperToolsSupport.ColorResource(name: "Blue Theme", bundle: resourceBundle)

    /// The "Green Theme" asset catalog color resource.
    static let greenTheme = DeveloperToolsSupport.ColorResource(name: "Green Theme", bundle: resourceBundle)

    /// The "Orange Theme" asset catalog color resource.
    static let orangeTheme = DeveloperToolsSupport.ColorResource(name: "Orange Theme", bundle: resourceBundle)

    /// The "Red Theme" asset catalog color resource.
    static let redTheme = DeveloperToolsSupport.ColorResource(name: "Red Theme", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "10e" asset catalog image resource.
    static let _10E = DeveloperToolsSupport.ImageResource(name: "10e", bundle: resourceBundle)

    /// The "2ed" asset catalog image resource.
    static let _2Ed = DeveloperToolsSupport.ImageResource(name: "2ed", bundle: resourceBundle)

    /// The "2x2" asset catalog image resource.
    static let _2X2 = DeveloperToolsSupport.ImageResource(name: "2x2", bundle: resourceBundle)

    /// The "2xm" asset catalog image resource.
    static let _2Xm = DeveloperToolsSupport.ImageResource(name: "2xm", bundle: resourceBundle)

    /// The "3ed" asset catalog image resource.
    static let _3Ed = DeveloperToolsSupport.ImageResource(name: "3ed", bundle: resourceBundle)

    /// The "40k" asset catalog image resource.
    static let _40K = DeveloperToolsSupport.ImageResource(name: "40k", bundle: resourceBundle)

    /// The "40k-border" asset catalog image resource.
    static let _40KBorder = DeveloperToolsSupport.ImageResource(name: "40k-border", bundle: resourceBundle)

    /// The "40k-white" asset catalog image resource.
    static let _40KWhite = DeveloperToolsSupport.ImageResource(name: "40k-white", bundle: resourceBundle)

    /// The "4ed" asset catalog image resource.
    static let _4Ed = DeveloperToolsSupport.ImageResource(name: "4ed", bundle: resourceBundle)

    /// The "5dn" asset catalog image resource.
    static let _5Dn = DeveloperToolsSupport.ImageResource(name: "5dn", bundle: resourceBundle)

    /// The "5ed" asset catalog image resource.
    static let _5Ed = DeveloperToolsSupport.ImageResource(name: "5ed", bundle: resourceBundle)

    /// The "6ed" asset catalog image resource.
    static let _6Ed = DeveloperToolsSupport.ImageResource(name: "6ed", bundle: resourceBundle)

    /// The "7ed" asset catalog image resource.
    static let _7Ed = DeveloperToolsSupport.ImageResource(name: "7ed", bundle: resourceBundle)

    /// The "8ed" asset catalog image resource.
    static let _8Ed = DeveloperToolsSupport.ImageResource(name: "8ed", bundle: resourceBundle)

    /// The "9ed" asset catalog image resource.
    static let _9Ed = DeveloperToolsSupport.ImageResource(name: "9ed", bundle: resourceBundle)

    /// The "B" asset catalog image resource.
    static let B = DeveloperToolsSupport.ImageResource(name: "B", bundle: resourceBundle)

    /// The "B2" asset catalog image resource.
    static let B_2 = DeveloperToolsSupport.ImageResource(name: "B2", bundle: resourceBundle)

    /// The "BG" asset catalog image resource.
    static let BG = DeveloperToolsSupport.ImageResource(name: "BG", bundle: resourceBundle)

    /// The "BP" asset catalog image resource.
    static let BP = DeveloperToolsSupport.ImageResource(name: "BP", bundle: resourceBundle)

    /// The "BR" asset catalog image resource.
    static let BR = DeveloperToolsSupport.ImageResource(name: "BR", bundle: resourceBundle)

    /// The "CP" asset catalog image resource.
    static let CP = DeveloperToolsSupport.ImageResource(name: "CP", bundle: resourceBundle)

    /// The "CardHoarder" asset catalog image resource.
    static let cardHoarder = DeveloperToolsSupport.ImageResource(name: "CardHoarder", bundle: resourceBundle)

    /// The "CardMarket" asset catalog image resource.
    static let cardMarket = DeveloperToolsSupport.ImageResource(name: "CardMarket", bundle: resourceBundle)

    /// The "G" asset catalog image resource.
    static let G = DeveloperToolsSupport.ImageResource(name: "G", bundle: resourceBundle)

    /// The "G2" asset catalog image resource.
    static let G_2 = DeveloperToolsSupport.ImageResource(name: "G2", bundle: resourceBundle)

    /// The "GP" asset catalog image resource.
    static let GP = DeveloperToolsSupport.ImageResource(name: "GP", bundle: resourceBundle)

    /// The "GU" asset catalog image resource.
    static let GU = DeveloperToolsSupport.ImageResource(name: "GU", bundle: resourceBundle)

    /// The "GW" asset catalog image resource.
    static let GW = DeveloperToolsSupport.ImageResource(name: "GW", bundle: resourceBundle)

    /// The "Logo" asset catalog image resource.
    static let logo = DeveloperToolsSupport.ImageResource(name: "Logo", bundle: resourceBundle)

    /// The "MtgBinder" asset catalog image resource.
    static let mtgBinder = DeveloperToolsSupport.ImageResource(name: "MtgBinder", bundle: resourceBundle)

    /// The "MtgBinderDark" asset catalog image resource.
    static let mtgBinderDark = DeveloperToolsSupport.ImageResource(name: "MtgBinderDark", bundle: resourceBundle)

    /// The "MtgBinderIcon" asset catalog image resource.
    static let mtgBinderIcon = DeveloperToolsSupport.ImageResource(name: "MtgBinderIcon", bundle: resourceBundle)

    /// The "MtgDeck" asset catalog image resource.
    static let mtgDeck = DeveloperToolsSupport.ImageResource(name: "MtgDeck", bundle: resourceBundle)

    /// The "MtgLogo" asset catalog image resource.
    static let mtgLogo = DeveloperToolsSupport.ImageResource(name: "MtgLogo", bundle: resourceBundle)

    /// The "R" asset catalog image resource.
    static let R = DeveloperToolsSupport.ImageResource(name: "R", bundle: resourceBundle)

    /// The "R2" asset catalog image resource.
    static let R_2 = DeveloperToolsSupport.ImageResource(name: "R2", bundle: resourceBundle)

    /// The "RG" asset catalog image resource.
    static let RG = DeveloperToolsSupport.ImageResource(name: "RG", bundle: resourceBundle)

    /// The "RP" asset catalog image resource.
    static let RP = DeveloperToolsSupport.ImageResource(name: "RP", bundle: resourceBundle)

    /// The "RW" asset catalog image resource.
    static let RW = DeveloperToolsSupport.ImageResource(name: "RW", bundle: resourceBundle)

    /// The "S" asset catalog image resource.
    static let S = DeveloperToolsSupport.ImageResource(name: "S", bundle: resourceBundle)

    /// The "TcgPlayer" asset catalog image resource.
    static let tcgPlayer = DeveloperToolsSupport.ImageResource(name: "TcgPlayer", bundle: resourceBundle)

    /// The "U" asset catalog image resource.
    static let U = DeveloperToolsSupport.ImageResource(name: "U", bundle: resourceBundle)

    /// The "U2" asset catalog image resource.
    static let U_2 = DeveloperToolsSupport.ImageResource(name: "U2", bundle: resourceBundle)

    /// The "UB" asset catalog image resource.
    static let UB = DeveloperToolsSupport.ImageResource(name: "UB", bundle: resourceBundle)

    /// The "UP" asset catalog image resource.
    static let UP = DeveloperToolsSupport.ImageResource(name: "UP", bundle: resourceBundle)

    /// The "UR" asset catalog image resource.
    static let UR = DeveloperToolsSupport.ImageResource(name: "UR", bundle: resourceBundle)

    /// The "W" asset catalog image resource.
    static let W = DeveloperToolsSupport.ImageResource(name: "W", bundle: resourceBundle)

    /// The "W2" asset catalog image resource.
    static let W_2 = DeveloperToolsSupport.ImageResource(name: "W2", bundle: resourceBundle)

    /// The "WB" asset catalog image resource.
    static let WB = DeveloperToolsSupport.ImageResource(name: "WB", bundle: resourceBundle)

    /// The "WP" asset catalog image resource.
    static let WP = DeveloperToolsSupport.ImageResource(name: "WP", bundle: resourceBundle)

    /// The "WU" asset catalog image resource.
    static let WU = DeveloperToolsSupport.ImageResource(name: "WU", bundle: resourceBundle)

    /// The "a25" asset catalog image resource.
    static let a25 = DeveloperToolsSupport.ImageResource(name: "a25", bundle: resourceBundle)

    /// The "acr" asset catalog image resource.
    static let acr = DeveloperToolsSupport.ImageResource(name: "acr", bundle: resourceBundle)

    /// The "aer" asset catalog image resource.
    static let aer = DeveloperToolsSupport.ImageResource(name: "aer", bundle: resourceBundle)

    /// The "afc" asset catalog image resource.
    static let afc = DeveloperToolsSupport.ImageResource(name: "afc", bundle: resourceBundle)

    /// The "afc-border" asset catalog image resource.
    static let afcBorder = DeveloperToolsSupport.ImageResource(name: "afc-border", bundle: resourceBundle)

    /// The "afr" asset catalog image resource.
    static let afr = DeveloperToolsSupport.ImageResource(name: "afr", bundle: resourceBundle)

    /// The "afr-border" asset catalog image resource.
    static let afrBorder = DeveloperToolsSupport.ImageResource(name: "afr-border", bundle: resourceBundle)

    /// The "akh" asset catalog image resource.
    static let akh = DeveloperToolsSupport.ImageResource(name: "akh", bundle: resourceBundle)

    /// The "akr" asset catalog image resource.
    static let akr = DeveloperToolsSupport.ImageResource(name: "akr", bundle: resourceBundle)

    /// The "ala" asset catalog image resource.
    static let ala = DeveloperToolsSupport.ImageResource(name: "ala", bundle: resourceBundle)

    /// The "apc" asset catalog image resource.
    static let apc = DeveloperToolsSupport.ImageResource(name: "apc", bundle: resourceBundle)

    /// The "arb" asset catalog image resource.
    static let arb = DeveloperToolsSupport.ImageResource(name: "arb", bundle: resourceBundle)

    /// The "arc" asset catalog image resource.
    static let arc = DeveloperToolsSupport.ImageResource(name: "arc", bundle: resourceBundle)

    /// The "arn" asset catalog image resource.
    static let arn = DeveloperToolsSupport.ImageResource(name: "arn", bundle: resourceBundle)

    /// The "ath" asset catalog image resource.
    static let ath = DeveloperToolsSupport.ImageResource(name: "ath", bundle: resourceBundle)

    /// The "atq" asset catalog image resource.
    static let atq = DeveloperToolsSupport.ImageResource(name: "atq", bundle: resourceBundle)

    /// The "avr" asset catalog image resource.
    static let avr = DeveloperToolsSupport.ImageResource(name: "avr", bundle: resourceBundle)

    /// The "azorius" asset catalog image resource.
    static let azorius = DeveloperToolsSupport.ImageResource(name: "azorius", bundle: resourceBundle)

    /// The "bbd" asset catalog image resource.
    static let bbd = DeveloperToolsSupport.ImageResource(name: "bbd", bundle: resourceBundle)

    /// The "bcore" asset catalog image resource.
    static let bcore = DeveloperToolsSupport.ImageResource(name: "bcore", bundle: resourceBundle)

    /// The "bfz" asset catalog image resource.
    static let bfz = DeveloperToolsSupport.ImageResource(name: "bfz", bundle: resourceBundle)

    /// The "big" asset catalog image resource.
    static let big = DeveloperToolsSupport.ImageResource(name: "big", bundle: resourceBundle)

    /// The "blb" asset catalog image resource.
    static let blb = DeveloperToolsSupport.ImageResource(name: "blb", bundle: resourceBundle)

    /// The "blc" asset catalog image resource.
    static let blc = DeveloperToolsSupport.ImageResource(name: "blc", bundle: resourceBundle)

    /// The "bng" asset catalog image resource.
    static let bng = DeveloperToolsSupport.ImageResource(name: "bng", bundle: resourceBundle)

    /// The "bok" asset catalog image resource.
    static let bok = DeveloperToolsSupport.ImageResource(name: "bok", bundle: resourceBundle)

    /// The "boros" asset catalog image resource.
    static let boros = DeveloperToolsSupport.ImageResource(name: "boros", bundle: resourceBundle)

    /// The "bot" asset catalog image resource.
    static let bot = DeveloperToolsSupport.ImageResource(name: "bot", bundle: resourceBundle)

    /// The "br" asset catalog image resource.
    static let br = DeveloperToolsSupport.ImageResource(name: "br", bundle: resourceBundle)

    /// The "brb" asset catalog image resource.
    static let brb = DeveloperToolsSupport.ImageResource(name: "brb", bundle: resourceBundle)

    /// The "brc" asset catalog image resource.
    static let brc = DeveloperToolsSupport.ImageResource(name: "brc", bundle: resourceBundle)

    /// The "bro" asset catalog image resource.
    static let bro = DeveloperToolsSupport.ImageResource(name: "bro", bundle: resourceBundle)

    /// The "brr" asset catalog image resource.
    static let brr = DeveloperToolsSupport.ImageResource(name: "brr", bundle: resourceBundle)

    /// The "btd" asset catalog image resource.
    static let btd = DeveloperToolsSupport.ImageResource(name: "btd", bundle: resourceBundle)

    /// The "c13" asset catalog image resource.
    static let c13 = DeveloperToolsSupport.ImageResource(name: "c13", bundle: resourceBundle)

    /// The "c14" asset catalog image resource.
    static let c14 = DeveloperToolsSupport.ImageResource(name: "c14", bundle: resourceBundle)

    /// The "c15" asset catalog image resource.
    static let c15 = DeveloperToolsSupport.ImageResource(name: "c15", bundle: resourceBundle)

    /// The "c16" asset catalog image resource.
    static let c16 = DeveloperToolsSupport.ImageResource(name: "c16", bundle: resourceBundle)

    /// The "c17" asset catalog image resource.
    static let c17 = DeveloperToolsSupport.ImageResource(name: "c17", bundle: resourceBundle)

    /// The "c18" asset catalog image resource.
    static let c18 = DeveloperToolsSupport.ImageResource(name: "c18", bundle: resourceBundle)

    /// The "c19" asset catalog image resource.
    static let c19 = DeveloperToolsSupport.ImageResource(name: "c19", bundle: resourceBundle)

    /// The "c20" asset catalog image resource.
    static let c20 = DeveloperToolsSupport.ImageResource(name: "c20", bundle: resourceBundle)

    /// The "c21" asset catalog image resource.
    static let c21 = DeveloperToolsSupport.ImageResource(name: "c21", bundle: resourceBundle)

    /// The "c21-border" asset catalog image resource.
    static let c21Border = DeveloperToolsSupport.ImageResource(name: "c21-border", bundle: resourceBundle)

    /// The "cc1" asset catalog image resource.
    static let cc1 = DeveloperToolsSupport.ImageResource(name: "cc1", bundle: resourceBundle)

    /// The "cc2" asset catalog image resource.
    static let cc2 = DeveloperToolsSupport.ImageResource(name: "cc2", bundle: resourceBundle)

    /// The "cc2-border" asset catalog image resource.
    static let cc2Border = DeveloperToolsSupport.ImageResource(name: "cc2-border", bundle: resourceBundle)

    /// The "chk" asset catalog image resource.
    static let chk = DeveloperToolsSupport.ImageResource(name: "chk", bundle: resourceBundle)

    /// The "chr" asset catalog image resource.
    static let chr = DeveloperToolsSupport.ImageResource(name: "chr", bundle: resourceBundle)

    /// The "clb" asset catalog image resource.
    static let clb = DeveloperToolsSupport.ImageResource(name: "clb", bundle: resourceBundle)

    /// The "clb-white" asset catalog image resource.
    static let clbWhite = DeveloperToolsSupport.ImageResource(name: "clb-white", bundle: resourceBundle)

    /// The "clu" asset catalog image resource.
    static let clu = DeveloperToolsSupport.ImageResource(name: "clu", bundle: resourceBundle)

    /// The "cm1" asset catalog image resource.
    static let cm1 = DeveloperToolsSupport.ImageResource(name: "cm1", bundle: resourceBundle)

    /// The "cm2" asset catalog image resource.
    static let cm2 = DeveloperToolsSupport.ImageResource(name: "cm2", bundle: resourceBundle)

    /// The "cma" asset catalog image resource.
    static let cma = DeveloperToolsSupport.ImageResource(name: "cma", bundle: resourceBundle)

    /// The "cmd" asset catalog image resource.
    static let cmd = DeveloperToolsSupport.ImageResource(name: "cmd", bundle: resourceBundle)

    /// The "cmm" asset catalog image resource.
    static let cmm = DeveloperToolsSupport.ImageResource(name: "cmm", bundle: resourceBundle)

    /// The "cmr" asset catalog image resource.
    static let cmr = DeveloperToolsSupport.ImageResource(name: "cmr", bundle: resourceBundle)

    /// The "cn2" asset catalog image resource.
    static let cn2 = DeveloperToolsSupport.ImageResource(name: "cn2", bundle: resourceBundle)

    /// The "cns" asset catalog image resource.
    static let cns = DeveloperToolsSupport.ImageResource(name: "cns", bundle: resourceBundle)

    /// The "con_" asset catalog image resource.
    static let con = DeveloperToolsSupport.ImageResource(name: "con_", bundle: resourceBundle)

    /// The "csp" asset catalog image resource.
    static let csp = DeveloperToolsSupport.ImageResource(name: "csp", bundle: resourceBundle)

    /// The "dd2" asset catalog image resource.
    static let dd2 = DeveloperToolsSupport.ImageResource(name: "dd2", bundle: resourceBundle)

    /// The "ddc" asset catalog image resource.
    static let ddc = DeveloperToolsSupport.ImageResource(name: "ddc", bundle: resourceBundle)

    /// The "ddd" asset catalog image resource.
    static let ddd = DeveloperToolsSupport.ImageResource(name: "ddd", bundle: resourceBundle)

    /// The "dde" asset catalog image resource.
    static let dde = DeveloperToolsSupport.ImageResource(name: "dde", bundle: resourceBundle)

    /// The "ddf" asset catalog image resource.
    static let ddf = DeveloperToolsSupport.ImageResource(name: "ddf", bundle: resourceBundle)

    /// The "ddg" asset catalog image resource.
    static let ddg = DeveloperToolsSupport.ImageResource(name: "ddg", bundle: resourceBundle)

    /// The "ddh" asset catalog image resource.
    static let ddh = DeveloperToolsSupport.ImageResource(name: "ddh", bundle: resourceBundle)

    /// The "ddi" asset catalog image resource.
    static let ddi = DeveloperToolsSupport.ImageResource(name: "ddi", bundle: resourceBundle)

    /// The "ddj" asset catalog image resource.
    static let ddj = DeveloperToolsSupport.ImageResource(name: "ddj", bundle: resourceBundle)

    /// The "ddk" asset catalog image resource.
    static let ddk = DeveloperToolsSupport.ImageResource(name: "ddk", bundle: resourceBundle)

    /// The "ddl" asset catalog image resource.
    static let ddl = DeveloperToolsSupport.ImageResource(name: "ddl", bundle: resourceBundle)

    /// The "ddm" asset catalog image resource.
    static let ddm = DeveloperToolsSupport.ImageResource(name: "ddm", bundle: resourceBundle)

    /// The "ddn" asset catalog image resource.
    static let ddn = DeveloperToolsSupport.ImageResource(name: "ddn", bundle: resourceBundle)

    /// The "ddo" asset catalog image resource.
    static let ddo = DeveloperToolsSupport.ImageResource(name: "ddo", bundle: resourceBundle)

    /// The "ddp" asset catalog image resource.
    static let ddp = DeveloperToolsSupport.ImageResource(name: "ddp", bundle: resourceBundle)

    /// The "ddq" asset catalog image resource.
    static let ddq = DeveloperToolsSupport.ImageResource(name: "ddq", bundle: resourceBundle)

    /// The "ddr" asset catalog image resource.
    static let ddr = DeveloperToolsSupport.ImageResource(name: "ddr", bundle: resourceBundle)

    /// The "dds" asset catalog image resource.
    static let dds = DeveloperToolsSupport.ImageResource(name: "dds", bundle: resourceBundle)

    /// The "ddt" asset catalog image resource.
    static let ddt = DeveloperToolsSupport.ImageResource(name: "ddt", bundle: resourceBundle)

    /// The "ddu" asset catalog image resource.
    static let ddu = DeveloperToolsSupport.ImageResource(name: "ddu", bundle: resourceBundle)

    /// The "dft" asset catalog image resource.
    static let dft = DeveloperToolsSupport.ImageResource(name: "dft", bundle: resourceBundle)

    /// The "dft-rarity" asset catalog image resource.
    static let dftRarity = DeveloperToolsSupport.ImageResource(name: "dft-rarity", bundle: resourceBundle)

    /// The "dgm" asset catalog image resource.
    static let dgm = DeveloperToolsSupport.ImageResource(name: "dgm", bundle: resourceBundle)

    /// The "dimir" asset catalog image resource.
    static let dimir = DeveloperToolsSupport.ImageResource(name: "dimir", bundle: resourceBundle)

    /// The "dis" asset catalog image resource.
    static let dis = DeveloperToolsSupport.ImageResource(name: "dis", bundle: resourceBundle)

    /// The "dka" asset catalog image resource.
    static let dka = DeveloperToolsSupport.ImageResource(name: "dka", bundle: resourceBundle)

    /// The "dkm" asset catalog image resource.
    static let dkm = DeveloperToolsSupport.ImageResource(name: "dkm", bundle: resourceBundle)

    /// The "dmc" asset catalog image resource.
    static let dmc = DeveloperToolsSupport.ImageResource(name: "dmc", bundle: resourceBundle)

    /// The "dmc-border" asset catalog image resource.
    static let dmcBorder = DeveloperToolsSupport.ImageResource(name: "dmc-border", bundle: resourceBundle)

    /// The "dmc-white" asset catalog image resource.
    static let dmcWhite = DeveloperToolsSupport.ImageResource(name: "dmc-white", bundle: resourceBundle)

    /// The "dmr" asset catalog image resource.
    static let dmr = DeveloperToolsSupport.ImageResource(name: "dmr", bundle: resourceBundle)

    /// The "dmu" asset catalog image resource.
    static let dmu = DeveloperToolsSupport.ImageResource(name: "dmu", bundle: resourceBundle)

    /// The "dom" asset catalog image resource.
    static let dom = DeveloperToolsSupport.ImageResource(name: "dom", bundle: resourceBundle)

    /// The "dpa" asset catalog image resource.
    static let dpa = DeveloperToolsSupport.ImageResource(name: "dpa", bundle: resourceBundle)

    /// The "drb" asset catalog image resource.
    static let drb = DeveloperToolsSupport.ImageResource(name: "drb", bundle: resourceBundle)

    /// The "drc" asset catalog image resource.
    static let drc = DeveloperToolsSupport.ImageResource(name: "drc", bundle: resourceBundle)

    /// The "drc-border" asset catalog image resource.
    static let drcBorder = DeveloperToolsSupport.ImageResource(name: "drc-border", bundle: resourceBundle)

    /// The "drc-inner" asset catalog image resource.
    static let drcInner = DeveloperToolsSupport.ImageResource(name: "drc-inner", bundle: resourceBundle)

    /// The "drc-rarity" asset catalog image resource.
    static let drcRarity = DeveloperToolsSupport.ImageResource(name: "drc-rarity", bundle: resourceBundle)

    /// The "drk" asset catalog image resource.
    static let drk = DeveloperToolsSupport.ImageResource(name: "drk", bundle: resourceBundle)

    /// The "dsc" asset catalog image resource.
    static let dsc = DeveloperToolsSupport.ImageResource(name: "dsc", bundle: resourceBundle)

    /// The "dsc-border" asset catalog image resource.
    static let dscBorder = DeveloperToolsSupport.ImageResource(name: "dsc-border", bundle: resourceBundle)

    /// The "dsc-white" asset catalog image resource.
    static let dscWhite = DeveloperToolsSupport.ImageResource(name: "dsc-white", bundle: resourceBundle)

    /// The "dsk" asset catalog image resource.
    static let dsk = DeveloperToolsSupport.ImageResource(name: "dsk", bundle: resourceBundle)

    /// The "dst" asset catalog image resource.
    static let dst = DeveloperToolsSupport.ImageResource(name: "dst", bundle: resourceBundle)

    /// The "dtk" asset catalog image resource.
    static let dtk = DeveloperToolsSupport.ImageResource(name: "dtk", bundle: resourceBundle)

    /// The "dvk" asset catalog image resource.
    static let dvk = DeveloperToolsSupport.ImageResource(name: "dvk", bundle: resourceBundle)

    /// The "e01" asset catalog image resource.
    static let e01 = DeveloperToolsSupport.ImageResource(name: "e01", bundle: resourceBundle)

    /// The "e02" asset catalog image resource.
    static let e02 = DeveloperToolsSupport.ImageResource(name: "e02", bundle: resourceBundle)

    /// The "eld" asset catalog image resource.
    static let eld = DeveloperToolsSupport.ImageResource(name: "eld", bundle: resourceBundle)

    /// The "ema" asset catalog image resource.
    static let ema = DeveloperToolsSupport.ImageResource(name: "ema", bundle: resourceBundle)

    /// The "emn" asset catalog image resource.
    static let emn = DeveloperToolsSupport.ImageResource(name: "emn", bundle: resourceBundle)

    /// The "eoc" asset catalog image resource.
    static let eoc = DeveloperToolsSupport.ImageResource(name: "eoc", bundle: resourceBundle)

    /// The "eoc-inner" asset catalog image resource.
    static let eocInner = DeveloperToolsSupport.ImageResource(name: "eoc-inner", bundle: resourceBundle)

    /// The "eoe" asset catalog image resource.
    static let eoe = DeveloperToolsSupport.ImageResource(name: "eoe", bundle: resourceBundle)

    /// The "eos" asset catalog image resource.
    static let eos = DeveloperToolsSupport.ImageResource(name: "eos", bundle: resourceBundle)

    /// The "eos-border" asset catalog image resource.
    static let eosBorder = DeveloperToolsSupport.ImageResource(name: "eos-border", bundle: resourceBundle)

    /// The "eve" asset catalog image resource.
    static let eve = DeveloperToolsSupport.ImageResource(name: "eve", bundle: resourceBundle)

    /// The "evg" asset catalog image resource.
    static let evg = DeveloperToolsSupport.ImageResource(name: "evg", bundle: resourceBundle)

    /// The "exo" asset catalog image resource.
    static let exo = DeveloperToolsSupport.ImageResource(name: "exo", bundle: resourceBundle)

    /// The "exp" asset catalog image resource.
    static let exp = DeveloperToolsSupport.ImageResource(name: "exp", bundle: resourceBundle)

    /// The "fdc" asset catalog image resource.
    static let fdc = DeveloperToolsSupport.ImageResource(name: "fdc", bundle: resourceBundle)

    /// The "fdn" asset catalog image resource.
    static let fdn = DeveloperToolsSupport.ImageResource(name: "fdn", bundle: resourceBundle)

    /// The "fem" asset catalog image resource.
    static let fem = DeveloperToolsSupport.ImageResource(name: "fem", bundle: resourceBundle)

    /// The "fic" asset catalog image resource.
    static let fic = DeveloperToolsSupport.ImageResource(name: "fic", bundle: resourceBundle)

    /// The "fin" asset catalog image resource.
    static let fin = DeveloperToolsSupport.ImageResource(name: "fin", bundle: resourceBundle)

    /// The "fin-border" asset catalog image resource.
    static let finBorder = DeveloperToolsSupport.ImageResource(name: "fin-border", bundle: resourceBundle)

    /// The "fin-rarity" asset catalog image resource.
    static let finRarity = DeveloperToolsSupport.ImageResource(name: "fin-rarity", bundle: resourceBundle)

    /// The "frf" asset catalog image resource.
    static let frf = DeveloperToolsSupport.ImageResource(name: "frf", bundle: resourceBundle)

    /// The "fut" asset catalog image resource.
    static let fut = DeveloperToolsSupport.ImageResource(name: "fut", bundle: resourceBundle)

    /// The "gn2" asset catalog image resource.
    static let gn2 = DeveloperToolsSupport.ImageResource(name: "gn2", bundle: resourceBundle)

    /// The "gn3" asset catalog image resource.
    static let gn3 = DeveloperToolsSupport.ImageResource(name: "gn3", bundle: resourceBundle)

    /// The "gnt" asset catalog image resource.
    static let gnt = DeveloperToolsSupport.ImageResource(name: "gnt", bundle: resourceBundle)

    /// The "golgari" asset catalog image resource.
    static let golgari = DeveloperToolsSupport.ImageResource(name: "golgari", bundle: resourceBundle)

    /// The "gpt" asset catalog image resource.
    static let gpt = DeveloperToolsSupport.ImageResource(name: "gpt", bundle: resourceBundle)

    /// The "grn" asset catalog image resource.
    static let grn = DeveloperToolsSupport.ImageResource(name: "grn", bundle: resourceBundle)

    /// The "gruul" asset catalog image resource.
    static let gruul = DeveloperToolsSupport.ImageResource(name: "gruul", bundle: resourceBundle)

    /// The "gs1" asset catalog image resource.
    static let gs1 = DeveloperToolsSupport.ImageResource(name: "gs1", bundle: resourceBundle)

    /// The "gtc" asset catalog image resource.
    static let gtc = DeveloperToolsSupport.ImageResource(name: "gtc", bundle: resourceBundle)

    /// The "h09" asset catalog image resource.
    static let h09 = DeveloperToolsSupport.ImageResource(name: "h09", bundle: resourceBundle)

    /// The "h17" asset catalog image resource.
    static let h17 = DeveloperToolsSupport.ImageResource(name: "h17", bundle: resourceBundle)

    /// The "ha1" asset catalog image resource.
    static let ha1 = DeveloperToolsSupport.ImageResource(name: "ha1", bundle: resourceBundle)

    /// The "hbg" asset catalog image resource.
    static let hbg = DeveloperToolsSupport.ImageResource(name: "hbg", bundle: resourceBundle)

    /// The "hml" asset catalog image resource.
    static let hml = DeveloperToolsSupport.ImageResource(name: "hml", bundle: resourceBundle)

    /// The "hop" asset catalog image resource.
    static let hop = DeveloperToolsSupport.ImageResource(name: "hop", bundle: resourceBundle)

    /// The "hou" asset catalog image resource.
    static let hou = DeveloperToolsSupport.ImageResource(name: "hou", bundle: resourceBundle)

    /// The "ice" asset catalog image resource.
    static let ice = DeveloperToolsSupport.ImageResource(name: "ice", bundle: resourceBundle)

    /// The "ice2" asset catalog image resource.
    static let ice2 = DeveloperToolsSupport.ImageResource(name: "ice2", bundle: resourceBundle)

    /// The "iko" asset catalog image resource.
    static let iko = DeveloperToolsSupport.ImageResource(name: "iko", bundle: resourceBundle)

    /// The "ima" asset catalog image resource.
    static let ima = DeveloperToolsSupport.ImageResource(name: "ima", bundle: resourceBundle)

    /// The "inr" asset catalog image resource.
    static let inr = DeveloperToolsSupport.ImageResource(name: "inr", bundle: resourceBundle)

    /// The "inv" asset catalog image resource.
    static let inv = DeveloperToolsSupport.ImageResource(name: "inv", bundle: resourceBundle)

    /// The "isd" asset catalog image resource.
    static let isd = DeveloperToolsSupport.ImageResource(name: "isd", bundle: resourceBundle)

    /// The "izzet" asset catalog image resource.
    static let izzet = DeveloperToolsSupport.ImageResource(name: "izzet", bundle: resourceBundle)

    /// The "j20" asset catalog image resource.
    static let j20 = DeveloperToolsSupport.ImageResource(name: "j20", bundle: resourceBundle)

    /// The "j21" asset catalog image resource.
    static let j21 = DeveloperToolsSupport.ImageResource(name: "j21", bundle: resourceBundle)

    /// The "j21-outline" asset catalog image resource.
    static let j21Outline = DeveloperToolsSupport.ImageResource(name: "j21-outline", bundle: resourceBundle)

    /// The "j22" asset catalog image resource.
    static let j22 = DeveloperToolsSupport.ImageResource(name: "j22", bundle: resourceBundle)

    /// The "j25" asset catalog image resource.
    static let j25 = DeveloperToolsSupport.ImageResource(name: "j25", bundle: resourceBundle)

    /// The "j25-alt" asset catalog image resource.
    static let j25Alt = DeveloperToolsSupport.ImageResource(name: "j25-alt", bundle: resourceBundle)

    /// The "jmp" asset catalog image resource.
    static let jmp = DeveloperToolsSupport.ImageResource(name: "jmp", bundle: resourceBundle)

    /// The "jou" asset catalog image resource.
    static let jou = DeveloperToolsSupport.ImageResource(name: "jou", bundle: resourceBundle)

    /// The "jud" asset catalog image resource.
    static let jud = DeveloperToolsSupport.ImageResource(name: "jud", bundle: resourceBundle)

    /// The "khc" asset catalog image resource.
    static let khc = DeveloperToolsSupport.ImageResource(name: "khc", bundle: resourceBundle)

    /// The "khc-inner" asset catalog image resource.
    static let khcInner = DeveloperToolsSupport.ImageResource(name: "khc-inner", bundle: resourceBundle)

    /// The "khc-rarity" asset catalog image resource.
    static let khcRarity = DeveloperToolsSupport.ImageResource(name: "khc-rarity", bundle: resourceBundle)

    /// The "khm" asset catalog image resource.
    static let khm = DeveloperToolsSupport.ImageResource(name: "khm", bundle: resourceBundle)

    /// The "kld" asset catalog image resource.
    static let kld = DeveloperToolsSupport.ImageResource(name: "kld", bundle: resourceBundle)

    /// The "klr" asset catalog image resource.
    static let klr = DeveloperToolsSupport.ImageResource(name: "klr", bundle: resourceBundle)

    /// The "ktk" asset catalog image resource.
    static let ktk = DeveloperToolsSupport.ImageResource(name: "ktk", bundle: resourceBundle)

    /// The "lcc" asset catalog image resource.
    static let lcc = DeveloperToolsSupport.ImageResource(name: "lcc", bundle: resourceBundle)

    /// The "lci" asset catalog image resource.
    static let lci = DeveloperToolsSupport.ImageResource(name: "lci", bundle: resourceBundle)

    /// The "lea" asset catalog image resource.
    static let lea = DeveloperToolsSupport.ImageResource(name: "lea", bundle: resourceBundle)

    /// The "leb" asset catalog image resource.
    static let leb = DeveloperToolsSupport.ImageResource(name: "leb", bundle: resourceBundle)

    /// The "leg" asset catalog image resource.
    static let leg = DeveloperToolsSupport.ImageResource(name: "leg", bundle: resourceBundle)

    /// The "lgn" asset catalog image resource.
    static let lgn = DeveloperToolsSupport.ImageResource(name: "lgn", bundle: resourceBundle)

    /// The "lrw" asset catalog image resource.
    static let lrw = DeveloperToolsSupport.ImageResource(name: "lrw", bundle: resourceBundle)

    /// The "ltc" asset catalog image resource.
    static let ltc = DeveloperToolsSupport.ImageResource(name: "ltc", bundle: resourceBundle)

    /// The "ltc-white" asset catalog image resource.
    static let ltcWhite = DeveloperToolsSupport.ImageResource(name: "ltc-white", bundle: resourceBundle)

    /// The "ltr" asset catalog image resource.
    static let ltr = DeveloperToolsSupport.ImageResource(name: "ltr", bundle: resourceBundle)

    /// The "m10" asset catalog image resource.
    static let m10 = DeveloperToolsSupport.ImageResource(name: "m10", bundle: resourceBundle)

    /// The "m11" asset catalog image resource.
    static let m11 = DeveloperToolsSupport.ImageResource(name: "m11", bundle: resourceBundle)

    /// The "m12" asset catalog image resource.
    static let m12 = DeveloperToolsSupport.ImageResource(name: "m12", bundle: resourceBundle)

    /// The "m13" asset catalog image resource.
    static let m13 = DeveloperToolsSupport.ImageResource(name: "m13", bundle: resourceBundle)

    /// The "m14" asset catalog image resource.
    static let m14 = DeveloperToolsSupport.ImageResource(name: "m14", bundle: resourceBundle)

    /// The "m15" asset catalog image resource.
    static let m15 = DeveloperToolsSupport.ImageResource(name: "m15", bundle: resourceBundle)

    /// The "m19" asset catalog image resource.
    static let m19 = DeveloperToolsSupport.ImageResource(name: "m19", bundle: resourceBundle)

    /// The "m20" asset catalog image resource.
    static let m20 = DeveloperToolsSupport.ImageResource(name: "m20", bundle: resourceBundle)

    /// The "m21" asset catalog image resource.
    static let m21 = DeveloperToolsSupport.ImageResource(name: "m21", bundle: resourceBundle)

    /// The "m3c" asset catalog image resource.
    static let m3C = DeveloperToolsSupport.ImageResource(name: "m3c", bundle: resourceBundle)

    /// The "m3c-inner" asset catalog image resource.
    static let m3CInner = DeveloperToolsSupport.ImageResource(name: "m3c-inner", bundle: resourceBundle)

    /// The "mar" asset catalog image resource.
    static let mar = DeveloperToolsSupport.ImageResource(name: "mar", bundle: resourceBundle)

    /// The "mat" asset catalog image resource.
    static let mat = DeveloperToolsSupport.ImageResource(name: "mat", bundle: resourceBundle)

    /// The "mb1" asset catalog image resource.
    static let mb1 = DeveloperToolsSupport.ImageResource(name: "mb1", bundle: resourceBundle)

    /// The "mb2" asset catalog image resource.
    static let mb2 = DeveloperToolsSupport.ImageResource(name: "mb2", bundle: resourceBundle)

    /// The "mbs" asset catalog image resource.
    static let mbs = DeveloperToolsSupport.ImageResource(name: "mbs", bundle: resourceBundle)

    /// The "md1" asset catalog image resource.
    static let md1 = DeveloperToolsSupport.ImageResource(name: "md1", bundle: resourceBundle)

    /// The "me1" asset catalog image resource.
    static let me1 = DeveloperToolsSupport.ImageResource(name: "me1", bundle: resourceBundle)

    /// The "me2" asset catalog image resource.
    static let me2 = DeveloperToolsSupport.ImageResource(name: "me2", bundle: resourceBundle)

    /// The "me3" asset catalog image resource.
    static let me3 = DeveloperToolsSupport.ImageResource(name: "me3", bundle: resourceBundle)

    /// The "me4" asset catalog image resource.
    static let me4 = DeveloperToolsSupport.ImageResource(name: "me4", bundle: resourceBundle)

    /// The "med" asset catalog image resource.
    static let med = DeveloperToolsSupport.ImageResource(name: "med", bundle: resourceBundle)

    /// The "mh1" asset catalog image resource.
    static let mh1 = DeveloperToolsSupport.ImageResource(name: "mh1", bundle: resourceBundle)

    /// The "mh2" asset catalog image resource.
    static let mh2 = DeveloperToolsSupport.ImageResource(name: "mh2", bundle: resourceBundle)

    /// The "mh3" asset catalog image resource.
    static let mh3 = DeveloperToolsSupport.ImageResource(name: "mh3", bundle: resourceBundle)

    /// The "mic" asset catalog image resource.
    static let mic = DeveloperToolsSupport.ImageResource(name: "mic", bundle: resourceBundle)

    /// The "mid" asset catalog image resource.
    static let mid = DeveloperToolsSupport.ImageResource(name: "mid", bundle: resourceBundle)

    /// The "mid-border" asset catalog image resource.
    static let midBorder = DeveloperToolsSupport.ImageResource(name: "mid-border", bundle: resourceBundle)

    /// The "mir" asset catalog image resource.
    static let mir = DeveloperToolsSupport.ImageResource(name: "mir", bundle: resourceBundle)

    /// The "mkc" asset catalog image resource.
    static let mkc = DeveloperToolsSupport.ImageResource(name: "mkc", bundle: resourceBundle)

    /// The "mkm" asset catalog image resource.
    static let mkm = DeveloperToolsSupport.ImageResource(name: "mkm", bundle: resourceBundle)

    /// The "mm2" asset catalog image resource.
    static let mm2 = DeveloperToolsSupport.ImageResource(name: "mm2", bundle: resourceBundle)

    /// The "mm3" asset catalog image resource.
    static let mm3 = DeveloperToolsSupport.ImageResource(name: "mm3", bundle: resourceBundle)

    /// The "mma" asset catalog image resource.
    static let mma = DeveloperToolsSupport.ImageResource(name: "mma", bundle: resourceBundle)

    /// The "mmq" asset catalog image resource.
    static let mmq = DeveloperToolsSupport.ImageResource(name: "mmq", bundle: resourceBundle)

    /// The "moc" asset catalog image resource.
    static let moc = DeveloperToolsSupport.ImageResource(name: "moc", bundle: resourceBundle)

    /// The "mom" asset catalog image resource.
    static let mom = DeveloperToolsSupport.ImageResource(name: "mom", bundle: resourceBundle)

    /// The "mor" asset catalog image resource.
    static let mor = DeveloperToolsSupport.ImageResource(name: "mor", bundle: resourceBundle)

    /// The "mp1" asset catalog image resource.
    static let mp1 = DeveloperToolsSupport.ImageResource(name: "mp1", bundle: resourceBundle)

    /// The "mp2" asset catalog image resource.
    static let mp2 = DeveloperToolsSupport.ImageResource(name: "mp2", bundle: resourceBundle)

    /// The "mrd" asset catalog image resource.
    static let mrd = DeveloperToolsSupport.ImageResource(name: "mrd", bundle: resourceBundle)

    /// The "ncc" asset catalog image resource.
    static let ncc = DeveloperToolsSupport.ImageResource(name: "ncc", bundle: resourceBundle)

    /// The "ncc-white" asset catalog image resource.
    static let nccWhite = DeveloperToolsSupport.ImageResource(name: "ncc-white", bundle: resourceBundle)

    /// The "nec" asset catalog image resource.
    static let nec = DeveloperToolsSupport.ImageResource(name: "nec", bundle: resourceBundle)

    /// The "nem" asset catalog image resource.
    static let nem = DeveloperToolsSupport.ImageResource(name: "nem", bundle: resourceBundle)

    /// The "neo" asset catalog image resource.
    static let neo = DeveloperToolsSupport.ImageResource(name: "neo", bundle: resourceBundle)

    /// The "nms" asset catalog image resource.
    static let nms = DeveloperToolsSupport.ImageResource(name: "nms", bundle: resourceBundle)

    /// The "nph" asset catalog image resource.
    static let nph = DeveloperToolsSupport.ImageResource(name: "nph", bundle: resourceBundle)

    /// The "ody" asset catalog image resource.
    static let ody = DeveloperToolsSupport.ImageResource(name: "ody", bundle: resourceBundle)

    /// The "ogw" asset catalog image resource.
    static let ogw = DeveloperToolsSupport.ImageResource(name: "ogw", bundle: resourceBundle)

    /// The "onc" asset catalog image resource.
    static let onc = DeveloperToolsSupport.ImageResource(name: "onc", bundle: resourceBundle)

    /// The "one" asset catalog image resource.
    static let one = DeveloperToolsSupport.ImageResource(name: "one", bundle: resourceBundle)

    /// The "ons" asset catalog image resource.
    static let ons = DeveloperToolsSupport.ImageResource(name: "ons", bundle: resourceBundle)

    /// The "ori" asset catalog image resource.
    static let ori = DeveloperToolsSupport.ImageResource(name: "ori", bundle: resourceBundle)

    /// The "orzhov" asset catalog image resource.
    static let orzhov = DeveloperToolsSupport.ImageResource(name: "orzhov", bundle: resourceBundle)

    /// The "otc" asset catalog image resource.
    static let otc = DeveloperToolsSupport.ImageResource(name: "otc", bundle: resourceBundle)

    /// The "otc-inner" asset catalog image resource.
    static let otcInner = DeveloperToolsSupport.ImageResource(name: "otc-inner", bundle: resourceBundle)

    /// The "otj" asset catalog image resource.
    static let otj = DeveloperToolsSupport.ImageResource(name: "otj", bundle: resourceBundle)

    /// The "otp" asset catalog image resource.
    static let otp = DeveloperToolsSupport.ImageResource(name: "otp", bundle: resourceBundle)

    /// The "papac" asset catalog image resource.
    static let papac = DeveloperToolsSupport.ImageResource(name: "papac", bundle: resourceBundle)

    /// The "parl" asset catalog image resource.
    static let parl = DeveloperToolsSupport.ImageResource(name: "parl", bundle: resourceBundle)

    /// The "parl2" asset catalog image resource.
    static let parl2 = DeveloperToolsSupport.ImageResource(name: "parl2", bundle: resourceBundle)

    /// The "parl3" asset catalog image resource.
    static let parl3 = DeveloperToolsSupport.ImageResource(name: "parl3", bundle: resourceBundle)

    /// The "past" asset catalog image resource.
    static let past = DeveloperToolsSupport.ImageResource(name: "past", bundle: resourceBundle)

    /// The "pbook" asset catalog image resource.
    static let pbook = DeveloperToolsSupport.ImageResource(name: "pbook", bundle: resourceBundle)

    /// The "pc2" asset catalog image resource.
    static let pc2 = DeveloperToolsSupport.ImageResource(name: "pc2", bundle: resourceBundle)

    /// The "pca" asset catalog image resource.
    static let pca = DeveloperToolsSupport.ImageResource(name: "pca", bundle: resourceBundle)

    /// The "pcy" asset catalog image resource.
    static let pcy = DeveloperToolsSupport.ImageResource(name: "pcy", bundle: resourceBundle)

    /// The "pd2" asset catalog image resource.
    static let pd2 = DeveloperToolsSupport.ImageResource(name: "pd2", bundle: resourceBundle)

    /// The "pd3" asset catalog image resource.
    static let pd3 = DeveloperToolsSupport.ImageResource(name: "pd3", bundle: resourceBundle)

    /// The "pdep" asset catalog image resource.
    static let pdep = DeveloperToolsSupport.ImageResource(name: "pdep", bundle: resourceBundle)

    /// The "pdgc" asset catalog image resource.
    static let pdgc = DeveloperToolsSupport.ImageResource(name: "pdgc", bundle: resourceBundle)

    /// The "peuro" asset catalog image resource.
    static let peuro = DeveloperToolsSupport.ImageResource(name: "peuro", bundle: resourceBundle)

    /// The "pfnm" asset catalog image resource.
    static let pfnm = DeveloperToolsSupport.ImageResource(name: "pfnm", bundle: resourceBundle)

    /// The "pgru" asset catalog image resource.
    static let pgru = DeveloperToolsSupport.ImageResource(name: "pgru", bundle: resourceBundle)

    /// The "pheart" asset catalog image resource.
    static let pheart = DeveloperToolsSupport.ImageResource(name: "pheart", bundle: resourceBundle)

    /// The "pidw" asset catalog image resource.
    static let pidw = DeveloperToolsSupport.ImageResource(name: "pidw", bundle: resourceBundle)

    /// The "pio" asset catalog image resource.
    static let pio = DeveloperToolsSupport.ImageResource(name: "pio", bundle: resourceBundle)

    /// The "pip" asset catalog image resource.
    static let pip = DeveloperToolsSupport.ImageResource(name: "pip", bundle: resourceBundle)

    /// The "plc" asset catalog image resource.
    static let plc = DeveloperToolsSupport.ImageResource(name: "plc", bundle: resourceBundle)

    /// The "pleaf" asset catalog image resource.
    static let pleaf = DeveloperToolsSupport.ImageResource(name: "pleaf", bundle: resourceBundle)

    /// The "pls" asset catalog image resource.
    static let pls = DeveloperToolsSupport.ImageResource(name: "pls", bundle: resourceBundle)

    /// The "pm2" asset catalog image resource.
    static let pm2 = DeveloperToolsSupport.ImageResource(name: "pm2", bundle: resourceBundle)

    /// The "pma" asset catalog image resource.
    static let pma = DeveloperToolsSupport.ImageResource(name: "pma", bundle: resourceBundle)

    /// The "pmei" asset catalog image resource.
    static let pmei = DeveloperToolsSupport.ImageResource(name: "pmei", bundle: resourceBundle)

    /// The "pmodo" asset catalog image resource.
    static let pmodo = DeveloperToolsSupport.ImageResource(name: "pmodo", bundle: resourceBundle)

    /// The "pmps" asset catalog image resource.
    static let pmps = DeveloperToolsSupport.ImageResource(name: "pmps", bundle: resourceBundle)

    /// The "pmpu" asset catalog image resource.
    static let pmpu = DeveloperToolsSupport.ImageResource(name: "pmpu", bundle: resourceBundle)

    /// The "pmtg1" asset catalog image resource.
    static let pmtg1 = DeveloperToolsSupport.ImageResource(name: "pmtg1", bundle: resourceBundle)

    /// The "pmtg2" asset catalog image resource.
    static let pmtg2 = DeveloperToolsSupport.ImageResource(name: "pmtg2", bundle: resourceBundle)

    /// The "po2" asset catalog image resource.
    static let po2 = DeveloperToolsSupport.ImageResource(name: "po2", bundle: resourceBundle)

    /// The "por" asset catalog image resource.
    static let por = DeveloperToolsSupport.ImageResource(name: "por", bundle: resourceBundle)

    /// The "psalvat05" asset catalog image resource.
    static let psalvat05 = DeveloperToolsSupport.ImageResource(name: "psalvat05", bundle: resourceBundle)

    /// The "psalvat11" asset catalog image resource.
    static let psalvat11 = DeveloperToolsSupport.ImageResource(name: "psalvat11", bundle: resourceBundle)

    /// The "psega" asset catalog image resource.
    static let psega = DeveloperToolsSupport.ImageResource(name: "psega", bundle: resourceBundle)

    /// The "psum" asset catalog image resource.
    static let psum = DeveloperToolsSupport.ImageResource(name: "psum", bundle: resourceBundle)

    /// The "ptg" asset catalog image resource.
    static let ptg = DeveloperToolsSupport.ImageResource(name: "ptg", bundle: resourceBundle)

    /// The "ptk" asset catalog image resource.
    static let ptk = DeveloperToolsSupport.ImageResource(name: "ptk", bundle: resourceBundle)

    /// The "ptsa" asset catalog image resource.
    static let ptsa = DeveloperToolsSupport.ImageResource(name: "ptsa", bundle: resourceBundle)

    /// The "pxbox" asset catalog image resource.
    static let pxbox = DeveloperToolsSupport.ImageResource(name: "pxbox", bundle: resourceBundle)

    /// The "pz2" asset catalog image resource.
    static let pz2 = DeveloperToolsSupport.ImageResource(name: "pz2", bundle: resourceBundle)

    /// The "rakdos" asset catalog image resource.
    static let rakdos = DeveloperToolsSupport.ImageResource(name: "rakdos", bundle: resourceBundle)

    /// The "rav" asset catalog image resource.
    static let rav = DeveloperToolsSupport.ImageResource(name: "rav", bundle: resourceBundle)

    /// The "rex" asset catalog image resource.
    static let rex = DeveloperToolsSupport.ImageResource(name: "rex", bundle: resourceBundle)

    /// The "rix" asset catalog image resource.
    static let rix = DeveloperToolsSupport.ImageResource(name: "rix", bundle: resourceBundle)

    /// The "rna" asset catalog image resource.
    static let rna = DeveloperToolsSupport.ImageResource(name: "rna", bundle: resourceBundle)

    /// The "roe" asset catalog image resource.
    static let roe = DeveloperToolsSupport.ImageResource(name: "roe", bundle: resourceBundle)

    /// The "rtr" asset catalog image resource.
    static let rtr = DeveloperToolsSupport.ImageResource(name: "rtr", bundle: resourceBundle)

    /// The "rvr" asset catalog image resource.
    static let rvr = DeveloperToolsSupport.ImageResource(name: "rvr", bundle: resourceBundle)

    /// The "s00" asset catalog image resource.
    static let s00 = DeveloperToolsSupport.ImageResource(name: "s00", bundle: resourceBundle)

    /// The "s99" asset catalog image resource.
    static let s99 = DeveloperToolsSupport.ImageResource(name: "s99", bundle: resourceBundle)

    /// The "scg" asset catalog image resource.
    static let scg = DeveloperToolsSupport.ImageResource(name: "scg", bundle: resourceBundle)

    /// The "selesnya" asset catalog image resource.
    static let selesnya = DeveloperToolsSupport.ImageResource(name: "selesnya", bundle: resourceBundle)

    /// The "shm" asset catalog image resource.
    static let shm = DeveloperToolsSupport.ImageResource(name: "shm", bundle: resourceBundle)

    /// The "simic" asset catalog image resource.
    static let simic = DeveloperToolsSupport.ImageResource(name: "simic", bundle: resourceBundle)

    /// The "sld2" asset catalog image resource.
    static let sld2 = DeveloperToolsSupport.ImageResource(name: "sld2", bundle: resourceBundle)

    /// The "snc" asset catalog image resource.
    static let snc = DeveloperToolsSupport.ImageResource(name: "snc", bundle: resourceBundle)

    /// The "soi" asset catalog image resource.
    static let soi = DeveloperToolsSupport.ImageResource(name: "soi", bundle: resourceBundle)

    /// The "sok" asset catalog image resource.
    static let sok = DeveloperToolsSupport.ImageResource(name: "sok", bundle: resourceBundle)

    /// The "som" asset catalog image resource.
    static let som = DeveloperToolsSupport.ImageResource(name: "som", bundle: resourceBundle)

    /// The "spe" asset catalog image resource.
    static let spe = DeveloperToolsSupport.ImageResource(name: "spe", bundle: resourceBundle)

    /// The "spg" asset catalog image resource.
    static let spg = DeveloperToolsSupport.ImageResource(name: "spg", bundle: resourceBundle)

    /// The "spm" asset catalog image resource.
    static let spm = DeveloperToolsSupport.ImageResource(name: "spm", bundle: resourceBundle)

    /// The "spm-inner" asset catalog image resource.
    static let spmInner = DeveloperToolsSupport.ImageResource(name: "spm-inner", bundle: resourceBundle)

    /// The "ss1" asset catalog image resource.
    static let ss1 = DeveloperToolsSupport.ImageResource(name: "ss1", bundle: resourceBundle)

    /// The "ss2" asset catalog image resource.
    static let ss2 = DeveloperToolsSupport.ImageResource(name: "ss2", bundle: resourceBundle)

    /// The "ss3" asset catalog image resource.
    static let ss3 = DeveloperToolsSupport.ImageResource(name: "ss3", bundle: resourceBundle)

    /// The "sta" asset catalog image resource.
    static let sta = DeveloperToolsSupport.ImageResource(name: "sta", bundle: resourceBundle)

    /// The "sth" asset catalog image resource.
    static let sth = DeveloperToolsSupport.ImageResource(name: "sth", bundle: resourceBundle)

    /// The "stx" asset catalog image resource.
    static let stx = DeveloperToolsSupport.ImageResource(name: "stx", bundle: resourceBundle)

    /// The "td2" asset catalog image resource.
    static let td2 = DeveloperToolsSupport.ImageResource(name: "td2", bundle: resourceBundle)

    /// The "tdc" asset catalog image resource.
    static let tdc = DeveloperToolsSupport.ImageResource(name: "tdc", bundle: resourceBundle)

    /// The "tdm" asset catalog image resource.
    static let tdm = DeveloperToolsSupport.ImageResource(name: "tdm", bundle: resourceBundle)

    /// The "tdm-border" asset catalog image resource.
    static let tdmBorder = DeveloperToolsSupport.ImageResource(name: "tdm-border", bundle: resourceBundle)

    /// The "thb" asset catalog image resource.
    static let thb = DeveloperToolsSupport.ImageResource(name: "thb", bundle: resourceBundle)

    /// The "ths" asset catalog image resource.
    static let ths = DeveloperToolsSupport.ImageResource(name: "ths", bundle: resourceBundle)

    /// The "tla" asset catalog image resource.
    static let tla = DeveloperToolsSupport.ImageResource(name: "tla", bundle: resourceBundle)

    /// The "tla-border" asset catalog image resource.
    static let tlaBorder = DeveloperToolsSupport.ImageResource(name: "tla-border", bundle: resourceBundle)

    /// The "tla-inner" asset catalog image resource.
    static let tlaInner = DeveloperToolsSupport.ImageResource(name: "tla-inner", bundle: resourceBundle)

    /// The "tla-rarity" asset catalog image resource.
    static let tlaRarity = DeveloperToolsSupport.ImageResource(name: "tla-rarity", bundle: resourceBundle)

    /// The "tmp" asset catalog image resource.
    static let tmp = DeveloperToolsSupport.ImageResource(name: "tmp", bundle: resourceBundle)

    /// The "tor" asset catalog image resource.
    static let tor = DeveloperToolsSupport.ImageResource(name: "tor", bundle: resourceBundle)

    /// The "tpr" asset catalog image resource.
    static let tpr = DeveloperToolsSupport.ImageResource(name: "tpr", bundle: resourceBundle)

    /// The "tsp" asset catalog image resource.
    static let tsp = DeveloperToolsSupport.ImageResource(name: "tsp", bundle: resourceBundle)

    /// The "tsr" asset catalog image resource.
    static let tsr = DeveloperToolsSupport.ImageResource(name: "tsr", bundle: resourceBundle)

    /// The "uds" asset catalog image resource.
    static let uds = DeveloperToolsSupport.ImageResource(name: "uds", bundle: resourceBundle)

    /// The "ugl" asset catalog image resource.
    static let ugl = DeveloperToolsSupport.ImageResource(name: "ugl", bundle: resourceBundle)

    /// The "ulg" asset catalog image resource.
    static let ulg = DeveloperToolsSupport.ImageResource(name: "ulg", bundle: resourceBundle)

    /// The "uma" asset catalog image resource.
    static let uma = DeveloperToolsSupport.ImageResource(name: "uma", bundle: resourceBundle)

    /// The "una" asset catalog image resource.
    static let una = DeveloperToolsSupport.ImageResource(name: "una", bundle: resourceBundle)

    /// The "una-white" asset catalog image resource.
    static let unaWhite = DeveloperToolsSupport.ImageResource(name: "una-white", bundle: resourceBundle)

    /// The "und" asset catalog image resource.
    static let und = DeveloperToolsSupport.ImageResource(name: "und", bundle: resourceBundle)

    /// The "unf" asset catalog image resource.
    static let unf = DeveloperToolsSupport.ImageResource(name: "unf", bundle: resourceBundle)

    /// The "unh" asset catalog image resource.
    static let unh = DeveloperToolsSupport.ImageResource(name: "unh", bundle: resourceBundle)

    /// The "usg" asset catalog image resource.
    static let usg = DeveloperToolsSupport.ImageResource(name: "usg", bundle: resourceBundle)

    /// The "ust" asset catalog image resource.
    static let ust = DeveloperToolsSupport.ImageResource(name: "ust", bundle: resourceBundle)

    /// The "v09" asset catalog image resource.
    static let v09 = DeveloperToolsSupport.ImageResource(name: "v09", bundle: resourceBundle)

    /// The "v0x" asset catalog image resource.
    static let v0X = DeveloperToolsSupport.ImageResource(name: "v0x", bundle: resourceBundle)

    /// The "v10" asset catalog image resource.
    static let v10 = DeveloperToolsSupport.ImageResource(name: "v10", bundle: resourceBundle)

    /// The "v11" asset catalog image resource.
    static let v11 = DeveloperToolsSupport.ImageResource(name: "v11", bundle: resourceBundle)

    /// The "v12" asset catalog image resource.
    static let v12 = DeveloperToolsSupport.ImageResource(name: "v12", bundle: resourceBundle)

    /// The "v13" asset catalog image resource.
    static let v13 = DeveloperToolsSupport.ImageResource(name: "v13", bundle: resourceBundle)

    /// The "v14" asset catalog image resource.
    static let v14 = DeveloperToolsSupport.ImageResource(name: "v14", bundle: resourceBundle)

    /// The "v15" asset catalog image resource.
    static let v15 = DeveloperToolsSupport.ImageResource(name: "v15", bundle: resourceBundle)

    /// The "v16" asset catalog image resource.
    static let v16 = DeveloperToolsSupport.ImageResource(name: "v16", bundle: resourceBundle)

    /// The "v17" asset catalog image resource.
    static let v17 = DeveloperToolsSupport.ImageResource(name: "v17", bundle: resourceBundle)

    /// The "van" asset catalog image resource.
    static let van = DeveloperToolsSupport.ImageResource(name: "van", bundle: resourceBundle)

    /// The "vis" asset catalog image resource.
    static let vis = DeveloperToolsSupport.ImageResource(name: "vis", bundle: resourceBundle)

    /// The "vma" asset catalog image resource.
    static let vma = DeveloperToolsSupport.ImageResource(name: "vma", bundle: resourceBundle)

    /// The "voc" asset catalog image resource.
    static let voc = DeveloperToolsSupport.ImageResource(name: "voc", bundle: resourceBundle)

    /// The "vow" asset catalog image resource.
    static let vow = DeveloperToolsSupport.ImageResource(name: "vow", bundle: resourceBundle)

    /// The "w16" asset catalog image resource.
    static let w16 = DeveloperToolsSupport.ImageResource(name: "w16", bundle: resourceBundle)

    /// The "w17" asset catalog image resource.
    static let w17 = DeveloperToolsSupport.ImageResource(name: "w17", bundle: resourceBundle)

    /// The "war" asset catalog image resource.
    static let war = DeveloperToolsSupport.ImageResource(name: "war", bundle: resourceBundle)

    /// The "who" asset catalog image resource.
    static let who = DeveloperToolsSupport.ImageResource(name: "who", bundle: resourceBundle)

    /// The "woc" asset catalog image resource.
    static let woc = DeveloperToolsSupport.ImageResource(name: "woc", bundle: resourceBundle)

    /// The "woe" asset catalog image resource.
    static let woe = DeveloperToolsSupport.ImageResource(name: "woe", bundle: resourceBundle)

    /// The "wot" asset catalog image resource.
    static let wot = DeveloperToolsSupport.ImageResource(name: "wot", bundle: resourceBundle)

    /// The "wth" asset catalog image resource.
    static let wth = DeveloperToolsSupport.ImageResource(name: "wth", bundle: resourceBundle)

    /// The "wwk" asset catalog image resource.
    static let wwk = DeveloperToolsSupport.ImageResource(name: "wwk", bundle: resourceBundle)

    /// The "x1e" asset catalog image resource.
    static let x1E = DeveloperToolsSupport.ImageResource(name: "x1e", bundle: resourceBundle)

    /// The "x2e" asset catalog image resource.
    static let x2E = DeveloperToolsSupport.ImageResource(name: "x2e", bundle: resourceBundle)

    /// The "x2ps" asset catalog image resource.
    static let x2Ps = DeveloperToolsSupport.ImageResource(name: "x2ps", bundle: resourceBundle)

    /// The "x2u" asset catalog image resource.
    static let x2U = DeveloperToolsSupport.ImageResource(name: "x2u", bundle: resourceBundle)

    /// The "x3e" asset catalog image resource.
    static let x3E = DeveloperToolsSupport.ImageResource(name: "x3e", bundle: resourceBundle)

    /// The "x4ea" asset catalog image resource.
    static let x4Ea = DeveloperToolsSupport.ImageResource(name: "x4ea", bundle: resourceBundle)

    /// The "xcle" asset catalog image resource.
    static let xcle = DeveloperToolsSupport.ImageResource(name: "xcle", bundle: resourceBundle)

    /// The "xduels" asset catalog image resource.
    static let xduels = DeveloperToolsSupport.ImageResource(name: "xduels", bundle: resourceBundle)

    /// The "xice" asset catalog image resource.
    static let xice = DeveloperToolsSupport.ImageResource(name: "xice", bundle: resourceBundle)

    /// The "xlcu" asset catalog image resource.
    static let xlcu = DeveloperToolsSupport.ImageResource(name: "xlcu", bundle: resourceBundle)

    /// The "xln" asset catalog image resource.
    static let xln = DeveloperToolsSupport.ImageResource(name: "xln", bundle: resourceBundle)

    /// The "xmods" asset catalog image resource.
    static let xmods = DeveloperToolsSupport.ImageResource(name: "xmods", bundle: resourceBundle)

    /// The "xren" asset catalog image resource.
    static let xren = DeveloperToolsSupport.ImageResource(name: "xren", bundle: resourceBundle)

    /// The "xrin" asset catalog image resource.
    static let xrin = DeveloperToolsSupport.ImageResource(name: "xrin", bundle: resourceBundle)

    /// The "y22" asset catalog image resource.
    static let y22 = DeveloperToolsSupport.ImageResource(name: "y22", bundle: resourceBundle)

    /// The "y24" asset catalog image resource.
    static let y24 = DeveloperToolsSupport.ImageResource(name: "y24", bundle: resourceBundle)

    /// The "y25" asset catalog image resource.
    static let y25 = DeveloperToolsSupport.ImageResource(name: "y25", bundle: resourceBundle)

    /// The "ydmu" asset catalog image resource.
    static let ydmu = DeveloperToolsSupport.ImageResource(name: "ydmu", bundle: resourceBundle)

    /// The "zen" asset catalog image resource.
    static let zen = DeveloperToolsSupport.ImageResource(name: "zen", bundle: resourceBundle)

    /// The "znc" asset catalog image resource.
    static let znc = DeveloperToolsSupport.ImageResource(name: "znc", bundle: resourceBundle)

    /// The "zne" asset catalog image resource.
    static let zne = DeveloperToolsSupport.ImageResource(name: "zne", bundle: resourceBundle)

    /// The "znr" asset catalog image resource.
    static let znr = DeveloperToolsSupport.ImageResource(name: "znr", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AccentColor" asset catalog color.
    static var accent: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "Blue Theme" asset catalog color.
    static var blueTheme: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueTheme)
#else
        .init()
#endif
    }

    /// The "Green Theme" asset catalog color.
    static var greenTheme: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenTheme)
#else
        .init()
#endif
    }

    /// The "Orange Theme" asset catalog color.
    static var orangeTheme: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .orangeTheme)
#else
        .init()
#endif
    }

    /// The "Red Theme" asset catalog color.
    static var redTheme: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .redTheme)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AccentColor" asset catalog color.
    static var accent: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .accent)
#else
        .init()
#endif
    }

    /// The "Blue Theme" asset catalog color.
    static var blueTheme: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .blueTheme)
#else
        .init()
#endif
    }

    /// The "Green Theme" asset catalog color.
    static var greenTheme: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .greenTheme)
#else
        .init()
#endif
    }

    /// The "Orange Theme" asset catalog color.
    static var orangeTheme: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .orangeTheme)
#else
        .init()
#endif
    }

    /// The "Red Theme" asset catalog color.
    static var redTheme: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .redTheme)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "Blue Theme" asset catalog color.
    static var blueTheme: SwiftUI.Color { .init(.blueTheme) }

    /// The "Green Theme" asset catalog color.
    static var greenTheme: SwiftUI.Color { .init(.greenTheme) }

    /// The "Orange Theme" asset catalog color.
    static var orangeTheme: SwiftUI.Color { .init(.orangeTheme) }

    /// The "Red Theme" asset catalog color.
    static var redTheme: SwiftUI.Color { .init(.redTheme) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AccentColor" asset catalog color.
    static var accent: SwiftUI.Color { .init(.accent) }

    /// The "Blue Theme" asset catalog color.
    static var blueTheme: SwiftUI.Color { .init(.blueTheme) }

    /// The "Green Theme" asset catalog color.
    static var greenTheme: SwiftUI.Color { .init(.greenTheme) }

    /// The "Orange Theme" asset catalog color.
    static var orangeTheme: SwiftUI.Color { .init(.orangeTheme) }

    /// The "Red Theme" asset catalog color.
    static var redTheme: SwiftUI.Color { .init(.redTheme) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "10e" asset catalog image.
    static var _10E: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._10E)
#else
        .init()
#endif
    }

    /// The "2ed" asset catalog image.
    static var _2Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._2Ed)
#else
        .init()
#endif
    }

    /// The "2x2" asset catalog image.
    static var _2X2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._2X2)
#else
        .init()
#endif
    }

    /// The "2xm" asset catalog image.
    static var _2Xm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._2Xm)
#else
        .init()
#endif
    }

    /// The "3ed" asset catalog image.
    static var _3Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._3Ed)
#else
        .init()
#endif
    }

    /// The "40k" asset catalog image.
    static var _40K: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._40K)
#else
        .init()
#endif
    }

    /// The "40k-border" asset catalog image.
    static var _40KBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._40KBorder)
#else
        .init()
#endif
    }

    /// The "40k-white" asset catalog image.
    static var _40KWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._40KWhite)
#else
        .init()
#endif
    }

    /// The "4ed" asset catalog image.
    static var _4Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._4Ed)
#else
        .init()
#endif
    }

    /// The "5dn" asset catalog image.
    static var _5Dn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._5Dn)
#else
        .init()
#endif
    }

    /// The "5ed" asset catalog image.
    static var _5Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._5Ed)
#else
        .init()
#endif
    }

    /// The "6ed" asset catalog image.
    static var _6Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._6Ed)
#else
        .init()
#endif
    }

    /// The "7ed" asset catalog image.
    static var _7Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._7Ed)
#else
        .init()
#endif
    }

    /// The "8ed" asset catalog image.
    static var _8Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._8Ed)
#else
        .init()
#endif
    }

    /// The "9ed" asset catalog image.
    static var _9Ed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: ._9Ed)
#else
        .init()
#endif
    }

    /// The "B" asset catalog image.
    static var B: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .B)
#else
        .init()
#endif
    }

    /// The "B2" asset catalog image.
    static var B_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .B_2)
#else
        .init()
#endif
    }

    /// The "BG" asset catalog image.
    static var BG: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .BG)
#else
        .init()
#endif
    }

    /// The "BP" asset catalog image.
    static var BP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .BP)
#else
        .init()
#endif
    }

    /// The "BR" asset catalog image.
    static var BR: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .BR)
#else
        .init()
#endif
    }

    /// The "CP" asset catalog image.
    static var CP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .CP)
#else
        .init()
#endif
    }

    /// The "CardHoarder" asset catalog image.
    static var cardHoarder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cardHoarder)
#else
        .init()
#endif
    }

    /// The "CardMarket" asset catalog image.
    static var cardMarket: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cardMarket)
#else
        .init()
#endif
    }

    /// The "G" asset catalog image.
    static var G: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .G)
#else
        .init()
#endif
    }

    /// The "G2" asset catalog image.
    static var G_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .G_2)
#else
        .init()
#endif
    }

    /// The "GP" asset catalog image.
    static var GP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .GP)
#else
        .init()
#endif
    }

    /// The "GU" asset catalog image.
    static var GU: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .GU)
#else
        .init()
#endif
    }

    /// The "GW" asset catalog image.
    static var GW: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .GW)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "MtgBinder" asset catalog image.
    static var mtgBinder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtgBinder)
#else
        .init()
#endif
    }

    /// The "MtgBinderDark" asset catalog image.
    static var mtgBinderDark: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtgBinderDark)
#else
        .init()
#endif
    }

    /// The "MtgBinderIcon" asset catalog image.
    static var mtgBinderIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtgBinderIcon)
#else
        .init()
#endif
    }

    /// The "MtgDeck" asset catalog image.
    static var mtgDeck: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtgDeck)
#else
        .init()
#endif
    }

    /// The "MtgLogo" asset catalog image.
    static var mtgLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mtgLogo)
#else
        .init()
#endif
    }

    /// The "R" asset catalog image.
    static var R: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .R)
#else
        .init()
#endif
    }

    /// The "R2" asset catalog image.
    static var R_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .R_2)
#else
        .init()
#endif
    }

    /// The "RG" asset catalog image.
    static var RG: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .RG)
#else
        .init()
#endif
    }

    /// The "RP" asset catalog image.
    static var RP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .RP)
#else
        .init()
#endif
    }

    /// The "RW" asset catalog image.
    static var RW: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .RW)
#else
        .init()
#endif
    }

    /// The "S" asset catalog image.
    static var S: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .S)
#else
        .init()
#endif
    }

    /// The "TcgPlayer" asset catalog image.
    static var tcgPlayer: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tcgPlayer)
#else
        .init()
#endif
    }

    /// The "U" asset catalog image.
    static var U: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .U)
#else
        .init()
#endif
    }

    /// The "U2" asset catalog image.
    static var U_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .U_2)
#else
        .init()
#endif
    }

    /// The "UB" asset catalog image.
    static var UB: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .UB)
#else
        .init()
#endif
    }

    /// The "UP" asset catalog image.
    static var UP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .UP)
#else
        .init()
#endif
    }

    /// The "UR" asset catalog image.
    static var UR: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .UR)
#else
        .init()
#endif
    }

    /// The "W" asset catalog image.
    static var W: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .W)
#else
        .init()
#endif
    }

    /// The "W2" asset catalog image.
    static var W_2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .W_2)
#else
        .init()
#endif
    }

    /// The "WB" asset catalog image.
    static var WB: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .WB)
#else
        .init()
#endif
    }

    /// The "WP" asset catalog image.
    static var WP: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .WP)
#else
        .init()
#endif
    }

    /// The "WU" asset catalog image.
    static var WU: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .WU)
#else
        .init()
#endif
    }

    /// The "a25" asset catalog image.
    static var a25: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .a25)
#else
        .init()
#endif
    }

    /// The "acr" asset catalog image.
    static var acr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .acr)
#else
        .init()
#endif
    }

    /// The "aer" asset catalog image.
    static var aer: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .aer)
#else
        .init()
#endif
    }

    /// The "afc" asset catalog image.
    static var afc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .afc)
#else
        .init()
#endif
    }

    /// The "afc-border" asset catalog image.
    static var afcBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .afcBorder)
#else
        .init()
#endif
    }

    /// The "afr" asset catalog image.
    static var afr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .afr)
#else
        .init()
#endif
    }

    /// The "afr-border" asset catalog image.
    static var afrBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .afrBorder)
#else
        .init()
#endif
    }

    /// The "akh" asset catalog image.
    static var akh: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .akh)
#else
        .init()
#endif
    }

    /// The "akr" asset catalog image.
    static var akr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .akr)
#else
        .init()
#endif
    }

    /// The "ala" asset catalog image.
    static var ala: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ala)
#else
        .init()
#endif
    }

    /// The "apc" asset catalog image.
    static var apc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .apc)
#else
        .init()
#endif
    }

    /// The "arb" asset catalog image.
    static var arb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .arb)
#else
        .init()
#endif
    }

    /// The "arc" asset catalog image.
    static var arc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .arc)
#else
        .init()
#endif
    }

    /// The "arn" asset catalog image.
    static var arn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .arn)
#else
        .init()
#endif
    }

    /// The "ath" asset catalog image.
    static var ath: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ath)
#else
        .init()
#endif
    }

    /// The "atq" asset catalog image.
    static var atq: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .atq)
#else
        .init()
#endif
    }

    /// The "avr" asset catalog image.
    static var avr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avr)
#else
        .init()
#endif
    }

    /// The "azorius" asset catalog image.
    static var azorius: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .azorius)
#else
        .init()
#endif
    }

    /// The "bbd" asset catalog image.
    static var bbd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bbd)
#else
        .init()
#endif
    }

    /// The "bcore" asset catalog image.
    static var bcore: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bcore)
#else
        .init()
#endif
    }

    /// The "bfz" asset catalog image.
    static var bfz: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bfz)
#else
        .init()
#endif
    }

    /// The "big" asset catalog image.
    static var big: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .big)
#else
        .init()
#endif
    }

    /// The "blb" asset catalog image.
    static var blb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blb)
#else
        .init()
#endif
    }

    /// The "blc" asset catalog image.
    static var blc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blc)
#else
        .init()
#endif
    }

    /// The "bng" asset catalog image.
    static var bng: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bng)
#else
        .init()
#endif
    }

    /// The "bok" asset catalog image.
    static var bok: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bok)
#else
        .init()
#endif
    }

    /// The "boros" asset catalog image.
    static var boros: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .boros)
#else
        .init()
#endif
    }

    /// The "bot" asset catalog image.
    static var bot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bot)
#else
        .init()
#endif
    }

    /// The "br" asset catalog image.
    static var br: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .br)
#else
        .init()
#endif
    }

    /// The "brb" asset catalog image.
    static var brb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brb)
#else
        .init()
#endif
    }

    /// The "brc" asset catalog image.
    static var brc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brc)
#else
        .init()
#endif
    }

    /// The "bro" asset catalog image.
    static var bro: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bro)
#else
        .init()
#endif
    }

    /// The "brr" asset catalog image.
    static var brr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brr)
#else
        .init()
#endif
    }

    /// The "btd" asset catalog image.
    static var btd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .btd)
#else
        .init()
#endif
    }

    /// The "c13" asset catalog image.
    static var c13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c13)
#else
        .init()
#endif
    }

    /// The "c14" asset catalog image.
    static var c14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c14)
#else
        .init()
#endif
    }

    /// The "c15" asset catalog image.
    static var c15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c15)
#else
        .init()
#endif
    }

    /// The "c16" asset catalog image.
    static var c16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c16)
#else
        .init()
#endif
    }

    /// The "c17" asset catalog image.
    static var c17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c17)
#else
        .init()
#endif
    }

    /// The "c18" asset catalog image.
    static var c18: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c18)
#else
        .init()
#endif
    }

    /// The "c19" asset catalog image.
    static var c19: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c19)
#else
        .init()
#endif
    }

    /// The "c20" asset catalog image.
    static var c20: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c20)
#else
        .init()
#endif
    }

    /// The "c21" asset catalog image.
    static var c21: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c21)
#else
        .init()
#endif
    }

    /// The "c21-border" asset catalog image.
    static var c21Border: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .c21Border)
#else
        .init()
#endif
    }

    /// The "cc1" asset catalog image.
    static var cc1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cc1)
#else
        .init()
#endif
    }

    /// The "cc2" asset catalog image.
    static var cc2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cc2)
#else
        .init()
#endif
    }

    /// The "cc2-border" asset catalog image.
    static var cc2Border: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cc2Border)
#else
        .init()
#endif
    }

    /// The "chk" asset catalog image.
    static var chk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chk)
#else
        .init()
#endif
    }

    /// The "chr" asset catalog image.
    static var chr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chr)
#else
        .init()
#endif
    }

    /// The "clb" asset catalog image.
    static var clb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .clb)
#else
        .init()
#endif
    }

    /// The "clb-white" asset catalog image.
    static var clbWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .clbWhite)
#else
        .init()
#endif
    }

    /// The "clu" asset catalog image.
    static var clu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .clu)
#else
        .init()
#endif
    }

    /// The "cm1" asset catalog image.
    static var cm1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cm1)
#else
        .init()
#endif
    }

    /// The "cm2" asset catalog image.
    static var cm2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cm2)
#else
        .init()
#endif
    }

    /// The "cma" asset catalog image.
    static var cma: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cma)
#else
        .init()
#endif
    }

    /// The "cmd" asset catalog image.
    static var cmd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cmd)
#else
        .init()
#endif
    }

    /// The "cmm" asset catalog image.
    static var cmm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cmm)
#else
        .init()
#endif
    }

    /// The "cmr" asset catalog image.
    static var cmr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cmr)
#else
        .init()
#endif
    }

    /// The "cn2" asset catalog image.
    static var cn2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cn2)
#else
        .init()
#endif
    }

    /// The "cns" asset catalog image.
    static var cns: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cns)
#else
        .init()
#endif
    }

    /// The "con_" asset catalog image.
    static var con: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .con)
#else
        .init()
#endif
    }

    /// The "csp" asset catalog image.
    static var csp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .csp)
#else
        .init()
#endif
    }

    /// The "dd2" asset catalog image.
    static var dd2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dd2)
#else
        .init()
#endif
    }

    /// The "ddc" asset catalog image.
    static var ddc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddc)
#else
        .init()
#endif
    }

    /// The "ddd" asset catalog image.
    static var ddd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddd)
#else
        .init()
#endif
    }

    /// The "dde" asset catalog image.
    static var dde: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dde)
#else
        .init()
#endif
    }

    /// The "ddf" asset catalog image.
    static var ddf: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddf)
#else
        .init()
#endif
    }

    /// The "ddg" asset catalog image.
    static var ddg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddg)
#else
        .init()
#endif
    }

    /// The "ddh" asset catalog image.
    static var ddh: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddh)
#else
        .init()
#endif
    }

    /// The "ddi" asset catalog image.
    static var ddi: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddi)
#else
        .init()
#endif
    }

    /// The "ddj" asset catalog image.
    static var ddj: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddj)
#else
        .init()
#endif
    }

    /// The "ddk" asset catalog image.
    static var ddk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddk)
#else
        .init()
#endif
    }

    /// The "ddl" asset catalog image.
    static var ddl: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddl)
#else
        .init()
#endif
    }

    /// The "ddm" asset catalog image.
    static var ddm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddm)
#else
        .init()
#endif
    }

    /// The "ddn" asset catalog image.
    static var ddn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddn)
#else
        .init()
#endif
    }

    /// The "ddo" asset catalog image.
    static var ddo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddo)
#else
        .init()
#endif
    }

    /// The "ddp" asset catalog image.
    static var ddp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddp)
#else
        .init()
#endif
    }

    /// The "ddq" asset catalog image.
    static var ddq: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddq)
#else
        .init()
#endif
    }

    /// The "ddr" asset catalog image.
    static var ddr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddr)
#else
        .init()
#endif
    }

    /// The "dds" asset catalog image.
    static var dds: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dds)
#else
        .init()
#endif
    }

    /// The "ddt" asset catalog image.
    static var ddt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddt)
#else
        .init()
#endif
    }

    /// The "ddu" asset catalog image.
    static var ddu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ddu)
#else
        .init()
#endif
    }

    /// The "dft" asset catalog image.
    static var dft: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dft)
#else
        .init()
#endif
    }

    /// The "dft-rarity" asset catalog image.
    static var dftRarity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dftRarity)
#else
        .init()
#endif
    }

    /// The "dgm" asset catalog image.
    static var dgm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dgm)
#else
        .init()
#endif
    }

    /// The "dimir" asset catalog image.
    static var dimir: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dimir)
#else
        .init()
#endif
    }

    /// The "dis" asset catalog image.
    static var dis: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dis)
#else
        .init()
#endif
    }

    /// The "dka" asset catalog image.
    static var dka: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dka)
#else
        .init()
#endif
    }

    /// The "dkm" asset catalog image.
    static var dkm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dkm)
#else
        .init()
#endif
    }

    /// The "dmc" asset catalog image.
    static var dmc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dmc)
#else
        .init()
#endif
    }

    /// The "dmc-border" asset catalog image.
    static var dmcBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dmcBorder)
#else
        .init()
#endif
    }

    /// The "dmc-white" asset catalog image.
    static var dmcWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dmcWhite)
#else
        .init()
#endif
    }

    /// The "dmr" asset catalog image.
    static var dmr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dmr)
#else
        .init()
#endif
    }

    /// The "dmu" asset catalog image.
    static var dmu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dmu)
#else
        .init()
#endif
    }

    /// The "dom" asset catalog image.
    static var dom: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dom)
#else
        .init()
#endif
    }

    /// The "dpa" asset catalog image.
    static var dpa: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dpa)
#else
        .init()
#endif
    }

    /// The "drb" asset catalog image.
    static var drb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drb)
#else
        .init()
#endif
    }

    /// The "drc" asset catalog image.
    static var drc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drc)
#else
        .init()
#endif
    }

    /// The "drc-border" asset catalog image.
    static var drcBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drcBorder)
#else
        .init()
#endif
    }

    /// The "drc-inner" asset catalog image.
    static var drcInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drcInner)
#else
        .init()
#endif
    }

    /// The "drc-rarity" asset catalog image.
    static var drcRarity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drcRarity)
#else
        .init()
#endif
    }

    /// The "drk" asset catalog image.
    static var drk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .drk)
#else
        .init()
#endif
    }

    /// The "dsc" asset catalog image.
    static var dsc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dsc)
#else
        .init()
#endif
    }

    /// The "dsc-border" asset catalog image.
    static var dscBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dscBorder)
#else
        .init()
#endif
    }

    /// The "dsc-white" asset catalog image.
    static var dscWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dscWhite)
#else
        .init()
#endif
    }

    /// The "dsk" asset catalog image.
    static var dsk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dsk)
#else
        .init()
#endif
    }

    /// The "dst" asset catalog image.
    static var dst: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dst)
#else
        .init()
#endif
    }

    /// The "dtk" asset catalog image.
    static var dtk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dtk)
#else
        .init()
#endif
    }

    /// The "dvk" asset catalog image.
    static var dvk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .dvk)
#else
        .init()
#endif
    }

    /// The "e01" asset catalog image.
    static var e01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .e01)
#else
        .init()
#endif
    }

    /// The "e02" asset catalog image.
    static var e02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .e02)
#else
        .init()
#endif
    }

    /// The "eld" asset catalog image.
    static var eld: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eld)
#else
        .init()
#endif
    }

    /// The "ema" asset catalog image.
    static var ema: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ema)
#else
        .init()
#endif
    }

    /// The "emn" asset catalog image.
    static var emn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emn)
#else
        .init()
#endif
    }

    /// The "eoc" asset catalog image.
    static var eoc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eoc)
#else
        .init()
#endif
    }

    /// The "eoc-inner" asset catalog image.
    static var eocInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eocInner)
#else
        .init()
#endif
    }

    /// The "eoe" asset catalog image.
    static var eoe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eoe)
#else
        .init()
#endif
    }

    /// The "eos" asset catalog image.
    static var eos: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eos)
#else
        .init()
#endif
    }

    /// The "eos-border" asset catalog image.
    static var eosBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eosBorder)
#else
        .init()
#endif
    }

    /// The "eve" asset catalog image.
    static var eve: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eve)
#else
        .init()
#endif
    }

    /// The "evg" asset catalog image.
    static var evg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .evg)
#else
        .init()
#endif
    }

    /// The "exo" asset catalog image.
    static var exo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .exo)
#else
        .init()
#endif
    }

    /// The "exp" asset catalog image.
    static var exp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .exp)
#else
        .init()
#endif
    }

    /// The "fdc" asset catalog image.
    static var fdc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fdc)
#else
        .init()
#endif
    }

    /// The "fdn" asset catalog image.
    static var fdn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fdn)
#else
        .init()
#endif
    }

    /// The "fem" asset catalog image.
    static var fem: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fem)
#else
        .init()
#endif
    }

    /// The "fic" asset catalog image.
    static var fic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fic)
#else
        .init()
#endif
    }

    /// The "fin" asset catalog image.
    static var fin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fin)
#else
        .init()
#endif
    }

    /// The "fin-border" asset catalog image.
    static var finBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .finBorder)
#else
        .init()
#endif
    }

    /// The "fin-rarity" asset catalog image.
    static var finRarity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .finRarity)
#else
        .init()
#endif
    }

    /// The "frf" asset catalog image.
    static var frf: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .frf)
#else
        .init()
#endif
    }

    /// The "fut" asset catalog image.
    static var fut: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .fut)
#else
        .init()
#endif
    }

    /// The "gn2" asset catalog image.
    static var gn2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gn2)
#else
        .init()
#endif
    }

    /// The "gn3" asset catalog image.
    static var gn3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gn3)
#else
        .init()
#endif
    }

    /// The "gnt" asset catalog image.
    static var gnt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gnt)
#else
        .init()
#endif
    }

    /// The "golgari" asset catalog image.
    static var golgari: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .golgari)
#else
        .init()
#endif
    }

    /// The "gpt" asset catalog image.
    static var gpt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gpt)
#else
        .init()
#endif
    }

    /// The "grn" asset catalog image.
    static var grn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .grn)
#else
        .init()
#endif
    }

    /// The "gruul" asset catalog image.
    static var gruul: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gruul)
#else
        .init()
#endif
    }

    /// The "gs1" asset catalog image.
    static var gs1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gs1)
#else
        .init()
#endif
    }

    /// The "gtc" asset catalog image.
    static var gtc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gtc)
#else
        .init()
#endif
    }

    /// The "h09" asset catalog image.
    static var h09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .h09)
#else
        .init()
#endif
    }

    /// The "h17" asset catalog image.
    static var h17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .h17)
#else
        .init()
#endif
    }

    /// The "ha1" asset catalog image.
    static var ha1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ha1)
#else
        .init()
#endif
    }

    /// The "hbg" asset catalog image.
    static var hbg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hbg)
#else
        .init()
#endif
    }

    /// The "hml" asset catalog image.
    static var hml: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hml)
#else
        .init()
#endif
    }

    /// The "hop" asset catalog image.
    static var hop: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hop)
#else
        .init()
#endif
    }

    /// The "hou" asset catalog image.
    static var hou: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hou)
#else
        .init()
#endif
    }

    /// The "ice" asset catalog image.
    static var ice: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ice)
#else
        .init()
#endif
    }

    /// The "ice2" asset catalog image.
    static var ice2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ice2)
#else
        .init()
#endif
    }

    /// The "iko" asset catalog image.
    static var iko: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .iko)
#else
        .init()
#endif
    }

    /// The "ima" asset catalog image.
    static var ima: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ima)
#else
        .init()
#endif
    }

    /// The "inr" asset catalog image.
    static var inr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .inr)
#else
        .init()
#endif
    }

    /// The "inv" asset catalog image.
    static var inv: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .inv)
#else
        .init()
#endif
    }

    /// The "isd" asset catalog image.
    static var isd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .isd)
#else
        .init()
#endif
    }

    /// The "izzet" asset catalog image.
    static var izzet: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .izzet)
#else
        .init()
#endif
    }

    /// The "j20" asset catalog image.
    static var j20: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j20)
#else
        .init()
#endif
    }

    /// The "j21" asset catalog image.
    static var j21: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j21)
#else
        .init()
#endif
    }

    /// The "j21-outline" asset catalog image.
    static var j21Outline: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j21Outline)
#else
        .init()
#endif
    }

    /// The "j22" asset catalog image.
    static var j22: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j22)
#else
        .init()
#endif
    }

    /// The "j25" asset catalog image.
    static var j25: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j25)
#else
        .init()
#endif
    }

    /// The "j25-alt" asset catalog image.
    static var j25Alt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .j25Alt)
#else
        .init()
#endif
    }

    /// The "jmp" asset catalog image.
    static var jmp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .jmp)
#else
        .init()
#endif
    }

    /// The "jou" asset catalog image.
    static var jou: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .jou)
#else
        .init()
#endif
    }

    /// The "jud" asset catalog image.
    static var jud: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .jud)
#else
        .init()
#endif
    }

    /// The "khc" asset catalog image.
    static var khc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .khc)
#else
        .init()
#endif
    }

    /// The "khc-inner" asset catalog image.
    static var khcInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .khcInner)
#else
        .init()
#endif
    }

    /// The "khc-rarity" asset catalog image.
    static var khcRarity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .khcRarity)
#else
        .init()
#endif
    }

    /// The "khm" asset catalog image.
    static var khm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .khm)
#else
        .init()
#endif
    }

    /// The "kld" asset catalog image.
    static var kld: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kld)
#else
        .init()
#endif
    }

    /// The "klr" asset catalog image.
    static var klr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .klr)
#else
        .init()
#endif
    }

    /// The "ktk" asset catalog image.
    static var ktk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ktk)
#else
        .init()
#endif
    }

    /// The "lcc" asset catalog image.
    static var lcc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lcc)
#else
        .init()
#endif
    }

    /// The "lci" asset catalog image.
    static var lci: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lci)
#else
        .init()
#endif
    }

    /// The "lea" asset catalog image.
    static var lea: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lea)
#else
        .init()
#endif
    }

    /// The "leb" asset catalog image.
    static var leb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .leb)
#else
        .init()
#endif
    }

    /// The "leg" asset catalog image.
    static var leg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .leg)
#else
        .init()
#endif
    }

    /// The "lgn" asset catalog image.
    static var lgn: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lgn)
#else
        .init()
#endif
    }

    /// The "lrw" asset catalog image.
    static var lrw: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .lrw)
#else
        .init()
#endif
    }

    /// The "ltc" asset catalog image.
    static var ltc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ltc)
#else
        .init()
#endif
    }

    /// The "ltc-white" asset catalog image.
    static var ltcWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ltcWhite)
#else
        .init()
#endif
    }

    /// The "ltr" asset catalog image.
    static var ltr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ltr)
#else
        .init()
#endif
    }

    /// The "m10" asset catalog image.
    static var m10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m10)
#else
        .init()
#endif
    }

    /// The "m11" asset catalog image.
    static var m11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m11)
#else
        .init()
#endif
    }

    /// The "m12" asset catalog image.
    static var m12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m12)
#else
        .init()
#endif
    }

    /// The "m13" asset catalog image.
    static var m13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m13)
#else
        .init()
#endif
    }

    /// The "m14" asset catalog image.
    static var m14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m14)
#else
        .init()
#endif
    }

    /// The "m15" asset catalog image.
    static var m15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m15)
#else
        .init()
#endif
    }

    /// The "m19" asset catalog image.
    static var m19: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m19)
#else
        .init()
#endif
    }

    /// The "m20" asset catalog image.
    static var m20: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m20)
#else
        .init()
#endif
    }

    /// The "m21" asset catalog image.
    static var m21: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m21)
#else
        .init()
#endif
    }

    /// The "m3c" asset catalog image.
    static var m3C: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m3C)
#else
        .init()
#endif
    }

    /// The "m3c-inner" asset catalog image.
    static var m3CInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .m3CInner)
#else
        .init()
#endif
    }

    /// The "mar" asset catalog image.
    static var mar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mar)
#else
        .init()
#endif
    }

    /// The "mat" asset catalog image.
    static var mat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mat)
#else
        .init()
#endif
    }

    /// The "mb1" asset catalog image.
    static var mb1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mb1)
#else
        .init()
#endif
    }

    /// The "mb2" asset catalog image.
    static var mb2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mb2)
#else
        .init()
#endif
    }

    /// The "mbs" asset catalog image.
    static var mbs: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mbs)
#else
        .init()
#endif
    }

    /// The "md1" asset catalog image.
    static var md1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .md1)
#else
        .init()
#endif
    }

    /// The "me1" asset catalog image.
    static var me1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .me1)
#else
        .init()
#endif
    }

    /// The "me2" asset catalog image.
    static var me2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .me2)
#else
        .init()
#endif
    }

    /// The "me3" asset catalog image.
    static var me3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .me3)
#else
        .init()
#endif
    }

    /// The "me4" asset catalog image.
    static var me4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .me4)
#else
        .init()
#endif
    }

    /// The "med" asset catalog image.
    static var med: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .med)
#else
        .init()
#endif
    }

    /// The "mh1" asset catalog image.
    static var mh1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mh1)
#else
        .init()
#endif
    }

    /// The "mh2" asset catalog image.
    static var mh2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mh2)
#else
        .init()
#endif
    }

    /// The "mh3" asset catalog image.
    static var mh3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mh3)
#else
        .init()
#endif
    }

    /// The "mic" asset catalog image.
    static var mic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mic)
#else
        .init()
#endif
    }

    /// The "mid" asset catalog image.
    static var mid: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mid)
#else
        .init()
#endif
    }

    /// The "mid-border" asset catalog image.
    static var midBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .midBorder)
#else
        .init()
#endif
    }

    /// The "mir" asset catalog image.
    static var mir: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mir)
#else
        .init()
#endif
    }

    /// The "mkc" asset catalog image.
    static var mkc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mkc)
#else
        .init()
#endif
    }

    /// The "mkm" asset catalog image.
    static var mkm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mkm)
#else
        .init()
#endif
    }

    /// The "mm2" asset catalog image.
    static var mm2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mm2)
#else
        .init()
#endif
    }

    /// The "mm3" asset catalog image.
    static var mm3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mm3)
#else
        .init()
#endif
    }

    /// The "mma" asset catalog image.
    static var mma: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mma)
#else
        .init()
#endif
    }

    /// The "mmq" asset catalog image.
    static var mmq: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mmq)
#else
        .init()
#endif
    }

    /// The "moc" asset catalog image.
    static var moc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .moc)
#else
        .init()
#endif
    }

    /// The "mom" asset catalog image.
    static var mom: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mom)
#else
        .init()
#endif
    }

    /// The "mor" asset catalog image.
    static var mor: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mor)
#else
        .init()
#endif
    }

    /// The "mp1" asset catalog image.
    static var mp1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mp1)
#else
        .init()
#endif
    }

    /// The "mp2" asset catalog image.
    static var mp2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mp2)
#else
        .init()
#endif
    }

    /// The "mrd" asset catalog image.
    static var mrd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mrd)
#else
        .init()
#endif
    }

    /// The "ncc" asset catalog image.
    static var ncc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ncc)
#else
        .init()
#endif
    }

    /// The "ncc-white" asset catalog image.
    static var nccWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .nccWhite)
#else
        .init()
#endif
    }

    /// The "nec" asset catalog image.
    static var nec: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .nec)
#else
        .init()
#endif
    }

    /// The "nem" asset catalog image.
    static var nem: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .nem)
#else
        .init()
#endif
    }

    /// The "neo" asset catalog image.
    static var neo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .neo)
#else
        .init()
#endif
    }

    /// The "nms" asset catalog image.
    static var nms: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .nms)
#else
        .init()
#endif
    }

    /// The "nph" asset catalog image.
    static var nph: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .nph)
#else
        .init()
#endif
    }

    /// The "ody" asset catalog image.
    static var ody: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ody)
#else
        .init()
#endif
    }

    /// The "ogw" asset catalog image.
    static var ogw: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ogw)
#else
        .init()
#endif
    }

    /// The "onc" asset catalog image.
    static var onc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onc)
#else
        .init()
#endif
    }

    /// The "one" asset catalog image.
    static var one: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .one)
#else
        .init()
#endif
    }

    /// The "ons" asset catalog image.
    static var ons: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ons)
#else
        .init()
#endif
    }

    /// The "ori" asset catalog image.
    static var ori: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ori)
#else
        .init()
#endif
    }

    /// The "orzhov" asset catalog image.
    static var orzhov: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .orzhov)
#else
        .init()
#endif
    }

    /// The "otc" asset catalog image.
    static var otc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .otc)
#else
        .init()
#endif
    }

    /// The "otc-inner" asset catalog image.
    static var otcInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .otcInner)
#else
        .init()
#endif
    }

    /// The "otj" asset catalog image.
    static var otj: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .otj)
#else
        .init()
#endif
    }

    /// The "otp" asset catalog image.
    static var otp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .otp)
#else
        .init()
#endif
    }

    /// The "papac" asset catalog image.
    static var papac: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .papac)
#else
        .init()
#endif
    }

    /// The "parl" asset catalog image.
    static var parl: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .parl)
#else
        .init()
#endif
    }

    /// The "parl2" asset catalog image.
    static var parl2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .parl2)
#else
        .init()
#endif
    }

    /// The "parl3" asset catalog image.
    static var parl3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .parl3)
#else
        .init()
#endif
    }

    /// The "past" asset catalog image.
    static var past: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .past)
#else
        .init()
#endif
    }

    /// The "pbook" asset catalog image.
    static var pbook: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pbook)
#else
        .init()
#endif
    }

    /// The "pc2" asset catalog image.
    static var pc2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pc2)
#else
        .init()
#endif
    }

    /// The "pca" asset catalog image.
    static var pca: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pca)
#else
        .init()
#endif
    }

    /// The "pcy" asset catalog image.
    static var pcy: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pcy)
#else
        .init()
#endif
    }

    /// The "pd2" asset catalog image.
    static var pd2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pd2)
#else
        .init()
#endif
    }

    /// The "pd3" asset catalog image.
    static var pd3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pd3)
#else
        .init()
#endif
    }

    /// The "pdep" asset catalog image.
    static var pdep: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pdep)
#else
        .init()
#endif
    }

    /// The "pdgc" asset catalog image.
    static var pdgc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pdgc)
#else
        .init()
#endif
    }

    /// The "peuro" asset catalog image.
    static var peuro: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .peuro)
#else
        .init()
#endif
    }

    /// The "pfnm" asset catalog image.
    static var pfnm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pfnm)
#else
        .init()
#endif
    }

    /// The "pgru" asset catalog image.
    static var pgru: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pgru)
#else
        .init()
#endif
    }

    /// The "pheart" asset catalog image.
    static var pheart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pheart)
#else
        .init()
#endif
    }

    /// The "pidw" asset catalog image.
    static var pidw: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pidw)
#else
        .init()
#endif
    }

    /// The "pio" asset catalog image.
    static var pio: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pio)
#else
        .init()
#endif
    }

    /// The "pip" asset catalog image.
    static var pip: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pip)
#else
        .init()
#endif
    }

    /// The "plc" asset catalog image.
    static var plc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .plc)
#else
        .init()
#endif
    }

    /// The "pleaf" asset catalog image.
    static var pleaf: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pleaf)
#else
        .init()
#endif
    }

    /// The "pls" asset catalog image.
    static var pls: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pls)
#else
        .init()
#endif
    }

    /// The "pm2" asset catalog image.
    static var pm2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pm2)
#else
        .init()
#endif
    }

    /// The "pma" asset catalog image.
    static var pma: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pma)
#else
        .init()
#endif
    }

    /// The "pmei" asset catalog image.
    static var pmei: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmei)
#else
        .init()
#endif
    }

    /// The "pmodo" asset catalog image.
    static var pmodo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmodo)
#else
        .init()
#endif
    }

    /// The "pmps" asset catalog image.
    static var pmps: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmps)
#else
        .init()
#endif
    }

    /// The "pmpu" asset catalog image.
    static var pmpu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmpu)
#else
        .init()
#endif
    }

    /// The "pmtg1" asset catalog image.
    static var pmtg1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmtg1)
#else
        .init()
#endif
    }

    /// The "pmtg2" asset catalog image.
    static var pmtg2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pmtg2)
#else
        .init()
#endif
    }

    /// The "po2" asset catalog image.
    static var po2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .po2)
#else
        .init()
#endif
    }

    /// The "por" asset catalog image.
    static var por: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .por)
#else
        .init()
#endif
    }

    /// The "psalvat05" asset catalog image.
    static var psalvat05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psalvat05)
#else
        .init()
#endif
    }

    /// The "psalvat11" asset catalog image.
    static var psalvat11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psalvat11)
#else
        .init()
#endif
    }

    /// The "psega" asset catalog image.
    static var psega: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psega)
#else
        .init()
#endif
    }

    /// The "psum" asset catalog image.
    static var psum: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .psum)
#else
        .init()
#endif
    }

    /// The "ptg" asset catalog image.
    static var ptg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ptg)
#else
        .init()
#endif
    }

    /// The "ptk" asset catalog image.
    static var ptk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ptk)
#else
        .init()
#endif
    }

    /// The "ptsa" asset catalog image.
    static var ptsa: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ptsa)
#else
        .init()
#endif
    }

    /// The "pxbox" asset catalog image.
    static var pxbox: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pxbox)
#else
        .init()
#endif
    }

    /// The "pz2" asset catalog image.
    static var pz2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pz2)
#else
        .init()
#endif
    }

    /// The "rakdos" asset catalog image.
    static var rakdos: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rakdos)
#else
        .init()
#endif
    }

    /// The "rav" asset catalog image.
    static var rav: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rav)
#else
        .init()
#endif
    }

    /// The "rex" asset catalog image.
    static var rex: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rex)
#else
        .init()
#endif
    }

    /// The "rix" asset catalog image.
    static var rix: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rix)
#else
        .init()
#endif
    }

    /// The "rna" asset catalog image.
    static var rna: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rna)
#else
        .init()
#endif
    }

    /// The "roe" asset catalog image.
    static var roe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .roe)
#else
        .init()
#endif
    }

    /// The "rtr" asset catalog image.
    static var rtr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rtr)
#else
        .init()
#endif
    }

    /// The "rvr" asset catalog image.
    static var rvr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rvr)
#else
        .init()
#endif
    }

    /// The "s00" asset catalog image.
    static var s00: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .s00)
#else
        .init()
#endif
    }

    /// The "s99" asset catalog image.
    static var s99: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .s99)
#else
        .init()
#endif
    }

    /// The "scg" asset catalog image.
    static var scg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scg)
#else
        .init()
#endif
    }

    /// The "selesnya" asset catalog image.
    static var selesnya: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .selesnya)
#else
        .init()
#endif
    }

    /// The "shm" asset catalog image.
    static var shm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shm)
#else
        .init()
#endif
    }

    /// The "simic" asset catalog image.
    static var simic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .simic)
#else
        .init()
#endif
    }

    /// The "sld2" asset catalog image.
    static var sld2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sld2)
#else
        .init()
#endif
    }

    /// The "snc" asset catalog image.
    static var snc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snc)
#else
        .init()
#endif
    }

    /// The "soi" asset catalog image.
    static var soi: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .soi)
#else
        .init()
#endif
    }

    /// The "sok" asset catalog image.
    static var sok: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sok)
#else
        .init()
#endif
    }

    /// The "som" asset catalog image.
    static var som: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .som)
#else
        .init()
#endif
    }

    /// The "spe" asset catalog image.
    static var spe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .spe)
#else
        .init()
#endif
    }

    /// The "spg" asset catalog image.
    static var spg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .spg)
#else
        .init()
#endif
    }

    /// The "spm" asset catalog image.
    static var spm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .spm)
#else
        .init()
#endif
    }

    /// The "spm-inner" asset catalog image.
    static var spmInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .spmInner)
#else
        .init()
#endif
    }

    /// The "ss1" asset catalog image.
    static var ss1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ss1)
#else
        .init()
#endif
    }

    /// The "ss2" asset catalog image.
    static var ss2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ss2)
#else
        .init()
#endif
    }

    /// The "ss3" asset catalog image.
    static var ss3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ss3)
#else
        .init()
#endif
    }

    /// The "sta" asset catalog image.
    static var sta: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sta)
#else
        .init()
#endif
    }

    /// The "sth" asset catalog image.
    static var sth: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .sth)
#else
        .init()
#endif
    }

    /// The "stx" asset catalog image.
    static var stx: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stx)
#else
        .init()
#endif
    }

    /// The "td2" asset catalog image.
    static var td2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .td2)
#else
        .init()
#endif
    }

    /// The "tdc" asset catalog image.
    static var tdc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tdc)
#else
        .init()
#endif
    }

    /// The "tdm" asset catalog image.
    static var tdm: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tdm)
#else
        .init()
#endif
    }

    /// The "tdm-border" asset catalog image.
    static var tdmBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tdmBorder)
#else
        .init()
#endif
    }

    /// The "thb" asset catalog image.
    static var thb: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .thb)
#else
        .init()
#endif
    }

    /// The "ths" asset catalog image.
    static var ths: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ths)
#else
        .init()
#endif
    }

    /// The "tla" asset catalog image.
    static var tla: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tla)
#else
        .init()
#endif
    }

    /// The "tla-border" asset catalog image.
    static var tlaBorder: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tlaBorder)
#else
        .init()
#endif
    }

    /// The "tla-inner" asset catalog image.
    static var tlaInner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tlaInner)
#else
        .init()
#endif
    }

    /// The "tla-rarity" asset catalog image.
    static var tlaRarity: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tlaRarity)
#else
        .init()
#endif
    }

    /// The "tmp" asset catalog image.
    static var tmp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tmp)
#else
        .init()
#endif
    }

    /// The "tor" asset catalog image.
    static var tor: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tor)
#else
        .init()
#endif
    }

    /// The "tpr" asset catalog image.
    static var tpr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tpr)
#else
        .init()
#endif
    }

    /// The "tsp" asset catalog image.
    static var tsp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tsp)
#else
        .init()
#endif
    }

    /// The "tsr" asset catalog image.
    static var tsr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tsr)
#else
        .init()
#endif
    }

    /// The "uds" asset catalog image.
    static var uds: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .uds)
#else
        .init()
#endif
    }

    /// The "ugl" asset catalog image.
    static var ugl: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ugl)
#else
        .init()
#endif
    }

    /// The "ulg" asset catalog image.
    static var ulg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ulg)
#else
        .init()
#endif
    }

    /// The "uma" asset catalog image.
    static var uma: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .uma)
#else
        .init()
#endif
    }

    /// The "una" asset catalog image.
    static var una: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .una)
#else
        .init()
#endif
    }

    /// The "una-white" asset catalog image.
    static var unaWhite: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .unaWhite)
#else
        .init()
#endif
    }

    /// The "und" asset catalog image.
    static var und: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .und)
#else
        .init()
#endif
    }

    /// The "unf" asset catalog image.
    static var unf: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .unf)
#else
        .init()
#endif
    }

    /// The "unh" asset catalog image.
    static var unh: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .unh)
#else
        .init()
#endif
    }

    /// The "usg" asset catalog image.
    static var usg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .usg)
#else
        .init()
#endif
    }

    /// The "ust" asset catalog image.
    static var ust: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ust)
#else
        .init()
#endif
    }

    /// The "v09" asset catalog image.
    static var v09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v09)
#else
        .init()
#endif
    }

    /// The "v0x" asset catalog image.
    static var v0X: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v0X)
#else
        .init()
#endif
    }

    /// The "v10" asset catalog image.
    static var v10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v10)
#else
        .init()
#endif
    }

    /// The "v11" asset catalog image.
    static var v11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v11)
#else
        .init()
#endif
    }

    /// The "v12" asset catalog image.
    static var v12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v12)
#else
        .init()
#endif
    }

    /// The "v13" asset catalog image.
    static var v13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v13)
#else
        .init()
#endif
    }

    /// The "v14" asset catalog image.
    static var v14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v14)
#else
        .init()
#endif
    }

    /// The "v15" asset catalog image.
    static var v15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v15)
#else
        .init()
#endif
    }

    /// The "v16" asset catalog image.
    static var v16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v16)
#else
        .init()
#endif
    }

    /// The "v17" asset catalog image.
    static var v17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .v17)
#else
        .init()
#endif
    }

    /// The "van" asset catalog image.
    static var van: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .van)
#else
        .init()
#endif
    }

    /// The "vis" asset catalog image.
    static var vis: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .vis)
#else
        .init()
#endif
    }

    /// The "vma" asset catalog image.
    static var vma: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .vma)
#else
        .init()
#endif
    }

    /// The "voc" asset catalog image.
    static var voc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .voc)
#else
        .init()
#endif
    }

    /// The "vow" asset catalog image.
    static var vow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .vow)
#else
        .init()
#endif
    }

    /// The "w16" asset catalog image.
    static var w16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .w16)
#else
        .init()
#endif
    }

    /// The "w17" asset catalog image.
    static var w17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .w17)
#else
        .init()
#endif
    }

    /// The "war" asset catalog image.
    static var war: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .war)
#else
        .init()
#endif
    }

    /// The "who" asset catalog image.
    static var who: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .who)
#else
        .init()
#endif
    }

    /// The "woc" asset catalog image.
    static var woc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .woc)
#else
        .init()
#endif
    }

    /// The "woe" asset catalog image.
    static var woe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .woe)
#else
        .init()
#endif
    }

    /// The "wot" asset catalog image.
    static var wot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wot)
#else
        .init()
#endif
    }

    /// The "wth" asset catalog image.
    static var wth: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wth)
#else
        .init()
#endif
    }

    /// The "wwk" asset catalog image.
    static var wwk: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .wwk)
#else
        .init()
#endif
    }

    /// The "x1e" asset catalog image.
    static var x1E: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x1E)
#else
        .init()
#endif
    }

    /// The "x2e" asset catalog image.
    static var x2E: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x2E)
#else
        .init()
#endif
    }

    /// The "x2ps" asset catalog image.
    static var x2Ps: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x2Ps)
#else
        .init()
#endif
    }

    /// The "x2u" asset catalog image.
    static var x2U: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x2U)
#else
        .init()
#endif
    }

    /// The "x3e" asset catalog image.
    static var x3E: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x3E)
#else
        .init()
#endif
    }

    /// The "x4ea" asset catalog image.
    static var x4Ea: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .x4Ea)
#else
        .init()
#endif
    }

    /// The "xcle" asset catalog image.
    static var xcle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xcle)
#else
        .init()
#endif
    }

    /// The "xduels" asset catalog image.
    static var xduels: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xduels)
#else
        .init()
#endif
    }

    /// The "xice" asset catalog image.
    static var xice: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xice)
#else
        .init()
#endif
    }

    /// The "xlcu" asset catalog image.
    static var xlcu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xlcu)
#else
        .init()
#endif
    }

    /// The "xln" asset catalog image.
    static var xln: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xln)
#else
        .init()
#endif
    }

    /// The "xmods" asset catalog image.
    static var xmods: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xmods)
#else
        .init()
#endif
    }

    /// The "xren" asset catalog image.
    static var xren: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xren)
#else
        .init()
#endif
    }

    /// The "xrin" asset catalog image.
    static var xrin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xrin)
#else
        .init()
#endif
    }

    /// The "y22" asset catalog image.
    static var y22: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .y22)
#else
        .init()
#endif
    }

    /// The "y24" asset catalog image.
    static var y24: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .y24)
#else
        .init()
#endif
    }

    /// The "y25" asset catalog image.
    static var y25: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .y25)
#else
        .init()
#endif
    }

    /// The "ydmu" asset catalog image.
    static var ydmu: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ydmu)
#else
        .init()
#endif
    }

    /// The "zen" asset catalog image.
    static var zen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zen)
#else
        .init()
#endif
    }

    /// The "znc" asset catalog image.
    static var znc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .znc)
#else
        .init()
#endif
    }

    /// The "zne" asset catalog image.
    static var zne: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zne)
#else
        .init()
#endif
    }

    /// The "znr" asset catalog image.
    static var znr: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .znr)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "10e" asset catalog image.
    static var _10E: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._10E)
#else
        .init()
#endif
    }

    /// The "2ed" asset catalog image.
    static var _2Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._2Ed)
#else
        .init()
#endif
    }

    /// The "2x2" asset catalog image.
    static var _2X2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._2X2)
#else
        .init()
#endif
    }

    /// The "2xm" asset catalog image.
    static var _2Xm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._2Xm)
#else
        .init()
#endif
    }

    /// The "3ed" asset catalog image.
    static var _3Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._3Ed)
#else
        .init()
#endif
    }

    /// The "40k" asset catalog image.
    static var _40K: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._40K)
#else
        .init()
#endif
    }

    /// The "40k-border" asset catalog image.
    static var _40KBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._40KBorder)
#else
        .init()
#endif
    }

    /// The "40k-white" asset catalog image.
    static var _40KWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._40KWhite)
#else
        .init()
#endif
    }

    /// The "4ed" asset catalog image.
    static var _4Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._4Ed)
#else
        .init()
#endif
    }

    /// The "5dn" asset catalog image.
    static var _5Dn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._5Dn)
#else
        .init()
#endif
    }

    /// The "5ed" asset catalog image.
    static var _5Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._5Ed)
#else
        .init()
#endif
    }

    /// The "6ed" asset catalog image.
    static var _6Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._6Ed)
#else
        .init()
#endif
    }

    /// The "7ed" asset catalog image.
    static var _7Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._7Ed)
#else
        .init()
#endif
    }

    /// The "8ed" asset catalog image.
    static var _8Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._8Ed)
#else
        .init()
#endif
    }

    /// The "9ed" asset catalog image.
    static var _9Ed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: ._9Ed)
#else
        .init()
#endif
    }

    /// The "B" asset catalog image.
    static var B: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .B)
#else
        .init()
#endif
    }

    /// The "B2" asset catalog image.
    static var B_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .B_2)
#else
        .init()
#endif
    }

    /// The "BG" asset catalog image.
    static var BG: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .BG)
#else
        .init()
#endif
    }

    /// The "BP" asset catalog image.
    static var BP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .BP)
#else
        .init()
#endif
    }

    /// The "BR" asset catalog image.
    static var BR: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .BR)
#else
        .init()
#endif
    }

    /// The "CP" asset catalog image.
    static var CP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .CP)
#else
        .init()
#endif
    }

    /// The "CardHoarder" asset catalog image.
    static var cardHoarder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cardHoarder)
#else
        .init()
#endif
    }

    /// The "CardMarket" asset catalog image.
    static var cardMarket: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cardMarket)
#else
        .init()
#endif
    }

    /// The "G" asset catalog image.
    static var G: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .G)
#else
        .init()
#endif
    }

    /// The "G2" asset catalog image.
    static var G_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .G_2)
#else
        .init()
#endif
    }

    /// The "GP" asset catalog image.
    static var GP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .GP)
#else
        .init()
#endif
    }

    /// The "GU" asset catalog image.
    static var GU: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .GU)
#else
        .init()
#endif
    }

    /// The "GW" asset catalog image.
    static var GW: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .GW)
#else
        .init()
#endif
    }

    /// The "Logo" asset catalog image.
    static var logo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "MtgBinder" asset catalog image.
    static var mtgBinder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtgBinder)
#else
        .init()
#endif
    }

    /// The "MtgBinderDark" asset catalog image.
    static var mtgBinderDark: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtgBinderDark)
#else
        .init()
#endif
    }

    /// The "MtgBinderIcon" asset catalog image.
    static var mtgBinderIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtgBinderIcon)
#else
        .init()
#endif
    }

    /// The "MtgDeck" asset catalog image.
    static var mtgDeck: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtgDeck)
#else
        .init()
#endif
    }

    /// The "MtgLogo" asset catalog image.
    static var mtgLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mtgLogo)
#else
        .init()
#endif
    }

    /// The "R" asset catalog image.
    static var R: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .R)
#else
        .init()
#endif
    }

    /// The "R2" asset catalog image.
    static var R_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .R_2)
#else
        .init()
#endif
    }

    /// The "RG" asset catalog image.
    static var RG: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .RG)
#else
        .init()
#endif
    }

    /// The "RP" asset catalog image.
    static var RP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .RP)
#else
        .init()
#endif
    }

    /// The "RW" asset catalog image.
    static var RW: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .RW)
#else
        .init()
#endif
    }

    /// The "S" asset catalog image.
    static var S: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .S)
#else
        .init()
#endif
    }

    /// The "TcgPlayer" asset catalog image.
    static var tcgPlayer: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tcgPlayer)
#else
        .init()
#endif
    }

    /// The "U" asset catalog image.
    static var U: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .U)
#else
        .init()
#endif
    }

    /// The "U2" asset catalog image.
    static var U_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .U_2)
#else
        .init()
#endif
    }

    /// The "UB" asset catalog image.
    static var UB: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .UB)
#else
        .init()
#endif
    }

    /// The "UP" asset catalog image.
    static var UP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .UP)
#else
        .init()
#endif
    }

    /// The "UR" asset catalog image.
    static var UR: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .UR)
#else
        .init()
#endif
    }

    /// The "W" asset catalog image.
    static var W: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .W)
#else
        .init()
#endif
    }

    /// The "W2" asset catalog image.
    static var W_2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .W_2)
#else
        .init()
#endif
    }

    /// The "WB" asset catalog image.
    static var WB: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .WB)
#else
        .init()
#endif
    }

    /// The "WP" asset catalog image.
    static var WP: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .WP)
#else
        .init()
#endif
    }

    /// The "WU" asset catalog image.
    static var WU: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .WU)
#else
        .init()
#endif
    }

    /// The "a25" asset catalog image.
    static var a25: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .a25)
#else
        .init()
#endif
    }

    /// The "acr" asset catalog image.
    static var acr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .acr)
#else
        .init()
#endif
    }

    /// The "aer" asset catalog image.
    static var aer: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .aer)
#else
        .init()
#endif
    }

    /// The "afc" asset catalog image.
    static var afc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .afc)
#else
        .init()
#endif
    }

    /// The "afc-border" asset catalog image.
    static var afcBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .afcBorder)
#else
        .init()
#endif
    }

    /// The "afr" asset catalog image.
    static var afr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .afr)
#else
        .init()
#endif
    }

    /// The "afr-border" asset catalog image.
    static var afrBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .afrBorder)
#else
        .init()
#endif
    }

    /// The "akh" asset catalog image.
    static var akh: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .akh)
#else
        .init()
#endif
    }

    /// The "akr" asset catalog image.
    static var akr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .akr)
#else
        .init()
#endif
    }

    /// The "ala" asset catalog image.
    static var ala: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ala)
#else
        .init()
#endif
    }

    /// The "apc" asset catalog image.
    static var apc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .apc)
#else
        .init()
#endif
    }

    /// The "arb" asset catalog image.
    static var arb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .arb)
#else
        .init()
#endif
    }

    /// The "arc" asset catalog image.
    static var arc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .arc)
#else
        .init()
#endif
    }

    /// The "arn" asset catalog image.
    static var arn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .arn)
#else
        .init()
#endif
    }

    /// The "ath" asset catalog image.
    static var ath: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ath)
#else
        .init()
#endif
    }

    /// The "atq" asset catalog image.
    static var atq: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .atq)
#else
        .init()
#endif
    }

    /// The "avr" asset catalog image.
    static var avr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avr)
#else
        .init()
#endif
    }

    /// The "azorius" asset catalog image.
    static var azorius: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .azorius)
#else
        .init()
#endif
    }

    /// The "bbd" asset catalog image.
    static var bbd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bbd)
#else
        .init()
#endif
    }

    /// The "bcore" asset catalog image.
    static var bcore: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bcore)
#else
        .init()
#endif
    }

    /// The "bfz" asset catalog image.
    static var bfz: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bfz)
#else
        .init()
#endif
    }

    /// The "big" asset catalog image.
    static var big: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .big)
#else
        .init()
#endif
    }

    /// The "blb" asset catalog image.
    static var blb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blb)
#else
        .init()
#endif
    }

    /// The "blc" asset catalog image.
    static var blc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blc)
#else
        .init()
#endif
    }

    /// The "bng" asset catalog image.
    static var bng: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bng)
#else
        .init()
#endif
    }

    /// The "bok" asset catalog image.
    static var bok: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bok)
#else
        .init()
#endif
    }

    /// The "boros" asset catalog image.
    static var boros: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .boros)
#else
        .init()
#endif
    }

    /// The "bot" asset catalog image.
    static var bot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bot)
#else
        .init()
#endif
    }

    /// The "br" asset catalog image.
    static var br: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .br)
#else
        .init()
#endif
    }

    /// The "brb" asset catalog image.
    static var brb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brb)
#else
        .init()
#endif
    }

    /// The "brc" asset catalog image.
    static var brc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brc)
#else
        .init()
#endif
    }

    /// The "bro" asset catalog image.
    static var bro: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bro)
#else
        .init()
#endif
    }

    /// The "brr" asset catalog image.
    static var brr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brr)
#else
        .init()
#endif
    }

    /// The "btd" asset catalog image.
    static var btd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .btd)
#else
        .init()
#endif
    }

    /// The "c13" asset catalog image.
    static var c13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c13)
#else
        .init()
#endif
    }

    /// The "c14" asset catalog image.
    static var c14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c14)
#else
        .init()
#endif
    }

    /// The "c15" asset catalog image.
    static var c15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c15)
#else
        .init()
#endif
    }

    /// The "c16" asset catalog image.
    static var c16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c16)
#else
        .init()
#endif
    }

    /// The "c17" asset catalog image.
    static var c17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c17)
#else
        .init()
#endif
    }

    /// The "c18" asset catalog image.
    static var c18: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c18)
#else
        .init()
#endif
    }

    /// The "c19" asset catalog image.
    static var c19: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c19)
#else
        .init()
#endif
    }

    /// The "c20" asset catalog image.
    static var c20: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c20)
#else
        .init()
#endif
    }

    /// The "c21" asset catalog image.
    static var c21: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c21)
#else
        .init()
#endif
    }

    /// The "c21-border" asset catalog image.
    static var c21Border: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .c21Border)
#else
        .init()
#endif
    }

    /// The "cc1" asset catalog image.
    static var cc1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cc1)
#else
        .init()
#endif
    }

    /// The "cc2" asset catalog image.
    static var cc2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cc2)
#else
        .init()
#endif
    }

    /// The "cc2-border" asset catalog image.
    static var cc2Border: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cc2Border)
#else
        .init()
#endif
    }

    /// The "chk" asset catalog image.
    static var chk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chk)
#else
        .init()
#endif
    }

    /// The "chr" asset catalog image.
    static var chr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chr)
#else
        .init()
#endif
    }

    /// The "clb" asset catalog image.
    static var clb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .clb)
#else
        .init()
#endif
    }

    /// The "clb-white" asset catalog image.
    static var clbWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .clbWhite)
#else
        .init()
#endif
    }

    /// The "clu" asset catalog image.
    static var clu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .clu)
#else
        .init()
#endif
    }

    /// The "cm1" asset catalog image.
    static var cm1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cm1)
#else
        .init()
#endif
    }

    /// The "cm2" asset catalog image.
    static var cm2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cm2)
#else
        .init()
#endif
    }

    /// The "cma" asset catalog image.
    static var cma: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cma)
#else
        .init()
#endif
    }

    /// The "cmd" asset catalog image.
    static var cmd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cmd)
#else
        .init()
#endif
    }

    /// The "cmm" asset catalog image.
    static var cmm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cmm)
#else
        .init()
#endif
    }

    /// The "cmr" asset catalog image.
    static var cmr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cmr)
#else
        .init()
#endif
    }

    /// The "cn2" asset catalog image.
    static var cn2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cn2)
#else
        .init()
#endif
    }

    /// The "cns" asset catalog image.
    static var cns: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cns)
#else
        .init()
#endif
    }

    /// The "con_" asset catalog image.
    static var con: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .con)
#else
        .init()
#endif
    }

    /// The "csp" asset catalog image.
    static var csp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .csp)
#else
        .init()
#endif
    }

    /// The "dd2" asset catalog image.
    static var dd2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dd2)
#else
        .init()
#endif
    }

    /// The "ddc" asset catalog image.
    static var ddc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddc)
#else
        .init()
#endif
    }

    /// The "ddd" asset catalog image.
    static var ddd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddd)
#else
        .init()
#endif
    }

    /// The "dde" asset catalog image.
    static var dde: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dde)
#else
        .init()
#endif
    }

    /// The "ddf" asset catalog image.
    static var ddf: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddf)
#else
        .init()
#endif
    }

    /// The "ddg" asset catalog image.
    static var ddg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddg)
#else
        .init()
#endif
    }

    /// The "ddh" asset catalog image.
    static var ddh: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddh)
#else
        .init()
#endif
    }

    /// The "ddi" asset catalog image.
    static var ddi: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddi)
#else
        .init()
#endif
    }

    /// The "ddj" asset catalog image.
    static var ddj: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddj)
#else
        .init()
#endif
    }

    /// The "ddk" asset catalog image.
    static var ddk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddk)
#else
        .init()
#endif
    }

    /// The "ddl" asset catalog image.
    static var ddl: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddl)
#else
        .init()
#endif
    }

    /// The "ddm" asset catalog image.
    static var ddm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddm)
#else
        .init()
#endif
    }

    /// The "ddn" asset catalog image.
    static var ddn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddn)
#else
        .init()
#endif
    }

    /// The "ddo" asset catalog image.
    static var ddo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddo)
#else
        .init()
#endif
    }

    /// The "ddp" asset catalog image.
    static var ddp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddp)
#else
        .init()
#endif
    }

    /// The "ddq" asset catalog image.
    static var ddq: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddq)
#else
        .init()
#endif
    }

    /// The "ddr" asset catalog image.
    static var ddr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddr)
#else
        .init()
#endif
    }

    /// The "dds" asset catalog image.
    static var dds: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dds)
#else
        .init()
#endif
    }

    /// The "ddt" asset catalog image.
    static var ddt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddt)
#else
        .init()
#endif
    }

    /// The "ddu" asset catalog image.
    static var ddu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ddu)
#else
        .init()
#endif
    }

    /// The "dft" asset catalog image.
    static var dft: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dft)
#else
        .init()
#endif
    }

    /// The "dft-rarity" asset catalog image.
    static var dftRarity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dftRarity)
#else
        .init()
#endif
    }

    /// The "dgm" asset catalog image.
    static var dgm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dgm)
#else
        .init()
#endif
    }

    /// The "dimir" asset catalog image.
    static var dimir: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dimir)
#else
        .init()
#endif
    }

    /// The "dis" asset catalog image.
    static var dis: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dis)
#else
        .init()
#endif
    }

    /// The "dka" asset catalog image.
    static var dka: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dka)
#else
        .init()
#endif
    }

    /// The "dkm" asset catalog image.
    static var dkm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dkm)
#else
        .init()
#endif
    }

    /// The "dmc" asset catalog image.
    static var dmc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dmc)
#else
        .init()
#endif
    }

    /// The "dmc-border" asset catalog image.
    static var dmcBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dmcBorder)
#else
        .init()
#endif
    }

    /// The "dmc-white" asset catalog image.
    static var dmcWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dmcWhite)
#else
        .init()
#endif
    }

    /// The "dmr" asset catalog image.
    static var dmr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dmr)
#else
        .init()
#endif
    }

    /// The "dmu" asset catalog image.
    static var dmu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dmu)
#else
        .init()
#endif
    }

    /// The "dom" asset catalog image.
    static var dom: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dom)
#else
        .init()
#endif
    }

    /// The "dpa" asset catalog image.
    static var dpa: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dpa)
#else
        .init()
#endif
    }

    /// The "drb" asset catalog image.
    static var drb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drb)
#else
        .init()
#endif
    }

    /// The "drc" asset catalog image.
    static var drc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drc)
#else
        .init()
#endif
    }

    /// The "drc-border" asset catalog image.
    static var drcBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drcBorder)
#else
        .init()
#endif
    }

    /// The "drc-inner" asset catalog image.
    static var drcInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drcInner)
#else
        .init()
#endif
    }

    /// The "drc-rarity" asset catalog image.
    static var drcRarity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drcRarity)
#else
        .init()
#endif
    }

    /// The "drk" asset catalog image.
    static var drk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .drk)
#else
        .init()
#endif
    }

    /// The "dsc" asset catalog image.
    static var dsc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dsc)
#else
        .init()
#endif
    }

    /// The "dsc-border" asset catalog image.
    static var dscBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dscBorder)
#else
        .init()
#endif
    }

    /// The "dsc-white" asset catalog image.
    static var dscWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dscWhite)
#else
        .init()
#endif
    }

    /// The "dsk" asset catalog image.
    static var dsk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dsk)
#else
        .init()
#endif
    }

    /// The "dst" asset catalog image.
    static var dst: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dst)
#else
        .init()
#endif
    }

    /// The "dtk" asset catalog image.
    static var dtk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dtk)
#else
        .init()
#endif
    }

    /// The "dvk" asset catalog image.
    static var dvk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .dvk)
#else
        .init()
#endif
    }

    /// The "e01" asset catalog image.
    static var e01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .e01)
#else
        .init()
#endif
    }

    /// The "e02" asset catalog image.
    static var e02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .e02)
#else
        .init()
#endif
    }

    /// The "eld" asset catalog image.
    static var eld: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eld)
#else
        .init()
#endif
    }

    /// The "ema" asset catalog image.
    static var ema: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ema)
#else
        .init()
#endif
    }

    /// The "emn" asset catalog image.
    static var emn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emn)
#else
        .init()
#endif
    }

    /// The "eoc" asset catalog image.
    static var eoc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eoc)
#else
        .init()
#endif
    }

    /// The "eoc-inner" asset catalog image.
    static var eocInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eocInner)
#else
        .init()
#endif
    }

    /// The "eoe" asset catalog image.
    static var eoe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eoe)
#else
        .init()
#endif
    }

    /// The "eos" asset catalog image.
    static var eos: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eos)
#else
        .init()
#endif
    }

    /// The "eos-border" asset catalog image.
    static var eosBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eosBorder)
#else
        .init()
#endif
    }

    /// The "eve" asset catalog image.
    static var eve: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eve)
#else
        .init()
#endif
    }

    /// The "evg" asset catalog image.
    static var evg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .evg)
#else
        .init()
#endif
    }

    /// The "exo" asset catalog image.
    static var exo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .exo)
#else
        .init()
#endif
    }

    /// The "exp" asset catalog image.
    static var exp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .exp)
#else
        .init()
#endif
    }

    /// The "fdc" asset catalog image.
    static var fdc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fdc)
#else
        .init()
#endif
    }

    /// The "fdn" asset catalog image.
    static var fdn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fdn)
#else
        .init()
#endif
    }

    /// The "fem" asset catalog image.
    static var fem: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fem)
#else
        .init()
#endif
    }

    /// The "fic" asset catalog image.
    static var fic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fic)
#else
        .init()
#endif
    }

    /// The "fin" asset catalog image.
    static var fin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fin)
#else
        .init()
#endif
    }

    /// The "fin-border" asset catalog image.
    static var finBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .finBorder)
#else
        .init()
#endif
    }

    /// The "fin-rarity" asset catalog image.
    static var finRarity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .finRarity)
#else
        .init()
#endif
    }

    /// The "frf" asset catalog image.
    static var frf: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .frf)
#else
        .init()
#endif
    }

    /// The "fut" asset catalog image.
    static var fut: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .fut)
#else
        .init()
#endif
    }

    /// The "gn2" asset catalog image.
    static var gn2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gn2)
#else
        .init()
#endif
    }

    /// The "gn3" asset catalog image.
    static var gn3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gn3)
#else
        .init()
#endif
    }

    /// The "gnt" asset catalog image.
    static var gnt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gnt)
#else
        .init()
#endif
    }

    /// The "golgari" asset catalog image.
    static var golgari: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .golgari)
#else
        .init()
#endif
    }

    /// The "gpt" asset catalog image.
    static var gpt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gpt)
#else
        .init()
#endif
    }

    /// The "grn" asset catalog image.
    static var grn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .grn)
#else
        .init()
#endif
    }

    /// The "gruul" asset catalog image.
    static var gruul: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gruul)
#else
        .init()
#endif
    }

    /// The "gs1" asset catalog image.
    static var gs1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gs1)
#else
        .init()
#endif
    }

    /// The "gtc" asset catalog image.
    static var gtc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .gtc)
#else
        .init()
#endif
    }

    /// The "h09" asset catalog image.
    static var h09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .h09)
#else
        .init()
#endif
    }

    /// The "h17" asset catalog image.
    static var h17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .h17)
#else
        .init()
#endif
    }

    /// The "ha1" asset catalog image.
    static var ha1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ha1)
#else
        .init()
#endif
    }

    /// The "hbg" asset catalog image.
    static var hbg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hbg)
#else
        .init()
#endif
    }

    /// The "hml" asset catalog image.
    static var hml: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hml)
#else
        .init()
#endif
    }

    /// The "hop" asset catalog image.
    static var hop: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hop)
#else
        .init()
#endif
    }

    /// The "hou" asset catalog image.
    static var hou: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hou)
#else
        .init()
#endif
    }

    /// The "ice" asset catalog image.
    static var ice: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ice)
#else
        .init()
#endif
    }

    /// The "ice2" asset catalog image.
    static var ice2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ice2)
#else
        .init()
#endif
    }

    /// The "iko" asset catalog image.
    static var iko: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .iko)
#else
        .init()
#endif
    }

    /// The "ima" asset catalog image.
    static var ima: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ima)
#else
        .init()
#endif
    }

    /// The "inr" asset catalog image.
    static var inr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .inr)
#else
        .init()
#endif
    }

    /// The "inv" asset catalog image.
    static var inv: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .inv)
#else
        .init()
#endif
    }

    /// The "isd" asset catalog image.
    static var isd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .isd)
#else
        .init()
#endif
    }

    /// The "izzet" asset catalog image.
    static var izzet: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .izzet)
#else
        .init()
#endif
    }

    /// The "j20" asset catalog image.
    static var j20: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j20)
#else
        .init()
#endif
    }

    /// The "j21" asset catalog image.
    static var j21: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j21)
#else
        .init()
#endif
    }

    /// The "j21-outline" asset catalog image.
    static var j21Outline: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j21Outline)
#else
        .init()
#endif
    }

    /// The "j22" asset catalog image.
    static var j22: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j22)
#else
        .init()
#endif
    }

    /// The "j25" asset catalog image.
    static var j25: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j25)
#else
        .init()
#endif
    }

    /// The "j25-alt" asset catalog image.
    static var j25Alt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .j25Alt)
#else
        .init()
#endif
    }

    /// The "jmp" asset catalog image.
    static var jmp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .jmp)
#else
        .init()
#endif
    }

    /// The "jou" asset catalog image.
    static var jou: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .jou)
#else
        .init()
#endif
    }

    /// The "jud" asset catalog image.
    static var jud: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .jud)
#else
        .init()
#endif
    }

    /// The "khc" asset catalog image.
    static var khc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .khc)
#else
        .init()
#endif
    }

    /// The "khc-inner" asset catalog image.
    static var khcInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .khcInner)
#else
        .init()
#endif
    }

    /// The "khc-rarity" asset catalog image.
    static var khcRarity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .khcRarity)
#else
        .init()
#endif
    }

    /// The "khm" asset catalog image.
    static var khm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .khm)
#else
        .init()
#endif
    }

    /// The "kld" asset catalog image.
    static var kld: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kld)
#else
        .init()
#endif
    }

    /// The "klr" asset catalog image.
    static var klr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .klr)
#else
        .init()
#endif
    }

    /// The "ktk" asset catalog image.
    static var ktk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ktk)
#else
        .init()
#endif
    }

    /// The "lcc" asset catalog image.
    static var lcc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lcc)
#else
        .init()
#endif
    }

    /// The "lci" asset catalog image.
    static var lci: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lci)
#else
        .init()
#endif
    }

    /// The "lea" asset catalog image.
    static var lea: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lea)
#else
        .init()
#endif
    }

    /// The "leb" asset catalog image.
    static var leb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .leb)
#else
        .init()
#endif
    }

    /// The "leg" asset catalog image.
    static var leg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .leg)
#else
        .init()
#endif
    }

    /// The "lgn" asset catalog image.
    static var lgn: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lgn)
#else
        .init()
#endif
    }

    /// The "lrw" asset catalog image.
    static var lrw: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .lrw)
#else
        .init()
#endif
    }

    /// The "ltc" asset catalog image.
    static var ltc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ltc)
#else
        .init()
#endif
    }

    /// The "ltc-white" asset catalog image.
    static var ltcWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ltcWhite)
#else
        .init()
#endif
    }

    /// The "ltr" asset catalog image.
    static var ltr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ltr)
#else
        .init()
#endif
    }

    /// The "m10" asset catalog image.
    static var m10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m10)
#else
        .init()
#endif
    }

    /// The "m11" asset catalog image.
    static var m11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m11)
#else
        .init()
#endif
    }

    /// The "m12" asset catalog image.
    static var m12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m12)
#else
        .init()
#endif
    }

    /// The "m13" asset catalog image.
    static var m13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m13)
#else
        .init()
#endif
    }

    /// The "m14" asset catalog image.
    static var m14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m14)
#else
        .init()
#endif
    }

    /// The "m15" asset catalog image.
    static var m15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m15)
#else
        .init()
#endif
    }

    /// The "m19" asset catalog image.
    static var m19: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m19)
#else
        .init()
#endif
    }

    /// The "m20" asset catalog image.
    static var m20: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m20)
#else
        .init()
#endif
    }

    /// The "m21" asset catalog image.
    static var m21: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m21)
#else
        .init()
#endif
    }

    /// The "m3c" asset catalog image.
    static var m3C: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m3C)
#else
        .init()
#endif
    }

    /// The "m3c-inner" asset catalog image.
    static var m3CInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .m3CInner)
#else
        .init()
#endif
    }

    /// The "mar" asset catalog image.
    static var mar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mar)
#else
        .init()
#endif
    }

    /// The "mat" asset catalog image.
    static var mat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mat)
#else
        .init()
#endif
    }

    /// The "mb1" asset catalog image.
    static var mb1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mb1)
#else
        .init()
#endif
    }

    /// The "mb2" asset catalog image.
    static var mb2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mb2)
#else
        .init()
#endif
    }

    /// The "mbs" asset catalog image.
    static var mbs: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mbs)
#else
        .init()
#endif
    }

    /// The "md1" asset catalog image.
    static var md1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .md1)
#else
        .init()
#endif
    }

    /// The "me1" asset catalog image.
    static var me1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .me1)
#else
        .init()
#endif
    }

    /// The "me2" asset catalog image.
    static var me2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .me2)
#else
        .init()
#endif
    }

    /// The "me3" asset catalog image.
    static var me3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .me3)
#else
        .init()
#endif
    }

    /// The "me4" asset catalog image.
    static var me4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .me4)
#else
        .init()
#endif
    }

    /// The "med" asset catalog image.
    static var med: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .med)
#else
        .init()
#endif
    }

    /// The "mh1" asset catalog image.
    static var mh1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mh1)
#else
        .init()
#endif
    }

    /// The "mh2" asset catalog image.
    static var mh2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mh2)
#else
        .init()
#endif
    }

    /// The "mh3" asset catalog image.
    static var mh3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mh3)
#else
        .init()
#endif
    }

    /// The "mic" asset catalog image.
    static var mic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mic)
#else
        .init()
#endif
    }

    /// The "mid" asset catalog image.
    static var mid: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mid)
#else
        .init()
#endif
    }

    /// The "mid-border" asset catalog image.
    static var midBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .midBorder)
#else
        .init()
#endif
    }

    /// The "mir" asset catalog image.
    static var mir: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mir)
#else
        .init()
#endif
    }

    /// The "mkc" asset catalog image.
    static var mkc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mkc)
#else
        .init()
#endif
    }

    /// The "mkm" asset catalog image.
    static var mkm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mkm)
#else
        .init()
#endif
    }

    /// The "mm2" asset catalog image.
    static var mm2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mm2)
#else
        .init()
#endif
    }

    /// The "mm3" asset catalog image.
    static var mm3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mm3)
#else
        .init()
#endif
    }

    /// The "mma" asset catalog image.
    static var mma: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mma)
#else
        .init()
#endif
    }

    /// The "mmq" asset catalog image.
    static var mmq: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mmq)
#else
        .init()
#endif
    }

    /// The "moc" asset catalog image.
    static var moc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .moc)
#else
        .init()
#endif
    }

    /// The "mom" asset catalog image.
    static var mom: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mom)
#else
        .init()
#endif
    }

    /// The "mor" asset catalog image.
    static var mor: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mor)
#else
        .init()
#endif
    }

    /// The "mp1" asset catalog image.
    static var mp1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mp1)
#else
        .init()
#endif
    }

    /// The "mp2" asset catalog image.
    static var mp2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mp2)
#else
        .init()
#endif
    }

    /// The "mrd" asset catalog image.
    static var mrd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mrd)
#else
        .init()
#endif
    }

    /// The "ncc" asset catalog image.
    static var ncc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ncc)
#else
        .init()
#endif
    }

    /// The "ncc-white" asset catalog image.
    static var nccWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .nccWhite)
#else
        .init()
#endif
    }

    /// The "nec" asset catalog image.
    static var nec: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .nec)
#else
        .init()
#endif
    }

    /// The "nem" asset catalog image.
    static var nem: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .nem)
#else
        .init()
#endif
    }

    /// The "neo" asset catalog image.
    static var neo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .neo)
#else
        .init()
#endif
    }

    /// The "nms" asset catalog image.
    static var nms: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .nms)
#else
        .init()
#endif
    }

    /// The "nph" asset catalog image.
    static var nph: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .nph)
#else
        .init()
#endif
    }

    /// The "ody" asset catalog image.
    static var ody: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ody)
#else
        .init()
#endif
    }

    /// The "ogw" asset catalog image.
    static var ogw: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ogw)
#else
        .init()
#endif
    }

    /// The "onc" asset catalog image.
    static var onc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .onc)
#else
        .init()
#endif
    }

    /// The "one" asset catalog image.
    static var one: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .one)
#else
        .init()
#endif
    }

    /// The "ons" asset catalog image.
    static var ons: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ons)
#else
        .init()
#endif
    }

    /// The "ori" asset catalog image.
    static var ori: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ori)
#else
        .init()
#endif
    }

    /// The "orzhov" asset catalog image.
    static var orzhov: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .orzhov)
#else
        .init()
#endif
    }

    /// The "otc" asset catalog image.
    static var otc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .otc)
#else
        .init()
#endif
    }

    /// The "otc-inner" asset catalog image.
    static var otcInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .otcInner)
#else
        .init()
#endif
    }

    /// The "otj" asset catalog image.
    static var otj: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .otj)
#else
        .init()
#endif
    }

    /// The "otp" asset catalog image.
    static var otp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .otp)
#else
        .init()
#endif
    }

    /// The "papac" asset catalog image.
    static var papac: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .papac)
#else
        .init()
#endif
    }

    /// The "parl" asset catalog image.
    static var parl: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .parl)
#else
        .init()
#endif
    }

    /// The "parl2" asset catalog image.
    static var parl2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .parl2)
#else
        .init()
#endif
    }

    /// The "parl3" asset catalog image.
    static var parl3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .parl3)
#else
        .init()
#endif
    }

    /// The "past" asset catalog image.
    static var past: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .past)
#else
        .init()
#endif
    }

    /// The "pbook" asset catalog image.
    static var pbook: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pbook)
#else
        .init()
#endif
    }

    /// The "pc2" asset catalog image.
    static var pc2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pc2)
#else
        .init()
#endif
    }

    /// The "pca" asset catalog image.
    static var pca: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pca)
#else
        .init()
#endif
    }

    /// The "pcy" asset catalog image.
    static var pcy: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pcy)
#else
        .init()
#endif
    }

    /// The "pd2" asset catalog image.
    static var pd2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pd2)
#else
        .init()
#endif
    }

    /// The "pd3" asset catalog image.
    static var pd3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pd3)
#else
        .init()
#endif
    }

    /// The "pdep" asset catalog image.
    static var pdep: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pdep)
#else
        .init()
#endif
    }

    /// The "pdgc" asset catalog image.
    static var pdgc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pdgc)
#else
        .init()
#endif
    }

    /// The "peuro" asset catalog image.
    static var peuro: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .peuro)
#else
        .init()
#endif
    }

    /// The "pfnm" asset catalog image.
    static var pfnm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pfnm)
#else
        .init()
#endif
    }

    /// The "pgru" asset catalog image.
    static var pgru: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pgru)
#else
        .init()
#endif
    }

    /// The "pheart" asset catalog image.
    static var pheart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pheart)
#else
        .init()
#endif
    }

    /// The "pidw" asset catalog image.
    static var pidw: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pidw)
#else
        .init()
#endif
    }

    /// The "pio" asset catalog image.
    static var pio: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pio)
#else
        .init()
#endif
    }

    /// The "pip" asset catalog image.
    static var pip: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pip)
#else
        .init()
#endif
    }

    /// The "plc" asset catalog image.
    static var plc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .plc)
#else
        .init()
#endif
    }

    /// The "pleaf" asset catalog image.
    static var pleaf: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pleaf)
#else
        .init()
#endif
    }

    /// The "pls" asset catalog image.
    static var pls: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pls)
#else
        .init()
#endif
    }

    /// The "pm2" asset catalog image.
    static var pm2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pm2)
#else
        .init()
#endif
    }

    /// The "pma" asset catalog image.
    static var pma: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pma)
#else
        .init()
#endif
    }

    /// The "pmei" asset catalog image.
    static var pmei: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmei)
#else
        .init()
#endif
    }

    /// The "pmodo" asset catalog image.
    static var pmodo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmodo)
#else
        .init()
#endif
    }

    /// The "pmps" asset catalog image.
    static var pmps: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmps)
#else
        .init()
#endif
    }

    /// The "pmpu" asset catalog image.
    static var pmpu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmpu)
#else
        .init()
#endif
    }

    /// The "pmtg1" asset catalog image.
    static var pmtg1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmtg1)
#else
        .init()
#endif
    }

    /// The "pmtg2" asset catalog image.
    static var pmtg2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pmtg2)
#else
        .init()
#endif
    }

    /// The "po2" asset catalog image.
    static var po2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .po2)
#else
        .init()
#endif
    }

    /// The "por" asset catalog image.
    static var por: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .por)
#else
        .init()
#endif
    }

    /// The "psalvat05" asset catalog image.
    static var psalvat05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psalvat05)
#else
        .init()
#endif
    }

    /// The "psalvat11" asset catalog image.
    static var psalvat11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psalvat11)
#else
        .init()
#endif
    }

    /// The "psega" asset catalog image.
    static var psega: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psega)
#else
        .init()
#endif
    }

    /// The "psum" asset catalog image.
    static var psum: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .psum)
#else
        .init()
#endif
    }

    /// The "ptg" asset catalog image.
    static var ptg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ptg)
#else
        .init()
#endif
    }

    /// The "ptk" asset catalog image.
    static var ptk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ptk)
#else
        .init()
#endif
    }

    /// The "ptsa" asset catalog image.
    static var ptsa: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ptsa)
#else
        .init()
#endif
    }

    /// The "pxbox" asset catalog image.
    static var pxbox: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pxbox)
#else
        .init()
#endif
    }

    /// The "pz2" asset catalog image.
    static var pz2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pz2)
#else
        .init()
#endif
    }

    /// The "rakdos" asset catalog image.
    static var rakdos: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rakdos)
#else
        .init()
#endif
    }

    /// The "rav" asset catalog image.
    static var rav: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rav)
#else
        .init()
#endif
    }

    /// The "rex" asset catalog image.
    static var rex: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rex)
#else
        .init()
#endif
    }

    /// The "rix" asset catalog image.
    static var rix: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rix)
#else
        .init()
#endif
    }

    /// The "rna" asset catalog image.
    static var rna: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rna)
#else
        .init()
#endif
    }

    /// The "roe" asset catalog image.
    static var roe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .roe)
#else
        .init()
#endif
    }

    /// The "rtr" asset catalog image.
    static var rtr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rtr)
#else
        .init()
#endif
    }

    /// The "rvr" asset catalog image.
    static var rvr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rvr)
#else
        .init()
#endif
    }

    /// The "s00" asset catalog image.
    static var s00: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .s00)
#else
        .init()
#endif
    }

    /// The "s99" asset catalog image.
    static var s99: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .s99)
#else
        .init()
#endif
    }

    /// The "scg" asset catalog image.
    static var scg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scg)
#else
        .init()
#endif
    }

    /// The "selesnya" asset catalog image.
    static var selesnya: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .selesnya)
#else
        .init()
#endif
    }

    /// The "shm" asset catalog image.
    static var shm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shm)
#else
        .init()
#endif
    }

    /// The "simic" asset catalog image.
    static var simic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .simic)
#else
        .init()
#endif
    }

    /// The "sld2" asset catalog image.
    static var sld2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sld2)
#else
        .init()
#endif
    }

    /// The "snc" asset catalog image.
    static var snc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snc)
#else
        .init()
#endif
    }

    /// The "soi" asset catalog image.
    static var soi: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .soi)
#else
        .init()
#endif
    }

    /// The "sok" asset catalog image.
    static var sok: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sok)
#else
        .init()
#endif
    }

    /// The "som" asset catalog image.
    static var som: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .som)
#else
        .init()
#endif
    }

    /// The "spe" asset catalog image.
    static var spe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .spe)
#else
        .init()
#endif
    }

    /// The "spg" asset catalog image.
    static var spg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .spg)
#else
        .init()
#endif
    }

    /// The "spm" asset catalog image.
    static var spm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .spm)
#else
        .init()
#endif
    }

    /// The "spm-inner" asset catalog image.
    static var spmInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .spmInner)
#else
        .init()
#endif
    }

    /// The "ss1" asset catalog image.
    static var ss1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ss1)
#else
        .init()
#endif
    }

    /// The "ss2" asset catalog image.
    static var ss2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ss2)
#else
        .init()
#endif
    }

    /// The "ss3" asset catalog image.
    static var ss3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ss3)
#else
        .init()
#endif
    }

    /// The "sta" asset catalog image.
    static var sta: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sta)
#else
        .init()
#endif
    }

    /// The "sth" asset catalog image.
    static var sth: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .sth)
#else
        .init()
#endif
    }

    /// The "stx" asset catalog image.
    static var stx: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stx)
#else
        .init()
#endif
    }

    /// The "td2" asset catalog image.
    static var td2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .td2)
#else
        .init()
#endif
    }

    /// The "tdc" asset catalog image.
    static var tdc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tdc)
#else
        .init()
#endif
    }

    /// The "tdm" asset catalog image.
    static var tdm: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tdm)
#else
        .init()
#endif
    }

    /// The "tdm-border" asset catalog image.
    static var tdmBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tdmBorder)
#else
        .init()
#endif
    }

    /// The "thb" asset catalog image.
    static var thb: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .thb)
#else
        .init()
#endif
    }

    /// The "ths" asset catalog image.
    static var ths: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ths)
#else
        .init()
#endif
    }

    /// The "tla" asset catalog image.
    static var tla: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tla)
#else
        .init()
#endif
    }

    /// The "tla-border" asset catalog image.
    static var tlaBorder: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tlaBorder)
#else
        .init()
#endif
    }

    /// The "tla-inner" asset catalog image.
    static var tlaInner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tlaInner)
#else
        .init()
#endif
    }

    /// The "tla-rarity" asset catalog image.
    static var tlaRarity: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tlaRarity)
#else
        .init()
#endif
    }

    /// The "tmp" asset catalog image.
    static var tmp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tmp)
#else
        .init()
#endif
    }

    /// The "tor" asset catalog image.
    static var tor: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tor)
#else
        .init()
#endif
    }

    /// The "tpr" asset catalog image.
    static var tpr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tpr)
#else
        .init()
#endif
    }

    /// The "tsp" asset catalog image.
    static var tsp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tsp)
#else
        .init()
#endif
    }

    /// The "tsr" asset catalog image.
    static var tsr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tsr)
#else
        .init()
#endif
    }

    /// The "uds" asset catalog image.
    static var uds: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .uds)
#else
        .init()
#endif
    }

    /// The "ugl" asset catalog image.
    static var ugl: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ugl)
#else
        .init()
#endif
    }

    /// The "ulg" asset catalog image.
    static var ulg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ulg)
#else
        .init()
#endif
    }

    /// The "uma" asset catalog image.
    static var uma: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .uma)
#else
        .init()
#endif
    }

    /// The "una" asset catalog image.
    static var una: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .una)
#else
        .init()
#endif
    }

    /// The "una-white" asset catalog image.
    static var unaWhite: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .unaWhite)
#else
        .init()
#endif
    }

    /// The "und" asset catalog image.
    static var und: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .und)
#else
        .init()
#endif
    }

    /// The "unf" asset catalog image.
    static var unf: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .unf)
#else
        .init()
#endif
    }

    /// The "unh" asset catalog image.
    static var unh: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .unh)
#else
        .init()
#endif
    }

    /// The "usg" asset catalog image.
    static var usg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .usg)
#else
        .init()
#endif
    }

    /// The "ust" asset catalog image.
    static var ust: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ust)
#else
        .init()
#endif
    }

    /// The "v09" asset catalog image.
    static var v09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v09)
#else
        .init()
#endif
    }

    /// The "v0x" asset catalog image.
    static var v0X: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v0X)
#else
        .init()
#endif
    }

    /// The "v10" asset catalog image.
    static var v10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v10)
#else
        .init()
#endif
    }

    /// The "v11" asset catalog image.
    static var v11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v11)
#else
        .init()
#endif
    }

    /// The "v12" asset catalog image.
    static var v12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v12)
#else
        .init()
#endif
    }

    /// The "v13" asset catalog image.
    static var v13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v13)
#else
        .init()
#endif
    }

    /// The "v14" asset catalog image.
    static var v14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v14)
#else
        .init()
#endif
    }

    /// The "v15" asset catalog image.
    static var v15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v15)
#else
        .init()
#endif
    }

    /// The "v16" asset catalog image.
    static var v16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v16)
#else
        .init()
#endif
    }

    /// The "v17" asset catalog image.
    static var v17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .v17)
#else
        .init()
#endif
    }

    /// The "van" asset catalog image.
    static var van: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .van)
#else
        .init()
#endif
    }

    /// The "vis" asset catalog image.
    static var vis: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .vis)
#else
        .init()
#endif
    }

    /// The "vma" asset catalog image.
    static var vma: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .vma)
#else
        .init()
#endif
    }

    /// The "voc" asset catalog image.
    static var voc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .voc)
#else
        .init()
#endif
    }

    /// The "vow" asset catalog image.
    static var vow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .vow)
#else
        .init()
#endif
    }

    /// The "w16" asset catalog image.
    static var w16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .w16)
#else
        .init()
#endif
    }

    /// The "w17" asset catalog image.
    static var w17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .w17)
#else
        .init()
#endif
    }

    /// The "war" asset catalog image.
    static var war: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .war)
#else
        .init()
#endif
    }

    /// The "who" asset catalog image.
    static var who: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .who)
#else
        .init()
#endif
    }

    /// The "woc" asset catalog image.
    static var woc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .woc)
#else
        .init()
#endif
    }

    /// The "woe" asset catalog image.
    static var woe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .woe)
#else
        .init()
#endif
    }

    /// The "wot" asset catalog image.
    static var wot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .wot)
#else
        .init()
#endif
    }

    /// The "wth" asset catalog image.
    static var wth: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .wth)
#else
        .init()
#endif
    }

    /// The "wwk" asset catalog image.
    static var wwk: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .wwk)
#else
        .init()
#endif
    }

    /// The "x1e" asset catalog image.
    static var x1E: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x1E)
#else
        .init()
#endif
    }

    /// The "x2e" asset catalog image.
    static var x2E: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x2E)
#else
        .init()
#endif
    }

    /// The "x2ps" asset catalog image.
    static var x2Ps: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x2Ps)
#else
        .init()
#endif
    }

    /// The "x2u" asset catalog image.
    static var x2U: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x2U)
#else
        .init()
#endif
    }

    /// The "x3e" asset catalog image.
    static var x3E: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x3E)
#else
        .init()
#endif
    }

    /// The "x4ea" asset catalog image.
    static var x4Ea: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .x4Ea)
#else
        .init()
#endif
    }

    /// The "xcle" asset catalog image.
    static var xcle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xcle)
#else
        .init()
#endif
    }

    /// The "xduels" asset catalog image.
    static var xduels: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xduels)
#else
        .init()
#endif
    }

    /// The "xice" asset catalog image.
    static var xice: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xice)
#else
        .init()
#endif
    }

    /// The "xlcu" asset catalog image.
    static var xlcu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xlcu)
#else
        .init()
#endif
    }

    /// The "xln" asset catalog image.
    static var xln: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xln)
#else
        .init()
#endif
    }

    /// The "xmods" asset catalog image.
    static var xmods: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xmods)
#else
        .init()
#endif
    }

    /// The "xren" asset catalog image.
    static var xren: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xren)
#else
        .init()
#endif
    }

    /// The "xrin" asset catalog image.
    static var xrin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xrin)
#else
        .init()
#endif
    }

    /// The "y22" asset catalog image.
    static var y22: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .y22)
#else
        .init()
#endif
    }

    /// The "y24" asset catalog image.
    static var y24: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .y24)
#else
        .init()
#endif
    }

    /// The "y25" asset catalog image.
    static var y25: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .y25)
#else
        .init()
#endif
    }

    /// The "ydmu" asset catalog image.
    static var ydmu: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ydmu)
#else
        .init()
#endif
    }

    /// The "zen" asset catalog image.
    static var zen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zen)
#else
        .init()
#endif
    }

    /// The "znc" asset catalog image.
    static var znc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .znc)
#else
        .init()
#endif
    }

    /// The "zne" asset catalog image.
    static var zne: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zne)
#else
        .init()
#endif
    }

    /// The "znr" asset catalog image.
    static var znr: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .znr)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif


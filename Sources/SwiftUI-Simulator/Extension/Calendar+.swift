//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import Foundation

extension Calendar.Identifier: CaseIterable, RawRepresentable, Identifiable {
    public init?(rawValue: String) {
        switch rawValue {
        case "gregorian": self = .gregorian
        case "buddhist": self = .buddhist
        case "chinese": self = .chinese
        case "coptic": self = .coptic
        case "ethiopicAmeteMihret": self = .ethiopicAmeteMihret
        case "ethiopicAmeteAlem": self = .ethiopicAmeteAlem
        case "hebrew": self = .hebrew
        case "iso8601": self = .iso8601
        case "indian": self = .indian
        case "islamic": self = .islamic
        case "islamicCivil": self = .islamicCivil
        case "japanese": self = .japanese
        case "persian": self = .persian
        case "republicOfChina": self = .republicOfChina
        case "islamicTabular": self = .islamicTabular
        case "islamicUmmAlQura": self = .islamicUmmAlQura
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .gregorian: return "gregorian"
        case .buddhist: return "buddhist"
        case .chinese: return "chinese"
        case .coptic: return "coptic"
        case .ethiopicAmeteMihret: return "ethiopicAmeteMihret"
        case .ethiopicAmeteAlem: return "ethiopicAmeteAlem"
        case .hebrew: return "hebrew"
        case .iso8601: return "iso8601"
        case .indian: return "indian"
        case .islamic: return "islamic"
        case .islamicCivil: return "islamicCivil"
        case .japanese: return "japanese"
        case .persian: return "persian"
        case .republicOfChina: return "republicOfChina"
        case .islamicTabular: return "islamicTabular"
        case .islamicUmmAlQura: return "islamicUmmAlQura"
        @unknown default:
            preconditionFailure()
        }
    }

    public static var allCases: [Calendar.Identifier] {
        [
            .gregorian,
            .buddhist,
            .chinese,
            .coptic,
            .ethiopicAmeteMihret,
            .ethiopicAmeteAlem,
            .hebrew,
            .iso8601,
            .indian,
            .islamic,
            .islamicCivil,
            .japanese,
            .persian,
            .republicOfChina,
            .islamicTabular,
            .islamicUmmAlQura,
        ]
    }

    public var id: String {
        rawValue
    }
}

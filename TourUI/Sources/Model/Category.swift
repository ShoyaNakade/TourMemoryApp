//
//  Category.swift
//  
//
//  Created by 中出翔也 on 2022/01/09.
//

import Foundation

public enum Category:Int16, Hashable, CaseIterable,Codable {
    case attraction
    case gourmet
    case cafe
    case solo
    case couple
    case overseas

    public var text: String {
        switch self {
        case .attraction:
            return "観光"
        case .overseas:
            return "海外"
        case .gourmet:
            return "グルメ"
        case .cafe:
            return "カフェ"
        case .solo:
            return "一人旅"
        case .couple:
            return "カップル"
        }
    }
    public var toImage: String {
        switch self {
        case .attraction :
            return "binoculars"
        case .gourmet:
            return "fork.knife"
        case .cafe:
            return "cup.and.saucer.fill"
        case .solo:
            return "person"
        case .couple:
            return "person.2"
        case .overseas :
            return "airplane"
        }
    }
}

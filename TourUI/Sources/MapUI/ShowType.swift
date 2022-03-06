//
//  ShowType.swift
//  
//
//  Created by 中出翔也 on 2022/02/08.
//

import Foundation
import SwiftUI

public enum ShowType {
    case all
    case memory
    case destination
    case noall
    
    func toString() -> String {
        switch self {
        case .all :
            return "全て"
        case .memory :
            return "思い出"
        case .destination:
            return "行きたい所"
        case .noall :
            return "全非表示"
        }
    }
    func toImageColor() -> Color {
        switch self {
        case .all :
            return Color(.black)
        case .memory :
            return Color(.blue)
        case .destination:
            return Color(.red)
        case .noall:
            return Color(.gray)
        }
    }
}

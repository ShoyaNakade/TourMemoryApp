//
//  Coordinate.swift
//  
//
//  Created by 中出翔也 on 2022/01/25.
//

import Foundation


public struct Coordinate: Codable {
    public var latitude: Double = 0
    public var longitude: Double = 0
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

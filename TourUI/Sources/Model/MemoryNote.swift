//
//  MemoryNote.swift
//  
//
//  Created by 中出翔也 on 2022/01/06.
//

import Foundation
import MapKit
import CoreLocation

public enum NoteType: Int16, Hashable, Codable {
    case memory
    case destination
}

public struct MemoryNote: Identifiable, Codable {
    public var id: String
    public var title: String = ""
    public var address: String = ""
    public var time: Date = Date.now
    public var ratio: Int16 = 1
    public var noteType: NoteType = .memory
    public var contentsText: String =  ""
    public var imageData: [Data] = []
//    public var images: [UIImage] = []
    public var categories: Set<Category> = [] // 順序のない集合体
    public var coordinate: Coordinate
    
    public func getlocation() -> CLLocationCoordinate2D {
        // CLLlocationCoodinate2D方に変えただけ
        return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        address: String,
        time: Date,
        ratio: Int16,
        noteType: NoteType,
        contentsText: String,
        imageData:[Data],
//        images: [UIImage],
        categories: Set<Category>,
        coordinate: Coordinate
//        latitude: Double,
//        longitude: Double
    ) {
        self.id = id
        self.title = title
        self.address = address
        self.time = time
        self.ratio = ratio
        self.noteType = noteType
        self.contentsText = contentsText
        self.imageData = imageData
        self.categories = categories
//        self.images = images
        self.coordinate = coordinate
    }
    
    public func noteTypeToString() -> String {
        if self.noteType == .memory {
            return "日記"
        }
        else {
            return "詳細"
        }
    }
    
    public func categoryToInt16() -> [Int16] {
        var categoryInt: [Int16] = []
        for cat in self.categories {
            categoryInt.append(cat.rawValue)
        }
        return categoryInt
    }
    
    public static func categoryInt16ToSet(categoryInt16: [Int16] ) -> Set<Category> {
        var category: Set<Category>  = []
        for catInt in categoryInt16 {
            category.insert(Category(rawValue: catInt)!)
        }
        return category
    }

    
}

extension MemoryNote {
    public static var placeholder: MemoryNote { // placeholderというmethodで、簡単にinitialainzeできる。
        return .init(title: "", address: "", time: Date.now, ratio: 1, noteType: .memory , contentsText: "", imageData: [], categories: [], coordinate: Coordinate(latitude: 0, longitude: 0))
    }
    
    public static var placeholderDestination: MemoryNote {
        return .init(title: "", address: "", time: Date.now, ratio: 1, noteType: .destination , contentsText: "", imageData: [], categories: [], coordinate: Coordinate(latitude: 0, longitude: 0))
    }
}


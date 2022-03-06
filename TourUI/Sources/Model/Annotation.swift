//
//  Annotation.swift
//  
//
//  Created by 中出翔也 on 2022/01/10.
//

import Foundation
import MapKit

public struct Annotation: Identifiable {
    public let id: String
    public let name: String
    public let firstImage: UIImage
    public let ratio: Int16
    public var coordinate: CLLocationCoordinate2D
    public var noteType: NoteType = .memory
    
    public init(
        id: String = UUID().uuidString,
        firstImage: UIImage,
        name: String,
        ratio: Int16,
        coordinate: CLLocationCoordinate2D,
        noteType: NoteType
    ){
        self.id = id
        self.firstImage = firstImage
        
        self.name = name
        self.ratio = ratio
        self.coordinate = coordinate
        self.noteType = noteType
    }
}

//
//  MyMemory.swift
//  
//
//  Created by 中出翔也 on 2022/01/15.
//

import Foundation
import SwiftUI
import CoreData
import UIKit

public class MyMemory: ObservableObject {
    public var delegate: NotificationDelegate?
    @Published public var notes: [MemoryNote]
    @Published public var showLatLng: Bool = false // マップのlong latの表示
    @Published public var isLoading: Bool = false //loading表示
    
    @Published public var searchText: String = ""
    @Published public var orderedByRatio: OrderedByRatio = .none
    @Published public var orderedByDate: OrderedByDate = .recent
    @Published public var filterCategories: Set<Category> = [] //order用category
    @Published public var isFilterCategory: Bool = false //order用category
    
    
    @Published public var isLogin: Bool = false // For show modal
    @Published public var isID: Bool  // FS ID認証
    @Published public var email: String // FS mail
    
    public init(notes:[MemoryNote]) {
        self.notes = notes
        self.isID = self.delegate?.GetisId() ?? false
        self.email = self.delegate?.GetEmail() ?? ""
        
//        for cat in Category.allCases {
//            filterCategories.insert(cat)
//        }
        
    }
    public func InitLoginState() {
        self.isID = self.delegate?.GetisId() ?? false
        self.email = self.delegate?.GetEmail() ?? ""
    }
    public func logout() {
        self.isID = false
        self.email = ""
    }
    
    
    public var searchResults: [MemoryNote] {
        get {
            if searchText.isEmpty {
                // 入力がない場合は捨てを返す。
                return self.orderedFilterNotes
            } else {
                return self.orderedFilterNotes.filter { note in
                    note.title.contains(searchText) ||
                    note.contentsText.contains(searchText) ||
                    note.address.contains(searchText)
                }
            }
        }
        set {
            
        }
    }
    
    public var orderedFilterNotes: [MemoryNote] {
        var sorted = self.notes
        var filter = self.notes
                
        // 1. 日付でソート
        if orderedByDate == .recent {
            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
                return firstMemory.time ?? Date.now >= secondMemory.time ?? Date.now
            }
        } else if orderedByDate == .old {
            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
                return firstMemory.time ?? Date.now < secondMemory.time ?? Date.now+1
            }
        }
//        if orderedByDate == .recent {
//            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
//                return firstMemory.time! >= secondMemory.time!
//            }
//        } else if orderedByDate == .old {
//            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
//                return firstMemory.time! < secondMemory.time!
//            }
//        }
        
        // 2. ratioでソート
        if orderedByRatio == .max {
            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
                    return firstMemory.ratio >= secondMemory.ratio
            }
        } else if orderedByRatio == .min {
            sorted = notes.sorted { (firstMemory:MemoryNote, secondMemory:MemoryNote) -> Bool in
                    return firstMemory.ratio < secondMemory.ratio
            }
        }
        
        // sorted Notes throw filter Category
        if self.isFilterCategory {
            filter = sorted.filter { note in
            (note.categories.contains(.attraction) && self.filterCategories.contains(.attraction)) ||
            (note.categories.contains(.cafe) && self.filterCategories.contains(.cafe)) ||
            (note.categories.contains(.couple) && self.filterCategories.contains(.couple)) ||
            (note.categories.contains(.gourmet) && self.filterCategories.contains(.gourmet)) ||
            (note.categories.contains(.overseas) && self.filterCategories.contains(.overseas)) ||
            (note.categories.contains(.solo) && self.filterCategories.contains(.solo))
            }
        } else {
            filter = sorted
        }

        return filter
    }
        
    public func fetchAllNotes(managedObjectContext: NSManagedObjectContext) {
        // coreデータからデータを読みこむ。

        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
        
        do {
            let requestNotes = try managedObjectContext.fetch(request)
            for MyNote in requestNotes {
                var unarchiveImageDatas: [Data] = []
                var unarchiveCategories: Set<Category> = []
                if let loadedImageDatas = MyNote.imageDatas {
                    unarchiveImageDatas = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedImageDatas) as! [Data]
                }
                if let loadedCategory = MyNote.categories {
                   let preunarchiveCategories = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedCategory) as! [Int16]
                    unarchiveCategories = MemoryNote.categoryInt16ToSet(categoryInt16: preunarchiveCategories)
                }
                
                let tmpMemoryNote: MemoryNote = .init(
                    id: MyNote.id ?? "",
                    title: MyNote.title ?? "",
                    address: MyNote.address ?? "",
                    time: MyNote.time ?? Date.now,
                    ratio: MyNote.ratio,
                    noteType: NoteType(rawValue: MyNote.noteType) ?? .memory,
                    contentsText: MyNote.contentsText ?? "",
                    imageData: unarchiveImageDatas,
                    categories: unarchiveCategories,
                    coordinate: Coordinate(latitude: MyNote.latitude, longitude: MyNote.longitude))
                self.notes.append(tmpMemoryNote)
            }
        }
        catch let error as NSError {
            print("Error: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
}



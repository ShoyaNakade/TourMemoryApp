//
//  NotesEntity+Extension.swift
//  
//
//  Created by 中出翔也 on 2022/02/03.
//

import CoreData
import SwiftUI
import Model


extension NotesEntity {
    public static func create(in managedObjectContext:NSManagedObjectContext, memoryNote: MemoryNote
//                       id: String, title: String, addrress: String, time: Data?, ratio: Int16, noteType:Int16, contentsText: String, imageData: [Data], categories: Int16, latitude: Double, longitude: Double
    ) {
        let notes = self.init(context: managedObjectContext)
        
        guard let imageDatas = try? NSKeyedArchiver.archivedData(withRootObject: memoryNote.imageData, requiringSecureCoding: true) else {
//                    notes.imageDatas = UIImage(systemName: "photo")?.jpegData(compressionQuality: 1)
                    fatalError("Archive failed")
            }
        
        guard let category = try? NSKeyedArchiver.archivedData(withRootObject: memoryNote.categoryToInt16(), requiringSecureCoding: true) else {
            fatalError("Archive failed")
    }
        
        notes.id = memoryNote.id
        notes.title = memoryNote.title
        notes.address = memoryNote.address
        notes.time = memoryNote.time
        notes.ratio = memoryNote.ratio
        notes.noteType = memoryNote.noteType.rawValue
        notes.contentsText = memoryNote.contentsText
        notes.latitude = memoryNote.coordinate.latitude
        notes.longitude = memoryNote.coordinate.longitude
        notes.imageDatas = imageDatas //圧縮後のdata
        notes.categories = category
        
        do {
            try managedObjectContext.save()
            print("fin save managedObjectCOntext")
        } catch {
          let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
   }
    
    public func importMemoryNote(in managedObjectContext:NSManagedObjectContext ,memoryNote: MemoryNote) {
        guard let imageDatas = try? NSKeyedArchiver.archivedData(withRootObject: memoryNote.imageData, requiringSecureCoding: true) else {
//                    notes.imageDatas = UIImage(systemName: "photo")?.jpegData(compressionQuality: 1)
                    fatalError("Archive failed")
            }
        
        guard let category = try? NSKeyedArchiver.archivedData(withRootObject: memoryNote.categoryToInt16(), requiringSecureCoding: true) else {
            fatalError("Archive failed")
    }
        
        self.id = memoryNote.id
        self.title = memoryNote.title
        self.address = memoryNote.address
        self.time = memoryNote.time
        self.ratio = memoryNote.ratio
        self.noteType = memoryNote.noteType.rawValue
        self.contentsText = memoryNote.contentsText
        self.latitude = memoryNote.coordinate.latitude
        self.longitude = memoryNote.coordinate.longitude
        self.imageDatas = imageDatas //圧縮後のdata
        self.categories = category
        
        do {
            try managedObjectContext.save()
            print("fin save managedObjectCOntext")
        } catch {
          let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    // ロード処理
    func loadImageDatas() -> Data {
        if let loadedData = UserDefaults().data(forKey: "imageDatas") {
            // ⭐️unarchiveTopLevelObjectWithDataに変更　例外を投げるのでtry?を追加
            return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedData) as! Data
        }
        return UIImage(systemName: "photo")!.jpegData(compressionQuality: 1)!
    }
    
    
}

//
//  ControlModel.swift
//  
//
//  Created by 中出翔也 on 2022/01/11.
//

import Foundation
import Model
import Extension
import Data
import Helper
import SwiftUI
import os
import PhotosUI
import CoreData


public protocol ControlMemoryProtocol {
    func save(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext)
    func change(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext)
    func DeleteMemoryNote(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext)
    func DeleteAllMemoryNotes(myMemory: MyMemory, viewContext: NSManagedObjectContext)
    func ImportMyMemoryToCore(myMemory: MyMemory, viewContext: NSManagedObjectContext)
}

public class ControlMemoryModel: ObservableObject {
    // 処理を任せる側のクラス
    public var delegate: ControlMemoryProtocol?
    public init(delegate: ControlMemoryProtocol? = nil) {
        self.delegate = delegate
    }
}

public class AddMemory: ControlMemoryProtocol {
    // 処理を任されるクラス
    @Environment(\.presentationMode) var presentationMode
    private let generator = UINotificationFeedbackGenerator()
    
    public init () {
        
    }
    
    public func save(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext) {
        var tmpMemoryNote: MemoryNote = memoryNote
        // 1detaの追加
        // 1. geoコーディング変換
        CLGeocoder().geocodeAddressString(memoryNote.address) { placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                tmpMemoryNote.coordinate.latitude = lat
            }
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                tmpMemoryNote.coordinate.longitude = lng
            }
            myMemory.notes.append(tmpMemoryNote) // 日記の追加
            // 2.coredata to save
            NotesEntity.create(in: viewContext, memoryNote: tmpMemoryNote)
            do{
                try viewContext.save()
                
            } catch{
                let nserror = error as NSError
                fatalError("Error \(nserror),\(nserror.userInfo)")
            }
            // fin coredata
            
            // 3.firestoreへの保存
//            myMemory.delegate?.AddNoteFireStore(memoryNote: tmpMemoryNote)
            // memoryNote = MemoryNote.placeholder // 初期化
            self.generator.notificationOccurred(.success)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    public func change(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext) {
        var memoryNoteTemp: MemoryNote = memoryNote
        
        CLGeocoder().geocodeAddressString(memoryNoteTemp.address) { [self] placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                memoryNoteTemp.coordinate.latitude = lat
            }
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                memoryNoteTemp.coordinate.longitude = lng
            }
            

            // LocalDataの変更
            if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == memoryNoteTemp.id}) {
                // ---------- FireStoreの変更 --------------
//                myMemory.delegate?.DeleteNoteImage(memoryNote: myMemory.notes[targetIndex]) //変更前のimage数を削除
//                myMemory.delegate?.AddNoteFireStore(memoryNote: memoryNoteTemp) // idでデータを保持しているので、追加処理と同じ
                // ---------- LocalDataの変更 --------------
                myMemory.notes[targetIndex] = memoryNoteTemp // Localのデータを書き換え
            }
            
            // ----------Core Dataの変更------------
            let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
            let predicate = NSPredicate(format:"id = %@", memoryNoteTemp.id )
            request.predicate = predicate
            do {
                let requestNotes = try viewContext.fetch(request)
                for MyNote in requestNotes {
                    // 一つなはずだが配列のため
                    MyNote.importMemoryNote(in: viewContext, memoryNote: memoryNoteTemp)
                }
                try viewContext.save()
            }
            catch let error as NSError {
                print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
            }
            // ---------- // Core Dataの変更------------
            
            
            self.generator.notificationOccurred(.success)
            self.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    public func DeleteMemoryNote(memoryNote: MemoryNote,myMemory: MyMemory, viewContext: NSManagedObjectContext) {
        // ----------Core Dataの削除------------
        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
        let predicate = NSPredicate(format:"id = %@", memoryNote.id )
        request.predicate = predicate
        do {
            let requestNotes = try viewContext.fetch(request)
            for MyNote in requestNotes {
                // 一つだが配列のため
                viewContext.delete(MyNote)
                }
            try viewContext.save()
        }
        catch let error as NSError {
            print("Error: \(error.localizedDescription), \(error.userInfo)")
        }
        // ------------ここまで------------
        // ------------FireStoreからのデータ削除
//        myMemory.delegate?.DeleteNoteFireStore(memoryNote: memoryNote)
        
        // ----------MemoryNoteの削除------------
        if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == memoryNote.id}) {
            myMemory.notes.remove(at: targetIndex)
        }
    }
    
    public func DeleteAllMemoryNotes(myMemory: MyMemory, viewContext: NSManagedObjectContext) {
        
        // delete core data
        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
        do {
            let requestNotes = try viewContext.fetch(request)
            for MyNote in requestNotes {
                viewContext.delete(MyNote)
                }
            try viewContext.save()
        }
        
        catch let error as NSError {
            print("Error: \(error.localizedDescription), \(error.userInfo)")
        }
        // fin coredata
//        myMemory.delegate?.deleteAllNotesFireStore(notes: myMemory.notes) //delete firestore data
        // LocalData
        myMemory.notes.removeAll()
    }
    
    
    public func ImportMyMemoryToCore(myMemory: MyMemory, viewContext: NSManagedObjectContext) {
        //
        for note in myMemory.notes {
            NotesEntity.create(in: viewContext, memoryNote: note)
            do{
                print("import......")
                try viewContext.save()
                
            } catch{
                let nserror = error as NSError
                fatalError("Error \(nserror),\(nserror.userInfo)")
            }
        }
    }
}

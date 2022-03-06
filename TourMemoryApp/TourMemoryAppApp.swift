//
//  TourMemoryAppApp.swift
//  TourMemoryApp
//
//  Created by 中出翔也 on 2022/01/05.
//

import SwiftUI
import Data
import ComposeUI
import Helper
import Model
//import ComposeUI
//import Firebase
//import FirebaseFirestoreSwift
//import FirebaseFirestore
//import FirebaseStorage
//import FirebaseStorageSwift
//import FirebaseAuth


@main
struct TourMemoryAppApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var myMemory = MyMemory(notes: [])
    var delegate: AppDelegate?
    let persistenceController = PersistenceController.shared
    @State var isLoading = true
    
    public init() {
        delegate = AppDelegate()
        myMemory.delegate = delegate
        myMemory.InitLoginState() //delegate設定後に必要
//        myMemory = MyMemory(notes: testMemoryNoteData) // tesdata
//        delegate?.saveNotesToFirestore(notes: myMemory.notes)
//      delegate?.deleteAllNotes()
        
//        delegate?.getNotesFromFirestore(myMemory: myMemory)
        myMemory.fetchAllNotes(managedObjectContext: persistenceController.container.viewContext) // coredata
        
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(myMemory)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}




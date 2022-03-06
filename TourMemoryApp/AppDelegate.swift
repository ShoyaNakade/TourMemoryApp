//
//  AppDelegate.swift
//  TourMemoryApp
//
//  Created by 中出翔也 on 2022/02/08.
//
import SwiftUI
import Data
import Foundation
import Model
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageSwift
import CryptoKit
import FirebaseCore
import GoogleSignIn
import ComposeUI
import GoogleMobileAds

//class AppDelegate: NSObject, UIApplicationDelegate {
class AppDelegate: NSObject, NotificationDelegate , UIApplicationDelegate{
    var semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
    
    var userId: String
    @State var isLoading: Bool
    
    private var controlMemoryModel = ControlMemoryModel(delegate: AddMemory())
    @Environment(\.managedObjectContext) var viewContext //coredata
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    //    override init() { //初期化メソッドを追記
    public override init() {
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        if UserDefaults.standard.string(forKey: "userId") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "userId")
        }
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //        UserDefaults.standard.set(false, forKey: "isId")
        
        if UserDefaults.standard.string(forKey: "email") == nil {
            UserDefaults.standard.set("", forKey: "email")
        }
        
        self.userId = UserDefaults.standard.string(forKey: "userId")!
        self._isLoading = State(initialValue: false)
        //        self._isLogin = State(initialValue: false)
    }
        
    
    func FirebaseReferenceUsers() -> CollectionReference{
        return Firestore.firestore().collection("users")
    }
    
    func saveAllNotesToFirestore (notes: [MemoryNote]) {
        Task {
            for note in notes {
                AddNoteFireStore(memoryNote: note)
//                let documentDatas = try! Firestore.Encoder().encode(note)
//                try! await FirebaseReferenceUsers().document(userId).collection("notes").document(note.id).setData(documentDatas)
//                SaveImageToStorage(memoryNote: note)
            }
        }
    }
    
    func getNotesFromFirestore (myMemory: MyMemory) {
//        let semaphore = DispatchSemaphore(value: 0)
        
        FirebaseReferenceUsers().document(userId).collection("notes").getDocuments() { (snapShot, error) in
            if let snapShot = snapShot {
                let documents = snapShot.documents
                myMemory.notes = documents.compactMap {
                    // この1行でデコード終了
                    return try? $0.data(as: MemoryNote.self)
                }
                // セマフォをインクリメント（+1）
                
//                print("sema: \(semaphore)")
                // Storageからイメージを抽出
                    self.GetALlNotesImageFromStorage(myMemory: myMemory)
                for note in myMemory.notes {
                    print("memory num: \(myMemory.notes.count)")
//                self.controlMemoryModel.delegate?.save(memoryNote: note, myMemory: myMemory, viewContext: self.viewContext) // coredataの追加。
                }
            } else {
                print("Data Not Found")
            }
            // セマフォをデクリメント（-1）、ただしセマフォが0の場合はsignal()の実行を待つ
//
//            print("sema: \(semaphore)")
            
//            self.semaphore.wait()
        }
//        self.semaphore.signal()
    }
    
    func deleteAllNotesFireStore(notes: [MemoryNote]) {
        FirebaseReferenceUsers().document(userId).collection("notes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.DeleteAllNotesImage(notes: notes) // storageデータの削除
                
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    func reloadFireStore(notes: [MemoryNote]) {
        Task {
            for note in notes {
                let documentDatas = try! Firestore.Encoder().encode(note)
                try! await FirebaseReferenceUsers().document(userId).collection("notes").document(note.id).setData(documentDatas)
            }
            print("fin reload firestore!")
        }
    }
    
    func AddNoteFireStore(memoryNote: MemoryNote) {
        Task {
            SaveImageToStorage(memoryNote: memoryNote)
            let imageNum = memoryNote.imageData.count
            var saveMemoryNote = memoryNote
            saveMemoryNote.imageData = []
            for num in 0 ..< imageNum {
                saveMemoryNote.imageData.append(Data(count: num))
            }
            
            let documentDatas = try! Firestore.Encoder().encode(saveMemoryNote)
            try! await FirebaseReferenceUsers().document(userId).collection("notes").document(saveMemoryNote.id).setData(documentDatas)
        }
    }
    
    func DeleteNoteFireStore(memoryNote: MemoryNote) {
        Task {
            do {
                try await FirebaseReferenceUsers().document(userId).collection("notes").document(memoryNote.id).delete()
                self.DeleteNoteImage(memoryNote: memoryNote)
            } catch {
                print("cant delete a memoryNote in fireStore")
            }
        }
    }
    
    func SaveImageToStorage(memoryNote: MemoryNote) {
        self.DeleteNoteImage(memoryNote: memoryNote) // 更新した時にゴミが残らないように空にする。
        
        let storage = Storage.storage()
        let reference = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        for imageIndex in 0 ..< memoryNote.imageData.count {
            let path = "users/\(userId)/notes/\(memoryNote.id)/image\(imageIndex).jpeg"
            let imageRef = reference.child(path)
            
            let data:Data = memoryNote.imageData[imageIndex]
            let uploadTask = imageRef.putData(data, metadata: metadata)
            
            var downloadURL: URL?
            uploadTask.observe(.success) { _ in
                imageRef.downloadURL { url, error in
                    if let url = url {
                        downloadURL = url
                    }
                }
            }
        }
    }
    
    func GetALlNotesImageFromStorage(myMemory: MyMemory) {
        let storage = Storage.storage()
        let semaphore = DispatchSemaphore(value: 0)


            print("download start")
            for noteIndex in 0 ..< myMemory.notes.count {
                let memoryNote = myMemory.notes[noteIndex]
                
                for imageIndex in 0 ..< memoryNote.imageData.count {
                    let path = "users/\(userId)/notes/\(memoryNote.id)/image\(imageIndex).jpeg"
                    let reference = storage.reference()
                    
                    // Create a reference to the file you want to download
                    let starsRef = storage.reference().child(path)
                    // Fetch the download URL
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            print("Error : \(error.localizedDescription)")
                        } else {
                            let data = try! Data(contentsOf: url!)
                            myMemory.notes[noteIndex].imageData[imageIndex] = data

                        }
                        semaphore.signal()
                        print("semaphore signal")
                        print(semaphore)
                    }
                }
                //                    semaphore.wait()
                print("semaphore wait")
                

//                print("semaphore End")
//
//                self.controlMemoryModel.delegate?.save(memoryNote: myMemory.notes[noteIndex], myMemory: myMemory, viewContext: self.viewContext) // coredataの追加。
        
           
        }
    }
    
    func DeleteNoteImage(memoryNote: MemoryNote) {
        let storage = Storage.storage()
        let reference = storage.reference()
        
        for imageIndex in 0 ..< memoryNote.imageData.count {
            let path = "users/\(userId)/notes/\(memoryNote.id)/image\(imageIndex).jpeg"
            let desertRef = reference.child(path)
            
            // Delete the file
            desertRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Error : \(error.localizedDescription)")
                } else {
                    // File deleted successfully
                }
            }
        }
    }
    
    func DeleteAllNotesImage(notes: [MemoryNote]) {
        for noteIndex in 0 ..< notes.count {
            let memoryNote = notes[noteIndex]
            DeleteNoteImage(memoryNote: memoryNote)
        }
    }
    
    //
    // 以下 auth用
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func ShowAuthUIVIew(isLogin: inout Bool) {
        isLogin = true
    }
    
    func LogOutFirebase() {
        let firebaseAuth = Auth.auth()
        do {
            LogOutIsId() // userdefaultsのlogout
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    //MARK: - UserDefaults
    func SetUserId(id: String) {
        self.userId = id
        UserDefaults.standard.set(self.userId, forKey: "userId")
    }
    
    func GetUserId() -> String {
        return UserDefaults.standard.string(forKey: "userId") ?? ""
    }
    
    func SetEmail(email: String) {
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func GetEmail() -> String {
        return UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    func LoginIsId() {
        UserDefaults.standard.set(true, forKey: "isId")
    }
    func LogOutIsId() {
        //        self.userId = ""
        //        self.SetUserId(id: userId)
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set(false, forKey: "isId")
    }
    
    func GetisId() -> Bool {
        return UserDefaults.standard.bool(forKey: "isId")
    }
    
}

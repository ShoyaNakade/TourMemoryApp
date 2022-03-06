//
//  NotificationDelegate.swift
//  
//
//  Created by 中出翔也 on 2022/02/08.
//

import Foundation
import SwiftUI


public protocol NotificationDelegate {
//    var notificationStatus: NotificationStatus { get set }
    var semaphore: DispatchSemaphore { get set }
    func reloadFireStore(notes: [MemoryNote]) //全データの更新
    func deleteAllNotesFireStore(notes: [MemoryNote])
    func AddNoteFireStore(memoryNote: MemoryNote) // 1Dataの追加
    func DeleteNoteFireStore(memoryNote: MemoryNote) // 1Dataの削除
    func DeleteNoteImage(memoryNote: MemoryNote) // Storageの削除
    
    func saveAllNotesToFirestore (notes: [MemoryNote])
    func getNotesFromFirestore (myMemory: MyMemory)
    
    func ShowAuthUIVIew(isLogin: inout Bool)
    func SetUserId(id: String)
    func GetUserId() -> String
    func SetEmail(email: String)
    func GetEmail() -> String
    func LoginIsId()
    func LogOutIsId()
    func GetisId() -> Bool
    func LogOutFirebase()
}

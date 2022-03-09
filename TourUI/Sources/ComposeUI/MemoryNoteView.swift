//
//  MemoryNoteView..swift
//  
//
//  Created by 中出翔也 on 2022/01/08.
//

import SwiftUI
import MapKit
import Model
import Data
import CoreLocation
import CoreData

public struct MemoryNoteView: View {
    //MARK: - PROPERTY
    @Binding public var memoryNote: MemoryNote
    @State private var isModalActive: Bool = false
    @State private var showingAlert = false
    @State private var isSlider: Bool = true
    @EnvironmentObject var myMemory: MyMemory
    private var controlMemoryModel = ControlMemoryModel(delegate: AddMemory())
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext //coredata
    
    public init(memoryNote: Binding<MemoryNote>) {
        self._memoryNote = memoryNote
     }
    
    //MARK: - FUNC
    private func sharePost(mes:String, imageData:Data?) {
        //シェアする内容
        let defData = UIImage(systemName: "photo")?.jpegData(compressionQuality: 0.05)
        let massage = mes
        let image = UIImage(data: (imageData ?? defData)!)
        let link = URL(string: "https://maps.google.com/?q=\(self.memoryNote.coordinate.latitude),\(self.memoryNote.coordinate.longitude)")!

        let activityViewController = UIActivityViewController(activityItems: [massage,image,link], applicationActivities: nil)
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteMemoryNote() {
//        controlMemoryModel.delegate?.DeleteMemoryNote(memoryNote: memoryNote, myMemory: myMemory, viewContext: viewContext)
        
        controlMemoryModel.DeleteMemoryNote(memoryNote: memoryNote, myMemory: myMemory, viewContext: viewContext)
        
//        // ----------Core Dataの削除------------
//        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
//        let predicate = NSPredicate(format:"id = %@", memoryNote.id )
//        request.predicate = predicate
//        do {
//            let requestNotes = try viewContext.fetch(request)
//            for MyNote in requestNotes {
//                // 一つだが配列のため
//                viewContext.delete(MyNote)
//                }
//            try viewContext.save()
//        }
//        catch let error as NSError {
//            print("Error: \(error.localizedDescription), \(error.userInfo)")
//        }
//        // ------------ここまで------------
//        // ------------FireStoreからのデータ削除
////        myMemory.delegate?.DeleteNoteFireStore(memoryNote: memoryNote)
//
//        // ----------MemoryNoteの削除------------
//        if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == memoryNote.id}) {
//            myMemory.notes.remove(at: targetIndex)
//        }
    }
    
    
    //MARK: - BODY
    public var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text(memoryNote.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(3)
                        .foregroundColor(.primary)
                }
                
                Divider()
                
                VStack(spacing: 0) {
                    HStack {
                        StarView(starNum: $memoryNote.ratio ,isChanged: false, starHeight: 25 )
                        Spacer()
                        if memoryNote.time != nil{
                            Text(memoryNote.time, style: .date)
                                .foregroundColor(.gray)
                        }
                    }//:hstacl
                    HStack {
                        Text("カテゴリー:")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                        ShowCategoryView(heightSize: 20, memoryNote: memoryNote)
                            .foregroundColor(.blue)
                            .padding(.top,5)
                            .padding(.bottom,5)
                        Spacer()
                    }//:hstack
                    HStack {
                        Text("写真の表示:")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                        Picker(selection: $isSlider) {
                            Text("スライダー").tag(true)
                            Text("拡大").tag(false)
                        } label: {
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 250)
                        Spacer()
                    }
                }
                
                VStack {
                    if isSlider {
                        InsetGalleryView(memoryNote: memoryNote)
                            .foregroundColor(.secondary)
                    } else {
                        InsetGalleryColumn1View(memoryNote: memoryNote)
                    }
                }
                .padding(.top,20)
                
                VStack {
                    Text(memoryNote.contentsText)
                        .font(.body)
                }
                .padding(.top,15)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .leading)
                        .foregroundColor(.red)
                    Text(" 場所")
                        .font(.title3)
                        .fontWeight(.black)
                    Spacer()
                    Button(action: {
                        sharePost(mes: "\(memoryNote.title)\n\(memoryNote.address)", imageData: memoryNote.imageData.first)

                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 20, height: 25, alignment: .leading)
                            Text("教える")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                } //:hstack
                .padding(.top,40)
                
                Divider()
                
                Text(memoryNote.address)
                    .font(.body)
                    .foregroundColor(.primary)

                InsetMapView(center: memoryNote.getlocation(),lat: $memoryNote.coordinate.latitude, lng:$memoryNote.coordinate.longitude)
                
                HStack {
                    Spacer()
                    Button(action:{
                        showingAlert.toggle()
                    }){
                        Text("この日記を削除")
                            .font(.headline)
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                    .alert("この記録を削除して良いですか？", isPresented: $showingAlert){
                        Button("はい"){
                            // 確認
                            deleteMemoryNote()
//                            if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == memoryNote.id}) {
//                                myMemory.notes.remove(at: targetIndex)
//                            }
                            // 前の画面に戻す
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("いいえ"){
                            // ボタン2が押された時の処理
                        }
                    } message: {
                        Text("一度消すと元に戻せません")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(.top, 40)
                
            }
            .padding()
            .navigationBarTitle(memoryNote.noteTypeToString(),displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isModalActive.toggle()
            }, label: {
                VStack {
                    Image(systemName: "highlighter")
                        .resizable()
                        .frame(width: 23, height: 23, alignment: .leading)
                    Text("編集")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }))
        }//:scroll
        .sheet(isPresented: $isModalActive) {
            EditNoteView(memoryNote: $memoryNote, memoryNoteTemp: memoryNote)
        }
    }
}

struct MemoryNoteView_Previews: PreviewProvider {
    @EnvironmentObject static var myMemory: MyMemory
    @State static var prevNote: MemoryNote = testMemoryNoteData[0]
    static var previews: some View {
        NavigationView {
            MemoryNoteView(memoryNote: $prevNote)
                .environmentObject(MyMemory(notes:testMemoryNoteData))
        }
    }
}

//
//  EditNoteView.swift
//  
//
//  Created by 中出翔也 on 2022/01/17.
//

import SwiftUI
import Model
import Extension
import Data
import Helper
import PhotosUI
import os
import CoreData

public struct EditNoteView: View {
    //MARK: - PROPERTY
    private  let generator = UINotificationFeedbackGenerator()
    private var controlMemoryModel = ControlMemoryModel(delegate: AddMemory())
    private let maxImageNum = 5 // 写真の最大登録可能枚数
    private var imageOver:Bool {
        if memoryNoteTemp.imageData.count > maxImageNum {
            return true
        }
        else {
            return false
        }
    } // 写真の枚数オーバー
    @EnvironmentObject var myMemory: MyMemory
    
    //    @FocusState private var focus: Bool //keyboard
    @Binding public var memoryNote: MemoryNote
    @State var memoryNoteTemp: MemoryNote // 変更を保存する前の値にする。
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext //coredata
    
    public init(memoryNote: Binding<MemoryNote>, memoryNoteTemp: MemoryNote){
        self._memoryNote = memoryNote
        _memoryNoteTemp = State(initialValue: memoryNoteTemp)
    }
    
    
    //MARK: - PHPICKER
    @State private var showPHPicker:Bool = false
    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        return config
    }
    let logger = Logger()
    //    var columns: [GridItem] = Array(repeating: .init(.fixed(100)), count: 3)
    
    
    //MARK: - FUNCTION
    private func editSave() {
        //        model.delegate?.save(memoryNote: memoryNote)
        controlMemoryModel.delegate?.change(memoryNote: memoryNoteTemp, myMemory: myMemory, viewContext: viewContext)
//        CLGeocoder().geocodeAddressString(memoryNoteTemp.address) { placemarks, error in
//            if let lat = placemarks?.first?.location?.coordinate.latitude {
//                memoryNoteTemp.coordinate.latitude = lat
//            }
//            if let lng = placemarks?.first?.location?.coordinate.longitude {
//                memoryNoteTemp.coordinate.longitude = lng
//            }
//
//            if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == memoryNoteTemp.id}) {
//                myMemory.notes[targetIndex] = memoryNoteTemp
//            }
//
//            // ----------Core Dataの変更------------
//            let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
//            let predicate = NSPredicate(format:"id = %@", memoryNoteTemp.id )
//            request.predicate = predicate
//            do {
//                let requestNotes = try viewContext.fetch(request)
//                print(requestNotes.count)
//                for MyNote in requestNotes {
//                    // 一つなはずだが配列のため
//                    MyNote.importMemoryNote(in: viewContext, memoryNote: memoryNoteTemp)
//                }
//                try viewContext.save()
//            }
//            catch let error as NSError {
//                print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
//            }
//            // ----------Core Dataの変更------------
//            self.generator.notificationOccurred(.success)
//            presentationMode.wrappedValue.dismiss()
//        }
    }
    
    //MARK: - BODY
    
    public var body: some View {
        Form {
            AddEditView(memoryNote: $memoryNoteTemp, showPHPicker: $showPHPicker)
            
            Section {
                Button {
                    self.editSave()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("編集内容を登録する")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                }
                .padding()
                .background(imageOver ? .gray: .blue )
                .cornerRadius(10)
                .disabled(imageOver)
            }
            Section("操作") {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "minus.circle.fill")
                        Text("キャンセル")
                    }
                    .foregroundColor(.red)
                }
            }
        }//: form
        .sheet(isPresented: $showPHPicker) {
            SwiftUIPHPicker(configuration: AddMemoryNoteView.config) { results in
                for result in results {
                    let itemProvider = result.itemProvider
                    if itemProvider.canLoadObject(ofClass: UIImage.self) {
                        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            if let image = image as? UIImage {
                                DispatchQueue.main.async {
                                    //                                    self.memoryNoteTemp.images.append(image)
                                    self.memoryNoteTemp.imageData.append(image.jpegData(compressionQuality: 0.01)!)
                                }
                            }
                            if let error = error {
                                logger.error("\(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }//: view
}



struct EditNoteView_Previews: PreviewProvider {
    @State static var prenote = MemoryNote.placeholder
    
//    class Delegate: ControlMemoryProtocol {
//        func save(memoryNote: MemoryNote) {
//            // save
//        }
//    }
    static var previews: some View {
        //        @EnvironmentObject var myMemory: MyMemory
        EditNoteView(memoryNote: $prenote, memoryNoteTemp: MemoryNote.placeholder)
        //            .environmentObject(AddMemoryModel(delegate: Delegate()))
        //            .environmentObject(MyMemory(notes:[], myAnnotations: []))
    }
}

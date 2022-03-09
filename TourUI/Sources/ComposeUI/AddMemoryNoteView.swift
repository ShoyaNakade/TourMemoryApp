//
//  AddMemoryNoteView.swift
//  
//
//  Created by 中出翔也 on 2022/01/08.
//

import SwiftUI
import Model
import Extension
import Data
import Helper
import PhotosUI
import os
import CoreData

public struct AddMemoryNoteView: View {
    //MARK: - PROPERTY
    private  let generator = UINotificationFeedbackGenerator()
    private var controlMemoryModel = ControlMemoryModel(delegate: AddMemory())
    private let maxImageNum = 5 // 写真の最大登録可能枚数
    private var imageOver:Bool {
        if memoryNote.imageData.count > maxImageNum {
            return true
        }
        else {
            return false
        }
    } // 写真の枚数オーバー
//    @EnvironmentObject var model: AddMemoryModel
    @EnvironmentObject var myMemory: MyMemory
    @State public var memoryNote: MemoryNote
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext //coredata
    
    public init(memoryNote: MemoryNote) {
        _memoryNote = State(initialValue: memoryNote)
    }

    
    //MARK: - PHPICKER
    @State private var showPHPicker:Bool = false
    let logger = Logger()
    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        return config
    }
    
    //MARK: - FUNCTION
    private func save() {
        controlMemoryModel.delegate?.save(memoryNote: memoryNote, myMemory: myMemory, viewContext: viewContext)  
    }
    
    //MARK: - BODY
    
    public var body: some View {
        Form {
            AddEditView(memoryNote: $memoryNote, showPHPicker: $showPHPicker)
            
            Section {
                Button {
                    self.save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("登録する")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                }
                .padding()
                .background( imageOver ? .gray: .blue )
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
//                                    self.memoryNote.images.append(image)
                                    self.memoryNote.imageData.append(image.jpegData(compressionQuality: 0.01)!)
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

struct AddMemoryNoteView_Previews: PreviewProvider {
//    class Delegate: ControlMemoryProtocol {
//        func save(memoryNote: MemoryNote) {
//            // save
//        }
//    }
    static var previews: some View {
//        @EnvironmentObject var myMemory: MyMemory
        AddMemoryNoteView(memoryNote: MemoryNote.placeholder)
//            .environmentObject(AddMemoryModel(delegate: Delegate()))
//            .environmentObject(MyMemory(notes: [], myAnnotations: []))
    }
}

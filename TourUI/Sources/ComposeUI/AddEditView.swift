//
//  AddEditView.swift
//  Add,Edit の共通部分
//
//  Created by 中出翔也 on 2022/01/20.
//

import SwiftUI
import Model
import Extension
import Data
import Helper
import PhotosUI
import os

struct AddEditView: View {
    //MARK: - PROPERTY
    @FocusState private var focus: Bool //keyboard
    @Binding var memoryNote: MemoryNote // 変更を保存する前の値にする。
    @Binding var showPHPicker: Bool
    private var columns: [GridItem] = Array(repeating: .init(.fixed(100)), count: 3)
    private let maxImageNum = 5 // 写真の最大登録可能枚数
    private var imageOver:Bool {
        if memoryNote.imageData.count > maxImageNum {
            return true
        }
        else {
            return false
        }
    } // 写真の枚数オーバー
    
    public init(memoryNote: Binding<MemoryNote>, showPHPicker: Binding<Bool>) {
        self._memoryNote = memoryNote
        self._showPHPicker = showPHPicker
    }

    
    public var body: some View {
        Section("記録の種類") {
            Picker(selection: $memoryNote.noteType) {
                Text("日記").tag(NoteType.memory)
                Text("行きたい所").tag(NoteType.destination)
            } label: {
                Text("test")
            }
            .pickerStyle(.segmented)
        }
        Section("タイトル") {
            TextField("タイトルを入力", text: $memoryNote.title)
        }
        Section("場所") {
            TextField("住所を入力", text: $memoryNote.address)
        }
//        Section(header: HStack {
//            Toggle("日付を設定する", isOn: Binding(isNotNil: $memoryNote.time, defaultValue: Date()) )
//        }) {
//            if memoryNote.time != nil {
//                DatePicker("日付", selection: Binding($memoryNote.time, Date()), displayedComponents: .date)
//            }
//        }
        Section("日付の設定") {
                DatePicker("日付", selection: $memoryNote.time, displayedComponents: .date)
        }
        
        Section(header: HStack {
            if self.memoryNote.noteType == .memory{
                Text("おすすめ度")
            } else{
                Text("行きたい度")
            }
            Spacer()
            StarView(starNum: $memoryNote.ratio, isChanged: true, starHeight: 25)
        }) {
            // no contents
        }
        Section("カテゴリー") {
            SelectCategoryView(memoryNote: $memoryNote)
        }
        Section {
            TextEditor(text: $memoryNote.contentsText)
                .frame(height: 250)
                .focused(self.$focus)
        } header: {
            HStack {
                Text("内容・メモ等")
                    .padding(.top,10)
                    .padding(.bottom,15)
                Spacer()
                if focus {
                    Button {
                        self.focus = false //close keyboad
                    } label: {
                        Text("編集完了")
                            .foregroundColor(.white)
                            .padding(10)
                            .padding(.leading,15)
                            .padding(.trailing,15)
                            .cornerRadius(20)
                            .background(.blue)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    }
                    .opacity(self.focus ? 1 : 0)
                    .animation(Animation.easeIn(duration: 1), value: focus)
                }
            }
        }
        Section("写真") {
            Button {
                // 写真追加のaction
                showPHPicker.toggle()
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                    Text("写真を追加する")
                    Spacer()
                    
                }
                .padding(15)
            }
            LazyVGrid(columns: columns) {
                ForEach(Array(memoryNote.imageData.enumerated()), id: \.offset) { index, imageData in
//                    Image(uiImage: image)
                    Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
                        .resizable().scaledToFit()
                        .onTapGesture(count:2) {
                            memoryNote.imageData.remove(at: index)
                        }
                }
            }
            VStack(alignment:.leading) {
                if memoryNote.imageData.count != 0 {
                    Text("※ダブルタップで削除可能")
//                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("※保存できる写真は\(maxImageNum)枚までです!")
                        .foregroundColor(imageOver ? .red: .gray)
                }
            }
        }
    }
}

struct AddEditView_Previews: PreviewProvider {
    @State static var prenote = testMemoryNoteData[2]
    @State static var picker = false
    static var previews: some View {
        Form {
            AddEditView(memoryNote: $prenote, showPHPicker: $picker)
        }
    }
}

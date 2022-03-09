//
//  SettingView.swift
//  
//
//  Created by 中出翔也 on 2022/01/23.
//

import SwiftUI
import Data
import Model
import CoreData

public struct SettingView: View {
    // MARK: - PROPERTIES
    private var version: String = "1.0.0"
    
    @EnvironmentObject var myMemory: MyMemory
    @State private var enableNotification: Bool = true
    @State private var deleteNotification: Bool = false
    @State private var deleteFinish: Bool = false
    @State private var backupNotification: Bool = false
    @State private var backupFinish: Bool = false
    @State private var restoreNotification: Bool = false
    @State private var restoreFinish: Bool = false
    private var controlMemoryModel = ControlMemoryModel(delegate: AddMemory())
    @Environment(\.managedObjectContext) var viewContext //coredata
    
    public init() {
        
    }
    private func SCImage(named name: String) -> UIImage? {
        UIImage(named: name, in: Bundle.module, compatibleWith: nil)
    }
    
    private func deleteAllMemoryNotes() {
//        controlMemoryModel.delegate?.DeleteAllMemoryNotes(myMemory: myMemory, viewContext: viewContext)
        
        controlMemoryModel.DeleteAllMemoryNotes(myMemory: myMemory, viewContext: viewContext)
    }
    
    
    private func Restore() {
        //        let semaphore = DispatchSemaphore(value: 0)
        //        DispatchQueue.global().async {
        print("Thread1:FS install start.")
        deleteAllMemoryNotes() // coredataを削除
        myMemory.delegate?.getNotesFromFirestore(myMemory: myMemory)
        print("Thread1:FS install end.")
        //            DispatchQueue.global().sync {
        //
        //            }
        //        }
        //        semaphore.signal()
        //        myMemory.delegate?.semaphore.wait()
        // core でーたへのimportは次の各員ボタンで行う。
        
        //        semaphore.wait()
    }
    
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // MARK: - HEADER
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: SCImage(named: "MapNote")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80, alignment: .center)
                Text("Map Note".uppercased())
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
            }
            .padding(.bottom,5)
            
            Form {
                // MARK: - SECTION #1
                Section(header: Text("一般設定")) {
                    Toggle(isOn: $enableNotification) {
                        Text("アプリの詳細表示")
                    }
                    Toggle(isOn: $myMemory.showLatLng) {
                        Text("経度・緯度の表示")
                    }
                }
                Section(header: Text("ログイン")) {
                    HStack {
                        Text("ログイン登録").foregroundColor(Color.gray)
                        Spacer()
                        if !myMemory.isID {
                            Button {
                                myMemory.delegate?.ShowAuthUIVIew(isLogin: &myMemory.isLogin)
                            } label: {
                                Text("サインイン")
                            }
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                            .background(.blue)
                            .cornerRadius(5)
                        } else {
                            Button {
                                myMemory.delegate?.LogOutFirebase() // fsからlogoutし、userdefaultを変更
                                myMemory.logout()// myMemoryのプロパティを初期化
                            } label: {
                                Text("サインアウト")
                            }
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                            .background(.red)
                            .cornerRadius(5)
                        }
                        
                    }
                    HStack {
                        Text("ユーザー登録").foregroundColor(Color.gray)
                        Spacer()
                        HStack {
                            if myMemory.isID {
                                Image(systemName:"checkmark.icloud")
                            }
                            Text(myMemory.isID ?  "登録済み" : "未登録")
                        }
                        .foregroundColor(.gray)
                    }
                    HStack {
                        Text("メールアドレス").foregroundColor(Color.gray)
                        Spacer()
                        Text(myMemory.email)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    if myMemory.isID {
                        HStack {
                            Spacer()
                            Button {
                                backupNotification.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.up")
                                    Text(" クラウドに保存 ")
                                }
                                .padding(.top,10)
                                .padding(.bottom,10)
                                .padding(.leading,40)
                                .padding(.trailing,40)
                                .cornerRadius(20)
                                .background(.blue)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .padding()
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                restoreNotification.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.down")
                                    Text("クラウドから復元")
                                }
                                .padding(.top,10)
                                .padding(.bottom,10)
                                .padding(.leading,40)
                                .padding(.trailing,40)
                                .cornerRadius(20)
                                .background(.red)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                                .padding()
                            }
                            Spacer()
                        }
                        
                    }
                    else {
                        Text("ログインを完了するとクラウドにデータを保存できます。")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                    }
                } header: {
                    Text("バックアップへ保存・復元")
                }
                
                Section(header: Text("データの削除")) {
                    Button {
                        deleteNotification.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("全データ削除")
                                .padding(10)
                                .padding(.leading,50)
                                .padding(.trailing,50)
                                .cornerRadius(20)
                                .background(.red)
                                .clipShape(Capsule())
                                .shadow(radius: 4)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                    }
                }
                
                // MARK: - SECTION #2
                Section(header: Text("アプリケーション情報")) {
                    if enableNotification {
                        HStack {
                            Text("アプリ情報").foregroundColor(Color.gray)
                            Spacer()
                            Text("旅マップ")
                        }
                        HStack {
                            Text("対応").foregroundColor(Color.gray)
                            Spacer()
                            Text("iPhone")
                        }
                        HStack {
                            Text("デベロッパー").foregroundColor(Color.gray)
                            Spacer()
                            Text("Shoya Nakade")
                        }
                        HStack {
                            Text("デザイナー").foregroundColor(Color.gray)
                            Spacer()
                            Text("Shoya Nakade")
                        }
                        HStack {
                            Text("ホームページ").foregroundColor(Color.gray)
                            Spacer()
                            Text("https://gritup.site")
                        }
                        HStack {
                            Text("プライバシーポリシー").foregroundColor(Color.gray)
                            Spacer()
                            Text("https://gritup.site/map-note/")
                        }
                        HStack {
                            Text("Instagram").foregroundColor(Color.gray)
                            Spacer()
                            Text("https://www.instagram.com/shoya_web_creator/")
                        }
                        HStack {
                            Text("バージョン").foregroundColor(Color.gray)
                            Spacer()
                            Text("\(version)")
                        }
                    } else {
                        HStack {
                            Text("メッセージ").foregroundColor(Color.gray)
                            Spacer()
                            Text("お使いいただきありがとうございます！素敵な旅の手助けになれば幸いです。")
                                .font(.footnote)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("設定",displayMode: .inline)
        .frame(maxWidth: 640)
        //MARK: - Delete
        .alert("全記録を削除して良いですか？(クラウド上のデータは削除されません)", isPresented: $deleteNotification){
            Button("はい"){
                deleteAllMemoryNotes()
                deleteFinish.toggle()
            }
            Button("いいえ"){
            }
        } message: {
            Text("一度消すと元に戻せません")
                .foregroundColor(.red)
        }
        .alert("全記録を削除しました", isPresented: $deleteFinish){
            Button("了解"){
            }
        } message: {
            Text("全てのデータが正常に削除されました。")
                .foregroundColor(.red)
        }
        //MARK: - Backup
        .alert("クラウドにデータをバックアップしますか？", isPresented: $backupNotification){
            Button("はい"){
                myMemory.delegate?.saveAllNotesToFirestore(notes: myMemory.notes)
                myMemory.isLoading.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 8 ) {
                    myMemory.isLoading = false
                    backupFinish.toggle()
                }
            }
            Button("いいえ"){
            }
        } message: {
            Text("アプリ専用のクラウドにデータをバックアップできます。")
        }
        .alert("ノートデータをクラウドに保存しました。", isPresented: $backupFinish){
            Button("了解"){
                
            }
        } message: {
            //          Text("完全に保存するるまでに1分ほどかからう場合があります。")
            //              .foregroundColor(.red)
        }
        //MARK: - restore
        .alert("クラウドからデータを復元しますか？", isPresented: $restoreNotification){
            Button("はい"){
                Restore()
                //              deleteAllMemoryNotes() // coredataを削除
                //              myMemory.delegate?.getNotesFromFirestore(myMemory: myMemory)
                myMemory.isLoading.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
                    myMemory.isLoading = false
                    restoreFinish.toggle()
                }
            }
            Button("いいえ"){
            }
        } message: {
            Text("クラウドから前回のバックアップデータを復元します。保存されていない現在のデータは削除されるのでご注意ください!")
        }
        .alert("バックアップデータを読み込みました。データを更新します。", isPresented: $restoreFinish){
            Button("了解"){
                print("Thread2: Import start.")
                controlMemoryModel.ImportMyMemoryToCore(myMemory: myMemory, viewContext: viewContext) // coredataに保存
                print("Thread2: Import end.")
                myMemory.isLoading.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
                    myMemory.isLoading = false
                }
            }
        } message: {
            Text("完全に読み込まれるまでに30秒程度かかる場合があります。")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var myMemory = MyMemory(notes: testMemoryNoteData)
    static var context = PersistenceController.shared.container.viewContext
    //    @Environment(\.managedObjectContext) var viewContext //coredata
    
    static var previews: some View {
        SettingView()
            .environmentObject(myMemory)
            .environment(\.managedObjectContext, context)
    }
}

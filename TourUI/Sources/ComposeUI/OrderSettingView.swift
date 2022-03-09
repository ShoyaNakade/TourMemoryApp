//
//  OrderSettingView.swift
//  
//
//  Created by 中出翔也 on 2022/02/19.
//

import SwiftUI
import Model
import Data

public struct OrderSettingView: View {
    @EnvironmentObject var myMemory: MyMemory
    @Environment(\.presentationMode) var presentationMode
    
    public init () {
        
    }
    
    public var body: some View {
        Form {
            // MARK: - SECTION #1
            Section(header: Text("日付でソート")) {
                Picker(selection: $myMemory.orderedByDate) {
                    Text("新しい順").tag(OrderedByDate.recent)
                    Text("古い順").tag(OrderedByDate.old)
                } label: {
                    // none
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("お気に入りでソート")) {
                Picker(selection: $myMemory.orderedByRatio) {
                    Text("無し").tag(OrderedByRatio.none)
                    Text("高い順").tag(OrderedByRatio.max)
                    Text("低い順").tag(OrderedByRatio.min)
                } label: {
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("カテゴリー")) {
                Toggle(isOn: $myMemory.isFilterCategory) {
                    Text("フィルターの有効化")
                }
                if myMemory.isFilterCategory {
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(Category.allCases, id: \.self) { category in
                                Button {
                                    if myMemory.filterCategories.contains(category) {
                                        myMemory.filterCategories.remove(category)
                                    } else {
                                        myMemory.filterCategories.insert(category)
                                    }
                                } label: {
                                    VStack {
                                        if myMemory.filterCategories.contains(category) {
                                            Image(systemName:category.toImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 30 , alignment: .center)
                                                .foregroundColor(.red)
                                            Text(category.text)
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        } else {
                                            Image(systemName:category.toImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 30 , alignment: .center)
                                                .foregroundColor(.gray)
                                            Text(category.text)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                        }
                    }
                } else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Spacer()
                    Text("設定完了(閉じる）")
                        .font(.title2)
                    Spacer()
                }
            }
            
        }
    }
}

struct OrderSettingView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSettingView()
            .environmentObject(MyMemory(notes:testMemoryNoteData))
    }
}

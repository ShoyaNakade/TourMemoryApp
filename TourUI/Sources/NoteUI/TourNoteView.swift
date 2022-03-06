//
//  TourNoteView.swift
//  
//
//  Created by 中出翔也 on 2022/01/05.
//

import SwiftUI
import ComposeUI
import Model
import Data

public struct TourNoteView: View {
    //MARK: - PROEPRTY
    @State private var pulsate: Bool = false
    @State private var searchText : String = ""
    @State private var isModalActive : Bool = false
    @State private var isOrderModalActive: Bool = false
    @EnvironmentObject var myMemory: MyMemory
    @Environment(\.presentationMode) var presentationMode
    
    public init() {
        // no init
    }

    //MARK: - BODY
    public var body: some View {
        NavigationView {
            ScrollView() {
                VStack(spacing:30) {
                    ForEach(myMemory.searchResults.indices ,id: \.self) { index in
                        if myMemory.searchResults[index].noteType == .memory {
                            NoteCardView(memoryNote: $myMemory.searchResults[index])
                        }
                    }//:loop
                }//:vstack
            }
//            .searchable(text: $searchText)
            .searchable(text: $myMemory.searchText)
            .navigationBarTitle("旅の思い出", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                isOrderModalActive.toggle()
            }, label: {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
            }))
            //MARK: - overlay
        }//:nav
        .overlay(
            HStack(alignment:.bottom) {
                Spacer()
                VStack(alignment:.trailing) {
                    Spacer()
                    Button {
                        self.isModalActive = true
                    } label: {
                        AddIconView()
                    }
                    .sheet(isPresented: $isModalActive) {
                        AddMemoryNoteView(memoryNote: MemoryNote.placeholder)
                    }
                    .sheet(isPresented: $isOrderModalActive) {
                     OrderSettingView()
                            .environmentObject(myMemory)
                    }
                } //:vstack
            }
            .padding()
        )
        
    }
}

struct TourNoteView_Previews: PreviewProvider {
    
//    class Delegate: ControlMemoryProtocol {
//        func save(memoryNote: MemoryNote) {
//            // save
//        }
//    }
    static var myMemory = MyMemory(notes: testMemoryNoteData)
    static var previews: some View {
        TabView {
                TourNoteView()
                    .environmentObject(myMemory)
//                    .environmentObject(AddMemoryModel(delegate: Delegate()))
        }
    }
}

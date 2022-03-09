//
//  TourDestinationView.swift
//  
//
//  Created by 中出翔也 on 2022/01/15.
//

import SwiftUI
import ComposeUI
import Model
import Data

public struct TourDestinationView: View {
    //MARK: - PROEPRTY
    @State private var pulsate: Bool = false
    @State private var searchText : String = ""
    @State private var isModalActive : Bool = false
    @State private var isOrderModalActive : Bool = false
    @EnvironmentObject var myMemory : MyMemory
    @Environment(\.presentationMode) var presentationMode
    
    public init(){
        
    }

    //MARK: - BODY
    public var body: some View {
        NavigationView {
            ScrollView() {
                VStack(spacing:30) {
//                    ForEach(myMemory.searchResults.indices.reversed() ,id: \.self) { index in
//                        if myMemory.searchResults[index].noteType == .destination
//                        {
//                            DestinationCardView(memoryNote: $myMemory.searchResults[index])
//                        }
//                    }//:loop
                    ForEach(myMemory.searchResults.indices ,id: \.self) { index in
                        if myMemory.searchResults[index].noteType == .destination
                        {
                            DestinationCardView(memoryNote: $myMemory.searchResults[index])
                        }
                    }//:loop
                }//:vstack
            }
            .searchable(text: $myMemory.searchText)
            .navigationBarTitle("行きたい所" ,displayMode: .inline)

            .navigationBarItems(trailing: Button(action: {
                isOrderModalActive.toggle()
            }, label: {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
            }))
            .onAppear() {
                self.pulsate.toggle()
            }
        }// :mav
        //MARK: - overlay
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button {
                        self.isModalActive = true
                    } label: {
                        AddIconView()
                    }
                    .sheet(isPresented: $isModalActive) {
                        AddMemoryNoteView(memoryNote: MemoryNote.placeholderDestination)
                    }
                    .sheet(isPresented: $isOrderModalActive) {
                     OrderSettingView()
                            .environmentObject(myMemory)
                    }
                } //:vstack
            }.padding()
        )//:overlay
    }
}

struct TourDestinationView_Previews: PreviewProvider {
    static var previews: some View {
//        TabView {
//            NavigationView {
                TourDestinationView()
//                    .environmentObject(MyMemory(notes:testMemoryNoteData, myAnnotations: testAnnotations))
                    .environmentObject(MyMemory(notes:testMemoryNoteData))
//            }
//        }
    }
}

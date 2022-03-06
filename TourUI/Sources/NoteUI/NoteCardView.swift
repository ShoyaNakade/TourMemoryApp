//
//  MemoryCardView.swift
//  
//
//  Created by 中出翔也 on 2022/01/07.
//

import SwiftUI
import Model
import Data
import ComposeUI

struct NoteCardView: View {
    //MARK: - PROPERTY
    @Binding public var memoryNote: MemoryNote
    
    public init(memoryNote: Binding<MemoryNote>) {
        self._memoryNote = memoryNote
    }
    
    
    //MARK: - body
    public  var body: some View {
        LazyVStack(alignment: .leading, spacing: 1) {
            NavigationLink(destination: MemoryNoteView(memoryNote: $memoryNote)) {
                VStack(alignment: .leading) {
                    Text(memoryNote.title)
                        .font(.title3)
                        .lineLimit(1)
//                        .padding(0)
                        .foregroundColor(.black)
                    Divider()
                    VStack {
                        HStack {
                            StarView(starNum: $memoryNote.ratio ,isChanged: false, starHeight: 20)
                            Spacer()
                            if memoryNote.time != nil {
                                Text(memoryNote.time, style: .date)
                                    .foregroundColor(.gray)
                            }
                        }//:hstacl
                        HStack {
                            Text("カテゴリー: ")
                                .foregroundColor(.black) //背景が白
                                .font(.subheadline)
                            ShowCategoryView(heightSize: 15, memoryNote: memoryNote)
                                .foregroundColor(.blue)
                            Spacer()
                        }//:hstack
                        .padding(.bottom,5)
                    }
                }
            }
            InsetGalleryView(memoryNote: memoryNote)
        }//:Lazyvstack
        .padding()
        .background(.white)
        .cornerRadius(10)
        .clipped()
        .shadow(color: .gray, radius: 5, x: 0, y: 0)
    }
    
}

struct MemoryCardView_Previews: PreviewProvider {
    @State static var prevNote: MemoryNote = testMemoryNoteData[0]
    static var previews: some View {
        NavigationView {
            NoteCardView(memoryNote: $prevNote)
//                .environmentObject(MyMemory(notes:testMemoryNoteData, myAnnotations: testAnnotations))
                .environmentObject(MyMemory(notes:testMemoryNoteData))
        }
    }
}

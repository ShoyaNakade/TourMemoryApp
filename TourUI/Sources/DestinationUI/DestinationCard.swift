//
//  DestinationCardView.swift
//  
//
//  Created by 中出翔也 on 2022/01/15.
//

import SwiftUI
import Model
import Data
import ComposeUI

public struct DestinationCardView: View {
    //MARK: - PROPERTY
    @Binding public var memoryNote: MemoryNote
    
    public init(memoryNote: Binding<MemoryNote>) {
        self._memoryNote = memoryNote
    }
    
    
    //MARK: - body
    public  var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: MemoryNoteView(memoryNote: $memoryNote)) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        if memoryNote.imageData.count != 0 {
                            Image(uiImage: UIImage(data: memoryNote.imageData[0]) ?? UIImage(systemName: "photo")!)
                                .resizable()
//                                .frame(minWidth: 150, idealWidth: 150, maxWidth: 180, minHeight: 100, idealHeight: 100, maxHeight: 180)
                                .frame(width:150, height:120)
                                .scaledToFill()
//                                .frame(width:150,height: 200)
                                .cornerRadius(15)
                               
                        } else{
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width:150)
                                .cornerRadius(12)
                                .foregroundColor(.black)
                        }

                        
//                        if memoryNote.gallery.count != 0 {
//                            AsyncImage(url: memoryNote.gallery[0]) { image in
//                                image
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width:150)
//                                    .cornerRadius(12)
//                            } placeholder: {
//                                    // default image
//                                Color.gray
//                            }
//                        }
                        
                    }
                    VStack(alignment: .leading) {
                        Text(memoryNote.title)
                            .font(.headline)
                            .lineLimit(1)
                            .padding(0)
                            .foregroundColor(.black)
                        Divider()
                        HStack {
                            StarView(starNum: $memoryNote.ratio ,isChanged: false ,starHeight: 15)
                            Spacer()
                            if memoryNote.time != nil{
                                Text(memoryNote.time, style: .date)
                                    .foregroundColor(.gray)
                                    .font(.caption2)
                            }
                        }//:hstakc
                        
                        Text(memoryNote.contentsText)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .foregroundColor(.gray)
                        HStack {
                            Image(systemName: "mappin")
                            Text(memoryNote.address)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                        .foregroundColor(.cyan)
                        .padding(.top,20)
                    }
                    .frame(minWidth:150)
                }
            }
        }//:Lazyvstack
        .padding()
        .background(.white)
        .cornerRadius(10)
        .clipped()
        .shadow(color: .gray, radius: 5, x: 0, y: 0)
    }
}

struct DestinationCardView_Previews: PreviewProvider {
    @State static var prevNote: MemoryNote = testMemoryNoteData[3]
    static var previews: some View {
        NavigationView {
            DestinationCardView(memoryNote: $prevNote)
        }
    }
}

//
//  InsetGalleryView.swift
//  
//
//  Created by 中出翔也 on 2022/01/06.
//

import SwiftUI
import Model
import Data

public struct InsetGalleryView: View {
    
    public var memoryNote : MemoryNote
    public init(memoryNote: MemoryNote){
        self.memoryNote = memoryNote
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .center, spacing: 10) {
                if memoryNote.imageData.count != 0 {
                    ForEach(memoryNote.imageData , id: \.self) { imageData in
                        Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")! )
                            .resizable()
                            .scaledToFit()
                            .frame(height:200)
                            .cornerRadius(12)
                    }
                } else {
                    VStack(alignment: .center, spacing: 5) {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height:200)
                            .cornerRadius(12)
                            .foregroundColor(.gray)
                        Text("画像がありません")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            
            }//: Hstack
        } //:Scroll
    }
}

struct InsetGalleryView_Previews: PreviewProvider {
    
    static let memoryNote: MemoryNote = testMemoryNoteData[0]
    static var previews: some View {
        InsetGalleryView(memoryNote: memoryNote)
//            .previewLayout(.sizeThatFits)
            .padding()
    }
}



//
//  InsetGalleryColumn1View.swift
//  
//
//  Created by 中出翔也 on 2022/01/19.
//

import SwiftUI
import Model
import Data

struct InsetGalleryColumn1View: View {
    public var memoryNote : MemoryNote
    public init(memoryNote: MemoryNote){
    self.memoryNote = memoryNote
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 15) {
            if memoryNote.imageData.count != 0 {
                ForEach(memoryNote.imageData , id: \.self) { imageData in
                    Image(uiImage: UIImage(data:imageData)!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding(5)
                }
            } else {
                VStack(alignment: .center, spacing: 5) {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding(5)
                        .foregroundColor(.gray)
                    Text("画像がありません")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct InsetGalleryColumn1View_Previews: PreviewProvider {
    static let memoryNote: MemoryNote = testMemoryNoteData[0]
    static var previews: some View {
        InsetGalleryColumn1View(memoryNote: memoryNote)
    }
}

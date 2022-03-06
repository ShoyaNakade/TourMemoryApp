//
//  ShowCategoryView.swift
//  
//
//  Created by 中出翔也 on 2022/01/09.
//

import SwiftUI
import Model

public struct ShowCategoryView: View {
    //MARK: - PROPERTY
    public var heightSize : CGFloat = 20
    public var memoryNote: MemoryNote
    
    public init(heightSize : CGFloat , memoryNote : MemoryNote){
        self.heightSize = heightSize
        self.memoryNote = memoryNote
    }

    //MARK: - BODY
    public var body: some View {
        VStack{
            HStack(spacing:10) {
                ForEach(Category.allCases, id: \.self) { category in
                    if memoryNote.categories.contains(category) {
                        Image(systemName:category.toImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: heightSize , alignment: .center)
                    }
                }
                if memoryNote.categories.count == 0 {
                    Text("分類されていません")
                        .font(.caption)
                }
            }
//            .padding()
        }// :VSTACK
    }
}


struct ShowCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ShowCategoryView(heightSize: 20, memoryNote: MemoryNote.placeholder )
    }
}

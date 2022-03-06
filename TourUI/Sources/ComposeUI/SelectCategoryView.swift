//
//  SelectCategoryView.swift
//  
//
//  Created by 中出翔也 on 2022/01/09.
//

import SwiftUI
import Model

struct SelectCategoryView: View {
    //MARK: - PROPERTY
    @Binding public var memoryNote: MemoryNote

    
    public init(memoryNote : Binding<MemoryNote>){
        self._memoryNote = memoryNote
    }
    
    //MARK: - BODY
    var body: some View {
        ScrollView(.horizontal) {
            HStack() {
                ForEach(Category.allCases, id: \.self) { category in
                    Button {
                        if memoryNote.categories.contains(category) {
                            memoryNote.categories.remove(category)
                        } else {
                            memoryNote.categories.insert(category)
                        }
                    } label: {
                        VStack {
                            if memoryNote.categories.contains(category) {
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
        }//:scrollview
        
    }
}


struct SelectCategoryView_Previews: PreviewProvider {
    @State static var memoryNote: MemoryNote = MemoryNote.placeholder
    static var previews: some View {
        SelectCategoryView(memoryNote: $memoryNote)
            .previewLayout(.sizeThatFits)
    }
}

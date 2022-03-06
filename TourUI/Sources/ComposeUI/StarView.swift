//
//  StarView.swift
//  
//
//  Created by 中出翔也 on 2022/01/10.
//

import SwiftUI

public struct StarView: View {
    //MARK: - PROPERTY
    @Binding var starNum : Int16
    private var isChanged : Bool  //変更可能かどうか。
    private var starHeight: CGFloat
    
    public init(starNum: Binding<Int16> , isChanged: Bool, starHeight: CGFloat){
        self._starNum = starNum
        self.isChanged = isChanged
        self.starHeight = starHeight
    }
    
    //MARK: - Body
    public var body: some View {
        HStack{
            ForEach(1 ..< 5) { index in
                if isChanged {
                    Button {
                        starNum = Int16(index)
                    } label: {
                        Image(systemName: starNum >= index ? "star.fill" : "star")
                            .resizable()
                            .scaledToFit()
                            .frame(height: self.starHeight)
                            .foregroundColor(.yellow)
                }
                } else {
                    Image(systemName: starNum >= index ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(height: self.starHeight)
                        .foregroundColor(.yellow)
                }
            }//:roop
        }//:hstack
    }
}

struct StarView_Previews: PreviewProvider {
    @State  static var num : Int16 = 1
    static var previews: some View {
        StarView(starNum: $num, isChanged: true, starHeight: 25)
    }
}

//
//  AnnotationItemView.swift
//  
//
//  Created by 中出翔也 on 2022/01/22.
//

import SwiftUI
import Model
import Data

public struct AnnotationItemView: View {
    private var noteType: NoteType
    private let image: UIImage
    private var frameSize: CGFloat = 100
    private let linearRed: LinearGradient = LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
    private let linearBlue: LinearGradient = LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom)
    
    @State private var opacity: Double = 1
    @Binding private var ratio: Int16
    
    public init(noteType: NoteType, image: UIImage ,framesize: CGFloat, ratio:Binding<Int16>){
        self.noteType = noteType
        self.frameSize = framesize
        self.image = image
        self._ratio = ratio
    }
    
    public var body: some View {
        ZStack {
            Circle() //内枠
                .fill(Color.white)
                .frame(width: frameSize + 5   , height: frameSize + 5 , alignment: .center)
                .zIndex(2)
            if self.noteType == .memory {
                Circle()
                    .fill(linearBlue)
                    .frame(width: frameSize + 10 , height: frameSize + 10, alignment: .center)
                    .zIndex(1)
            } else {
                Circle()
                    .fill(linearRed)
                    .frame(width: frameSize + 10   , height: frameSize + 10 , alignment: .center)
                    .zIndex(1)
            }
            Circle() //外枠
                .fill(Color.white)
                .frame(width: frameSize + 15   , height: frameSize + 15 , alignment: .center)
                .zIndex(-1)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(minWidth: frameSize, idealWidth: frameSize, maxWidth: frameSize, minHeight: frameSize, idealHeight: frameSize, maxHeight: frameSize)
                .zIndex(10)
//                .opacity(self.opacity)
//                .animation(Animation.easeInOut(duration: 1).repeatForever(), value: self.opacity)
//                 .onAppear {
//                     self.opacity = 1.0
//                 }
//                 // ビューが非表示になった時の処理
//                 .onDisappear {
//                     self.opacity = 0.0
//                 }

            StarView(starNum: $ratio, isChanged: false, starHeight: 10)
                .padding(3)
                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.8))
                .cornerRadius(5)
                .offset(x: 0, y: -frameSize/2)
                .zIndex(20)
//                .opacity(self.opacity)
                
        }        
    }
}

struct AnnotationItemView_Previews: PreviewProvider {
    @State static var notetype = NoteType.memory
    @State static var ratio:Int16 = 3
    static var image = UIImage(data: testMemoryNoteData[0].imageData.first!)
    static var previews: some View {
        AnnotationItemView(noteType: notetype, image: image!, framesize: 100, ratio: $ratio)
            .background(.black)
    }
}

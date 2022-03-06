//
//  AnimationPinView.swift
//  
//
//  Created by 中出翔也 on 2022/01/23.
//

import SwiftUI

public struct AnimationPinView: View {
    @State private var animatePin: Bool
    private var pinHeight:CGFloat = 40
    
    public init(){
        animatePin = false
    }
    
    public var body: some View {
            Image(systemName: "mappin")
                .resizable()
                .scaledToFit()
                .frame(height: pinHeight)
                .foregroundColor(.red)
                .offset(y: animatePin ? -pinHeight/2 : -pinHeight/2 + 5 )
//                .opacity(self.animatePin ? 1 : 0.8)
//                .scaleEffect(self.animatePin ? 1 : 1, anchor: .center)
                .animation(Animation.easeInOut(duration: 1.3).repeatForever(), value: self.animatePin)
                .onAppear() {
                    self.animatePin.toggle()
                }
    }
}

struct AnimationPinView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnimationPinView()
                .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}

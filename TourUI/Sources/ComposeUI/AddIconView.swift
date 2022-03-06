//
//  AddIconView.swift
//  
//
//  Created by 中出翔也 on 2022/01/23.
//

import SwiftUI

public struct AddIconView: View {
    @State private var pulsate: Bool = true
    public init(){
        
    }
    public var body: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .font(.largeTitle)
                .frame(width: 50, height: 50)
                .foregroundStyle(.red,.white,.white)
                .shadow(radius: 4)
//                .opacity(self.pulsate ? 1 : 0.8)
                .scaleEffect(self.pulsate ? 1.0 : 0.8)
                .animation(Animation.easeInOut(duration: 1.3).repeatForever(), value: self.pulsate)
        }
//        .onAppear() {
//            self.pulsate.toggle()
//        }
    }
}

struct AddIconView_Previews: PreviewProvider {
    static var previews: some View {
        AddIconView()
            .scaledToFit()
    }
}

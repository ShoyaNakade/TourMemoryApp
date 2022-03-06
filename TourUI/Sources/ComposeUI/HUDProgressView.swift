//
//  HUDProgressView.swift
//  旅マップ
//
//  Created by 中出翔也 on 2022/02/11.
//

import SwiftUI

public struct HUDProgressView: View {
    var placeHolder: String
        @State var animated = false
        
    public init(placeHolder:String) {
        self.placeHolder = placeHolder
//        self._isShow = isShow
    }
        public var body: some View {
            VStack(spacing: 28) {
                Circle()
                    .stroke(AngularGradient(gradient: .init(colors: [Color.primary, Color.primary.opacity(0)]), center: .center))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.init(degrees: animated ? 360: 0))
                
                Text(placeHolder)
                    .fontWeight(.bold)

            }
            .padding(.vertical, 25)
            .padding(.horizontal, 35)
            .background(BlurView())
            .cornerRadius(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.primary.opacity(0.35)
//                    .onTapGesture {
//                        withAnimation {
//                            isShow.toggle()
//                        }
//                    }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    animated.toggle()
                }
            }
        }
}

public struct HUDProgressView_Previews: PreviewProvider {
    @State static var show = true
    public static var previews: some View {
        HUDProgressView(placeHolder: "読み込み中")
    }
}

public struct BlurView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        return view
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

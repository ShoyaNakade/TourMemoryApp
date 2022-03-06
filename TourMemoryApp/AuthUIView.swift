//
//  AuthUI.swift
//  旅マップ
//
//  Created by 中出翔也 on 2022/02/12.
//
import SwiftUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import Foundation
import CryptoKit
import FirebaseCore
import GoogleSignIn
import Model
//import FirebaseFacebookAuthUI
//import FirebasePhoneAuthUI
struct AuthUIView: UIViewControllerRepresentable {
//    @Binding var isShowSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var myMemory: MyMemory
    
    class Coordinator: NSObject,
        FUIAuthDelegate {
            // AuthUIView型の変数を用意
            let parent: AuthUIView
            
            // イニシャライザ
            init(_ parent: AuthUIView) {
                self.parent = parent
                self.parent.StartChangeForIDListener()
        }
        
        // MARK: - FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
            // handle user and error as necessary
            if let error = error {
                // サインイン失敗
                print("Auth NG:\(error.localizedDescription)")
            }
            if let _ = user {
                // サインイン成功
            }
            // Sheet（ModalView）を閉じる
//            parent.isShowSheet = false
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスを作成
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = context.coordinator
        let provider = FUIOAuth.appleAuthProvider()
        // サポートするログイン方法を構成
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(authUI: authUI),
            //            FUIFacebookAuth(authUI: authUI),
            //            FUIOAuth.twitterAuthProvider(),
            //            FUIPhoneAuth(authUI:authUI),
            provider,
        ]
        authUI.providers = providers
        // FirebaseUIを表示する
        
        let authViewController = authUI.authViewController()
        
        //google

        return authViewController
    }
    
    func StartChangeForIDListener () {
        var handle = Auth.auth().addStateDidChangeListener { auth, user in //変更時に以下の処理が行われる。
            if Auth.auth().currentUser != nil {
              // User is signed in.
                let user = Auth.auth().currentUser
                if let user = user {
                  // The user's ID, unique to the Firebase project.
                  // Do NOT use this value to authenticate with your backend server,
                  // if you have one. Use getTokenWithCompletion:completion: instead.
                  let uid = user.uid
        
                  let email = user.email
                  let photoURL = user.photoURL
                  var multiFactorString = "MultiFactor: "
                  for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                  }
                    print("multi \(multiFactorString)")
                    print("user info: \(user.uid), \(user.email)")
                    
                    myMemory.delegate?.LoginIsId() //userdefaults
                    myMemory.delegate?.SetUserId(id: uid) //userdefaults
                    myMemory.delegate?.SetEmail(email: email ?? "") //userdefaults
                    myMemory.isID = true
                    myMemory.email = email ?? ""
                  // ...
                }
            } else {
              // No user is signed in.
              // ...
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
}



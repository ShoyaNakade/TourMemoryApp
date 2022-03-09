//
//  TourMapView.swift
//  
//
//  Created by 中出翔也 on 2022/01/05.
//

import SwiftUI
import MapKit
import Model
import ComposeUI
import Data
import Helper

public struct TourMapView: View {
    //MARK: - PROPERTY
    @EnvironmentObject var myMemory: MyMemory
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focus: Bool //keyboard
    @State var coordinateRegion: MKCoordinateRegion
    @State var GPSlocation: CLLocationManager = CLLocationManager()
    @State private var memoryNote: MemoryNote
    @State private var address: String  = ""
    @State private var editting: Bool = false
    @State private var isModalActive: Bool = false
    @State private var showType: ShowType = .all
    @State private var gpsNote:Bool = false
    @State private var animateShowType: Bool = false
    @State private var opacityShowType: Double = 1
    private let altImageData = UIImage(systemName: "photo")!.jpegData(compressionQuality: 1)
    
    private let impactMed = UIImpactFeedbackGenerator(style: .medium)
    public init() {
        _memoryNote = State(initialValue: MemoryNote.placeholder)
        
//        _coordinateRegion = State(initialValue:MKCoordinateRegion(center: CLLocationCoordinate2D(
//                            latitude: 35.989506,longitude: 139.691700),
//                            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))) //東京
        _coordinateRegion = State(initialValue:MKCoordinateRegion(center: CLLocationCoordinate2D(
                            latitude: 34.985398, longitude: 135.758449),
                            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))) //京都駅
        // ユーザーの使用許可を確認
        GPSlocation.requestWhenInUseAuthorization()
        GPSlocation.startUpdatingLocation()
        if GPSlocation.location != nil {
            _coordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(
                latitude: GPSlocation.location!.coordinate.latitude,
                longitude: GPSlocation.location!.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)))
        } else {
            gpsNote.toggle()
        }
    }
    
    
    //MARK: - BODY
    public var body: some View {
        NavigationView {
            ZStack(alignment:.topLeading) {
                VStack(spacing: 1) {
                    TextField("地名", text: $address,
                              onEditingChanged: { begin in
                        /// 入力開始処理
                        if begin {
                            self.editting = true    // 編集フラグをオン
                            self.focus = true
                            /// 入力終了処理
                        } else {
                            self.editting = false   // 編集フラグをオフ
                            self.focus = false
                        }
                    },
                    /// リターンキーが押された時の処理
                    onCommit: {
                        CLGeocoder().geocodeAddressString(address) { placemarks, error in
                            if let lat = placemarks?.first?.location?.coordinate.latitude {
                                coordinateRegion.center.latitude = lat
                            }
                            if let lng = placemarks?.first?.location?.coordinate.longitude {
                                coordinateRegion.center.longitude = lng
                            }
                        }
                    })
                        .focused(self.$focus)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
                        .padding(.top, 10) // 余白を追加
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        // 編集フラグがONの時に枠に影を付ける
                        .shadow(color: editting ? .blue : .clear, radius: 3)
                        .overlay(alignment: .trailing, content: {
                            // cancelbutton
                            if self.editting {
                                Button(action: {
                                    address = ""
                                    self.editting = false
                                    self.focus = false
                                }, label: {
                                    Image(systemName: "clear.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 40)
                                })
                                    .padding(.trailing,30)
                                    .padding(.top,10)
                            }
                        })

                    if myMemory.showLatLng {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("緯度: \(coordinateRegion.center.latitude)")
                                Text("経度: \(coordinateRegion.center.longitude)")
                            }
                            .foregroundColor(.black)
                            .padding()
                            Spacer()
                        }
                    }
                }
                .zIndex(2)
                
                Map(coordinateRegion: $coordinateRegion,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .none,
                    annotationItems: myMemory.notes) { annotation in
                    MapAnnotation(coordinate: annotation.getlocation()) {
                        if showType == ShowType.all ||
                            (showType == ShowType.memory && annotation.noteType == NoteType.memory) ||
                            (showType == ShowType.destination && annotation.noteType == NoteType.destination) {
                            NavigationLink {
                                if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == annotation.id}) {
                                    MemoryNoteView(memoryNote: $myMemory.notes[targetIndex])
                                        .environmentObject(myMemory) // for debgu
                                }
                            } label: {
                                if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == annotation.id}) {
                                    //viewの伝搬を即時に渡すため,annotationを使わない
                                    AnnotationItemView(
                                        noteType: myMemory.notes[targetIndex].noteType,
                                        image: UIImage(data:(myMemory.notes[targetIndex].imageData.first ?? altImageData)!) ?? UIImage(systemName: "photo")!,
                                        framesize: 70,
                                        ratio: $myMemory.notes[targetIndex].ratio)
                                }
                            }
                        }
                    }
                } //map
                .overlay(alignment: .center) {
                    AnimationPinView()
                }
                
                VStack {
                    Spacer()
                    HStack(alignment: .bottom){
                        // gps button
                        Button(action:{
                            // ユーザーの使用許可を確認
                            GPSlocation.requestWhenInUseAuthorization()
                            GPSlocation.startUpdatingLocation()
                            if GPSlocation.location != nil {
                                coordinateRegion.center.longitude = GPSlocation.location!.coordinate.longitude
                                coordinateRegion.center.latitude = GPSlocation.location!.coordinate.latitude
                            } else {
                                print("can't get your location")
                                gpsNote.toggle()
                            }
                            
                        }){
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.blue,.white,.white)
                                .shadow(radius: 20)
                        }
                        
                        Spacer()
                        
                        // + button
                        Button {
                            // change geo
                            reverseGeoCording(lat: coordinateRegion.center.latitude, long: coordinateRegion.center.longitude) { address in
                                self.memoryNote = MemoryNote.placeholderDestination //初期化
                                self.memoryNote.coordinate.latitude = coordinateRegion.center.latitude
                                self.memoryNote.coordinate.longitude = coordinateRegion.center.longitude
                                self.address = address
                                self.memoryNote.address = "\(self.address)"
                                isModalActive.toggle()
                            }
                        } label: {
                            AddIconView()
                        }
                        .sheet(isPresented: $isModalActive) {
                            AddMemoryNoteView(memoryNote: memoryNote)
                        }
                    }
                }
                .padding()
            }
//            .ignoresSafeArea(.all)
            .navigationBarTitle(showType.toString() ,displayMode: .inline)
            .navigationBarItems(leading: NavigationLink(destination: {
                SettingView()
            }, label: {
                Image(systemName: "gearshape")
            }))
            .navigationBarItems(trailing:
                Button(action:{
                    if showType == .all {
                        showType = .memory
                    } else if showType == .memory {
                        showType = .destination
    
                    } else if showType == .destination {
                        showType = .noall
                    }
                    else if showType == .noall {
                        showType = .all
                    }
                    impactMed.impactOccurred()
                }) {
                    VStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("表示タイプ変更")
                            .font(.caption2)
                    }
                    .frame(width: 70,alignment: .center)
            })
        }//:zstack
        .alert("GPS機能がオフになっています。", isPresented: $gpsNote){
            Button("確認しました") {
            }
        } message: {
            Text("設定から、アプリの位置情報サービスの許可をONにしてください。")
        }
    }
}

struct TourMapView_Previews: PreviewProvider {
    static var myMemory = MyMemory(notes: testMemoryNoteData)
    static var previews: some View {
        TabView {
                TourMapView()
                    .environmentObject(myMemory)
        }
    }
}

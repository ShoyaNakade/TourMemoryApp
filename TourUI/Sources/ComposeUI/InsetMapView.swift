//
//  InsetMapView.swift
//
//
//  Created by 中出翔也 on 2021/12/31.
//

import SwiftUI
import MapKit
import Model
import Data
//import Promises

struct InsetMapView: View {
    @EnvironmentObject var myMemory: MyMemory
    @State public var region: MKCoordinateRegion
    @State public var center: CLLocationCoordinate2D
    @Binding public var lat: Double
    @Binding public var lng: Double
    private var altImage:Data = UIImage(systemName: "photo")!.jpegData(compressionQuality: 0.01)!
    
    public init(center: CLLocationCoordinate2D , lat:Binding<Double>, lng: Binding<Double>) {
        _center = State(initialValue: center)
        _region = State(initialValue: MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)))
        self._lat = lat
        self._lng = lng
    }
    
    //MARK: - FUNCTION
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
    }
    
    var body: some View {
        HStack{
            Spacer()
            if (center.latitude != lat) || (center.longitude != lng) {
                Button {
                    setRegion(coordinate: center)
                } label: {
                    Text("マップ表示を更新")
                }
            }
        }
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .none,
            annotationItems: myMemory.notes) { annotation in
            MapAnnotation(coordinate: annotation.getlocation()) {
                if self.center.latitude == annotation.coordinate.latitude && self.center.longitude == annotation.coordinate.longitude {
                    AnimationPinView()
                } else{
                    if let targetIndex = myMemory.notes.firstIndex(where: {$0.id == annotation.id}) {
                        //viewの伝搬を即時に渡すため,annotationを使わない
                        AnnotationItemView(
                            noteType: myMemory.notes[targetIndex].noteType,
                            image: UIImage(data:myMemory.notes[targetIndex].imageData.first ?? altImage) ?? UIImage(systemName: "photo")!,
                            framesize: 70,
                            ratio: $myMemory.notes[targetIndex].ratio)
                    }
                }
            }
        }//map
        .frame(height:300)
        .cornerRadius(12)
    }
}

struct InsetMapView_Previews: PreviewProvider {
    @State static var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 2, longitude: 3), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    @State static var lng:Double = 23
    @State static var lat:Double = 23
    
    static var previews: some View {
        VStack {
            InsetMapView(center: CLLocationCoordinate2D(latitude: testMemoryNoteData.first?.coordinate.latitude ?? 0, longitude: testMemoryNoteData.first?.coordinate.longitude ?? 0), lat:$lat, lng:$lng)
                .previewLayout(.sizeThatFits)
                .padding()
//                .environmentObject(MyMemory(notes:testMemoryNoteData, myAnnotations: testAnnotations))
                .environmentObject(MyMemory(notes:testMemoryNoteData))
        }
    }
}

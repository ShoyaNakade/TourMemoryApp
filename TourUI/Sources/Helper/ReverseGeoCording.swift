//
//  ReverseGeoCording.swift
//  
//
//  Created by 中出翔也 on 2022/01/16.
//

import Foundation
import CoreLocation

public func reverseGeoCording(lat: Double,long: Double, completion: @escaping (String) -> Void ) {
    let location = CLLocation(latitude: lat, longitude: long)
    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
        if let placemarks = placemarks {
            if let pm = placemarks.first {
                //位置情報
                let administrativeArea = pm.administrativeArea == nil ? "" : pm.administrativeArea!
                let locality = pm.locality == nil ? "" : pm.locality!
                let subLocality = pm.subLocality == nil ? "" : pm.subLocality!
                let thoroughfare = pm.thoroughfare == nil ? "" : pm.thoroughfare!
                let subThoroughfare = pm.subThoroughfare == nil ? "" : pm.subThoroughfare!
                let placeName = !thoroughfare.contains( subLocality ) ? subLocality : thoroughfare

                //住所
                let address = administrativeArea + locality + placeName + subThoroughfare
                completion(address) //ハンドラー実行
                
            }else{
                completion("")
            }
            
        } else{
            completion("")
        }
    }
}

//
//  UIImage+Extension.swift
//  
//
//  Created by 中出翔也 on 2022/01/19.
//

import Foundation
import SwiftUI

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

//
//  Binding+Extension.swift
//  Todo
//
//  Created by 中出翔也 on 2021/12/08.
//

import SwiftUI

public extension Binding{
    
    init<T> (isNotNil source:Binding<T?>, defaultValue: T) where Value == Bool{
        self.init(get: { source.wrappedValue != nil}, //bindigの値を取得 nilであればfalseを返す
                  set: { source.wrappedValue = $0 ? defaultValue : nil })
    }
    
    init(_ source:Binding<Value?>, _ defaultValue: Value){
        self.init(get:{
        if source.wrappedValue == nil{
             source.wrappedValue = defaultValue
             }
             return source.wrappedValue ?? defaultValue
             // nilではないとき左を、nilの時は ?? の右側を返す
            
        },set:{
            source.wrappedValue = $0
        })
    }
}

//
//  TestMemoryNoteData.swift
//  
//
//  Created by 中出翔也 on 2022/01/06.
//

import Foundation
import Model
import SwiftUI
import Extension
import Helper

public var testMemoryNoteData : [MemoryNote] = [
    MemoryNote(id: "1",
               title: "金閣寺に行ってきた",
               address: "金閣寺",
               time: Date.now - 1, ratio: 3,
               noteType: .memory,
               contentsText: "金閣寺に行ってきました。輝かしい建造物で感動した！また行ってみたい",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8MUT2LKeaXrl0bCYi4Xt-ZrhjXL33RLwRrQ&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFv4KFBJV3zoOlQXn9PkCfSUXeEEWvbAo8pg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8MUT2LKeaXrl0bCYi4Xt-ZrhjXL33RLwRrQ&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFv4KFBJV3zoOlQXn9PkCfSUXeEEWvbAo8pg&usqp=CAU")
//                ],
               categories: [.cafe, .attraction , .couple],
               coordinate: Coordinate(latitude: 35.038798,longitude: 135.729185)
              ),
    MemoryNote(id: "2",
               title: "銀閣寺",
               address: "銀閣寺",
               time: Date.now - 40,
               ratio: 3,
               noteType: .memory,
               contentsText: "銀閣寺に行ってきた。金閣寺から意外と遠くて疲れた。",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE09kHbJUrLpSIsaH_lNS8NpQaVoU8dGKLRg&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmIionDMA_Id7I72VgtrWQ9UzxcGcBvRokoA&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE09kHbJUrLpSIsaH_lNS8NpQaVoU8dGKLRg&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmIionDMA_Id7I72VgtrWQ9UzxcGcBvRokoA&usqp=CAU")
//                ],
               categories: [],
               coordinate: Coordinate( latitude: 35.027639, longitude: 135.796044)
               ),
    MemoryNote(id: "3",
               title: "平等院",
               address: "十京都府宇治市宇治蓮華117",
               time: Date.now - 50,
               ratio: 3,
               noteType: .destination,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDRODlS55lLk30qkPVFCWmfQn_VV7TJ-rjbA&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiTw7juGIIlThUvdJESFhnXJVwol-NspoOjA&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDRODlS55lLk30qkPVFCWmfQn_VV7TJ-rjbA&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiTw7juGIIlThUvdJESFhnXJVwol-NspoOjA&usqp=CAU")
//                ],
               categories: [.cafe, .attraction],
               coordinate: Coordinate(latitude: 34.889368,longitude: 135.807710)
               ),
    MemoryNote(id: "5",
               title: "Ocaffe Kyto",
               address: "京都府京都市下京区神明町235-3",
               time: Date.now - 55,
               ratio: 3,
               noteType: .memory,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU")
//                ],
               categories: [.cafe],
               coordinate: Coordinate(latitude: 35.002502,longitude: 135.762123)
               ),
    MemoryNote(id: "6",
               title: "宮古島 17エンドビーチ",
               address: "沖縄県宮古島市伊良部佐和田",
               time: Date.now - 160,
               ratio: 4,
               noteType: .memory,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8xzAsRTsl6vh0eZJrO_0MHAN2uFOeB_1-vA&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSR8a5DTJBPjZ4Mxo8Z1NIiyOHgzd6UPgwMXg&usqp=CAU")
//                ],
               categories: [.cafe],
               coordinate: Coordinate( latitude: 24.834852, longitude: 125.135532)
               ),
    MemoryNote(id: "7",
               title: "渡口の浜",
               address: "宮古島伊良部1391-1",
               time: Date.now - 160,
               ratio: 3,
               noteType: .memory,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmnBdWenFdvnDQ4mGMHmUJQu-RVD_ePHU7UQ&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4miiVH4_hTL_DzcLAvXnkYeSi-UCS9csxgg&usqp=CAU")
//                ],
               categories: [.cafe],
               coordinate: Coordinate(latitude: 24.811884,longitude: 125.178253)
               ),
    MemoryNote(id: "8",
               title: "行きたいところは石川県",
               address: "石川県金沢市金沢駅",
               time: Date.now - 160,
               ratio: 2,
               noteType: .destination,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9xShMUie4UpkICCdhPJArR-5rw-qLQkhcbQ&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdbDKHVtWWmGkAjp1DxfEpk7-X5qxUJcP4sg&usqp=CAU")
//                ],
               categories: [.cafe],
               coordinate: Coordinate(latitude: 36.561055, longitude: 136.656513)
               ),
    MemoryNote(id: "9",
               title: "清水寺",
               address: "京都府清水寺",
               time: Date.now - 90,
               ratio: 4,
               noteType: .destination,
               contentsText: "ここにテキストが入ります。テキストテキスト",
               imageData: [
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSHzSb6-tWoBPUEdIhF2oKal7Er4vQuo-U6A&usqp=CAU").jpegData(compressionQuality: 1)!,
                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJFWPiYpv4PU52Iq8UaXkpZ7AF5Px2WM7pbg&usqp=CAU").jpegData(compressionQuality: 1)!
               ],
//               images: [
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxK2_L8OvWpyaj5R6ZHz0vGDFQiv9poA8o1g&usqp=CAU"),
//                UIImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhb84tf1NIc_IfHYyYhhdtETGcYtiwZiRA8A&usqp=CAU")
//                ],
               categories: [.cafe,.attraction,.solo],
               coordinate: Coordinate(latitude: 34.994930, longitude: 135.785104)
               ),
]


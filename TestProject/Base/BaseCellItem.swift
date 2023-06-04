//
//  BaseCellItem.swift
//  TestProject
//
//  Created by 김동우 on 2023/06/04.
//

import Foundation

class BaseCellItem: Hashable {
    var id: String = ""
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: BaseCellItem,
                    rhs: BaseCellItem) -> Bool {
        lhs.id == rhs.id
    }
}

//
//  Items.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//

import UIKit

class CheckListItem {
    var itemName: String
    var isChecked: Bool
    
    init(itemName: String, isChecked: Bool) {
        self.itemName = itemName
        self.isChecked = isChecked
    }
}

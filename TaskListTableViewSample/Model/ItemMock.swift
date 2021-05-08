//
//  ItemMock.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/08.
//

import Foundation

enum CheckListItemMock {
    static let one = CheckListItem(itemName: "One", isChecked: false)
    static let two = CheckListItem(itemName: "Two", isChecked: false)
    static let three = CheckListItem(itemName: "Three", isChecked: false)
    static let four = CheckListItem(itemName: "Four", isChecked: false)
    static let five = CheckListItem(itemName: "Five", isChecked: false)
    
    static let array: [CheckListItem] = [one, two, three, four, five]
}

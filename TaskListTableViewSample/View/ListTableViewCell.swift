//
//  ListTableViewCell.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    // 引数のcellでtagなどを引っ張ってこられる
    func toggleCheckButton(cell: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    weak var delegate: ListTableViewCellDelegate?
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func tapCheckButton(_ sender: UIButton) {
        self.delegate?.toggleCheckButton(cell: self)
        
    }
    
    
}

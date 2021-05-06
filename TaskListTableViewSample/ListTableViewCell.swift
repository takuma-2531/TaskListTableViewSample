//
//  ListTableViewCell.swift
//  TaskListTableViewSample
//
//  Created by 小川卓馬 on 2021/05/06.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    static var identifier: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
    }
    
    
}

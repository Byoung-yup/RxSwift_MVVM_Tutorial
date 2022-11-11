//
//  UserTableViewCell.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/10.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

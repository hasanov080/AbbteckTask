//
//  FilterCVCell.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import UIKit

class FilterCVCell: UICollectionViewCell {
    
    @IBOutlet weak var chevronPosition: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func setup(isOpen: Bool = false, titleName: String?, hasDropDown: Bool, isSelected: Bool = true){
        contentView.alpha = (isSelected == true ? 1 : 0.5)
        chevronPosition.isHighlighted = isOpen
        chevronPosition.isHidden = !hasDropDown
        titleLabel.text = titleName
    }
}

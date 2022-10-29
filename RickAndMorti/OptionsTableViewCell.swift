//
//  OptionsTableViewCell.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 29.10.22.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    lazy var optionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.text = "Hello"
        view.font = UIFont.systemFont(ofSize: 17)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(optionLabel)
        contentView.backgroundColor = .systemGray2
        NSLayoutConstraint.activate([
            optionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            optionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            optionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            optionLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setup(text: String?){
        optionLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

}

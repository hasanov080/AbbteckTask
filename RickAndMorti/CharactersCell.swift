//
//  CharactersCell.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import UIKit

class CharactersCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var characterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(character: Characters?){
        
        characterImage.sd_setImage(with: URL(string: character?.image ?? ""))
        nameLabel.text = "\(character?.name ?? "-")"
        genderLabel.text = "Gender: \(character?.gender ?? "-")"
        speciesLabel.text = "Species: \(character?.species ?? "-")"
        statusLabel.text = "Status: \(character?.status ?? "-")"
    }
}

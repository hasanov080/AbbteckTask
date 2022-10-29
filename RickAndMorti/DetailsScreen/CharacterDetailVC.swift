//
//  CharacterDetailVC.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 29.10.22.
//

import UIKit

class CharacterDetailVC: BaseVC {

    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var chracterName: UILabel!
    
    @IBOutlet weak var characterGender: UILabel!
    
    @IBOutlet weak var characterStatus: UILabel!
    
    @IBOutlet weak var characterSpecies: UILabel!
    
    @IBOutlet weak var characterOrigin: UILabel!
    
    
    @IBOutlet weak var characterType: UILabel!
    
    var character: Characters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        characterImage.sd_setImage(with: URL(string: character?.image ?? ""))
        chracterName.text = "Name: \(character?.name ?? "-")"
        characterGender.text = "Gender: \(character?.gender ?? "-")"
        characterStatus.text = "Status: \(character?.status ?? "-")"
        characterSpecies.text = "Species: \(character?.species ?? "-")"
        characterOrigin.text = "Origin: \(character?.origin?.name ?? "-")"
        characterType.text = "Type: \(character?.type ?? "-")"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

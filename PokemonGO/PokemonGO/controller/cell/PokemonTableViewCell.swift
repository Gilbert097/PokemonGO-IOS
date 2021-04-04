//
//  PokemonTableViewCell.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 03/04/21.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var namePokemonLabel: UILabel!
    @IBOutlet weak var quantityPokemonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

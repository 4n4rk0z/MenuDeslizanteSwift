//
//  FavoritosTableViewCell.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 21/11/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//


import UIKit

class FavoritosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewFavoritos:UIImageView!
    
    @IBOutlet weak var labelTiempo: UILabel!
    
    @IBOutlet weak var labelNivel: UILabel!
    
    @IBOutlet weak var labelPorciones: UILabel!
    
    @IBOutlet weak var labelNombre: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}
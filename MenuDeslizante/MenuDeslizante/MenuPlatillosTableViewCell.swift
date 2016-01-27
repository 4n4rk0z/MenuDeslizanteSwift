//
//  MenuPlatillosTableViewCell.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 26/01/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import Foundation
class MenuPlatillosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagenRecetaView: UIImageView!
    @IBOutlet weak var nombreRecetaLabel: UILabel!
    @IBOutlet weak var nivelRecetaLabel: UILabel!
    @IBOutlet weak var porcionesRecetaLabel: UILabel!
    @IBOutlet weak var tiempoRecetaLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    
    
}

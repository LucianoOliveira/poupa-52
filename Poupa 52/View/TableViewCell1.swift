//
//  TableViewCell1.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 27/04/2018.
//  Copyright © 2018 Luciano Oliveira. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var semanaText: UILabel!
    @IBOutlet weak var valueText: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var valueSemana: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if statusText.text == "Poupado" {
            //Vamos apagar
            CRUD().retiraPouparSemana(week: Int(valueSemana.text!)!)
            statusText.text = "Não Poupado"
            buttonOutlet.setTitle("Poupar", for: .normal)
            imageCell.backgroundColor = UIColor(red: 0, green: 128/255, blue: 255/255, alpha: 1)
            
        }else{
            //Vamos poupar
            CRUD().poupaSemana(week: Int(valueSemana.text!)!)
            statusText.text = "Poupado"
            buttonOutlet.setTitle("Apagar", for: .normal)
            imageCell.backgroundColor = UIColor(red: 144/255, green: 190/255, blue: 173/255, alpha: 1)
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
}

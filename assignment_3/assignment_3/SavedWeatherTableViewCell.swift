//
//  SavedWeatherTableViewCell.swift
//  assignment_3
//
//  Created by Newman Law on 2022-03-20.
//

import UIKit

class SavedWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var lblWindInfo: UILabel!
    @IBOutlet weak var lblCity_Time: UILabel!
    @IBOutlet weak var lblSavedTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

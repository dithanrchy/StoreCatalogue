//
//  StoreListTableViewCell.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 06/01/23.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeRadius: UILabel!
    @IBOutlet weak var stackPerfectStore: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(storeName: String, storeRadius: Double?, isVisited: Bool) {
        self.storeName.text = storeName
        stackPerfectStore.isHidden = !isVisited

        guard let storeRadius = storeRadius else {
            self.storeRadius.text = ""
            return
        }
        self.storeRadius.text = "\(Int(storeRadius)) m"
    }
}

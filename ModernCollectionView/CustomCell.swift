//
//  CustomCell.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 18.11.2023.
//

import UIKit

final class CustomCell: UICollectionViewCell {

    var number: String {
        get {
            self.label?.text ?? "0"
        }
        set {
            self.label?.text = newValue
        }
    }

    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

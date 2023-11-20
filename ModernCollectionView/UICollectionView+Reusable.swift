//
//  UICollectionView+Reusable.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 20.11.2023.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(type: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeueCell<T: UICollectionViewCell>(of type: T.Type, for indexPath: IndexPath) -> T? {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}

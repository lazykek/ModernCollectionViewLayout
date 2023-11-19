//
//  SecondViewController.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 19.11.2023.
//

import UIKit

final class SecondViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var items: [String] = {
        (0...6).map { String($0) }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(
            UINib(nibName: "CustomCell", bundle: nil),
            forCellWithReuseIdentifier: "CustomCell"
        )
    }

    @IBAction private func remove() {
        self.items.remove(at: 0)
        self.collectionView.deleteItems(at: [IndexPath(row: 0, section: 0)])
    }
}

extension SecondViewController: UICollectionViewDelegate {

}

extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomCell",
            for: indexPath
        ) as? CustomCell
        cell?.number = items[indexPath.row]
        return cell ?? UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.items.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

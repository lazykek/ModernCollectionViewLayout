//
//  SecondViewController.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 19.11.2023.
//

import UIKit

private enum Section {
    case main
}

private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>

final class SecondViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var removeButton: UIButton!

    private var dataSource: DataSource?
    private lazy var items: [String] = {
        (0...6).map { String($0) }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self.makeDataSource()
        self.collectionView.dataSource = self.dataSource
        self.collectionView.decelerationRate = .fast

        let layout = HorizontalSnapCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(
            UINib(nibName: "CustomCell", bundle: nil),
            forCellWithReuseIdentifier: "CustomCell"
        )

        self.applySnapshot()
    }

    @IBAction private func remove() {
        self.removeButton.isEnabled = false
        self.items.removeFirst()
        self.applySnapshot()
    }

    private func makeDataSource() -> DataSource {
        DataSource(
            collectionView: self.collectionView
        ) { collectionView, indexPath, number -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CustomCell",
                for: indexPath
            ) as? CustomCell
            cell?.number = number
            return cell
        }
    }

    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items)
        self.dataSource?.apply(
            snapshot,
            animatingDifferences: true,
            completion: { [weak self] in
                self?.removeButton.isEnabled = self?.items.count ?? 0 > 0
            }
        )
    }
}

extension SecondViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.removeButton.isEnabled = false
        self.items.remove(at: indexPath.item)
        self.applySnapshot()
    }
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let visibleSize = collectionView.frame.size
        let cellSize = CGSize(
            width: self.items.count > 1 ? visibleSize.width * 0.8 : visibleSize.width,
            height: visibleSize.height
        )
        (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = cellSize
        return cellSize
    }
}

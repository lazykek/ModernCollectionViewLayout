//
//  ViewController.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 18.11.2023.
//

import UIKit

private enum Section {
    case main
}

private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.isScrollEnabled = false
        self.collectionView.register(
            UINib(nibName: "CustomCell", bundle: nil),
            forCellWithReuseIdentifier: "CustomCell"
        )
        self.dataSource = self.makeDataSource()
        self.collectionView.dataSource = self.dataSource
        self.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.makeMainSection()
        }
        self.start()
    }

    private func start() {
        self.configureSnapshot(numbers: [1, 2, 3, 4, 5, 6])
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.delete(numbers: [2])
//            self.configureSnapshot(numbers: [1, 3, 4])
        }
    }

    private func makeMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let leadingInset = 8.0
        let trailingInset = 8.0
        group.contentInsets = .init(top: 0, leading: leadingInset, bottom: 0, trailing: trailingInset)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

    private func makeDataSource() -> DataSource {
        UICollectionViewDiffableDataSource<Section, String>(
            collectionView: self.collectionView
        ) { collectionView, indexPath, number -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell
            cell?.number = number
            return cell
        }
    }

    private func configureSnapshot(numbers: [Int]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(
            numbers.map { String($0) }
        )
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func delete(numbers: [Int]) {
        guard var snapshot = self.dataSource?.snapshot(for: .main) else {
            self.configureSnapshot(numbers: numbers)
            return
        }
        snapshot.delete(
            numbers.map { String($0) }
        )
        self.dataSource?.apply(
            snapshot,
            to: .main,
            animatingDifferences: false,
            completion: {

            }
        )
    }
}


//
//  HorizontalSnapCarouselView.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 20.11.2023.
//

import UIKit

typealias ItemNumber = Int

private enum Section {
    case main
}

final class HorizontalSnapCarouselView<Item: Hashable, Cell: UICollectionViewCell>: UIView {

    // MARK: - Internal and private vars

    var cellConfigurator: ((Cell, ItemNumber, Item) -> ())?
    var items: [Item] = [] {
        didSet {
            self.applySnapshot()
        }
    }

    // MARK: - Private vars

    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private var dataSource: DataSource?
    private let delegateProxy = HorizontalSnapCarouselFlowLayoutDelegateProxy()
    private let collectionView: UICollectionView = {
        let layout = HorizontalSnapCarouselFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        return collectionView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCollectionView()
    }

    // MARK: - Private methods

    private func configureCollectionView() {
        self.dataSource = DataSource(
            collectionView: self.collectionView
        ) { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueCell(of: Cell.self, for: indexPath)
            else {
                return nil
            }
            self?.cellConfigurator?(cell, indexPath.item, itemIdentifier)
            return cell
        }
        self.collectionView.dataSource = self.dataSource

        self.collectionView.delegate = self.delegateProxy
        self.delegateProxy.cellSizeProvider = { collectionView, layout, indexPath in
            let visibleSize = collectionView.frame.size
            let cellSize = CGSize(
                width: self.items.count > 1 ? visibleSize.width * 0.8 : visibleSize.width,
                height: visibleSize.height
            )
            (layout as? UICollectionViewFlowLayout)?.itemSize = cellSize
            return cellSize
        }

        self.collectionView.decelerationRate = .fast
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(type: Cell.self)

        self.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            self.collectionView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor
            ),
            self.collectionView.topAnchor.constraint(
                equalTo: self.topAnchor
            ),
            self.collectionView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor
            )
        ])
    }

    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items)
        self.dataSource?.apply(
            snapshot,
            animatingDifferences: true
        )
    }
}

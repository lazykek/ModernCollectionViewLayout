//
//  ThirdViewController.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 20.11.2023.
//

import UIKit

final class ThirdViewController: UIViewController {

    // MARK: - Private vars

    let snapCarousel = HorizontalSnapCarouselView<String, CustomCell>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.snapCarousel)
        self.snapCarousel.backgroundColor = .lightGray
        self.snapCarousel.cellConfigurator = { cell, indexPath, item in
            cell.number = item
        }
        self.snapCarousel.onCurrentCellChanged = { [weak snapCarousel] currentCell, _ in
            snapCarousel?.visibleCells.forEach { $0.backgroundColor = .green }
            currentCell.backgroundColor = .yellow
        }
        self.snapCarousel.onDidEndScrolling = { currentCell, _ in
            print(currentCell.number)
        }
        self.snapCarousel.items = (0...6).map { String($0) }

        self.snapCarousel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.snapCarousel.leadingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            self.snapCarousel.trailingAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            self.snapCarousel.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            self.snapCarousel.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

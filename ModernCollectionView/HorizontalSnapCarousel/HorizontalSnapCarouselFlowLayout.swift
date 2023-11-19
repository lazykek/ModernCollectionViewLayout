//
//  HorizontalSnapCarouselFlowLayout.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 19.11.2023.
//

import UIKit

final class HorizontalSnapCarouselFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Lifecycle

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard
            let collectionView,
            self.scrollDirection == .horizontal
        else {
            return proposedContentOffset
        }

        let currentPosition = collectionView.contentOffset.x / (self.itemSize.width + self.minimumLineSpacing)
        let nextCell: CGFloat = {
            if velocity.x > 0 {
                return ceil(currentPosition)
            } else if velocity.x < 0 {
                return floor(currentPosition)
            } else {
                return round(currentPosition)
            }
        }()
        let offset = (collectionView.frame.width - self.itemSize.width) / 2
        return CGPoint(
            x: nextCell * (self.itemSize.width + self.minimumLineSpacing) - offset,
            y: proposedContentOffset.y
        )
    }
}

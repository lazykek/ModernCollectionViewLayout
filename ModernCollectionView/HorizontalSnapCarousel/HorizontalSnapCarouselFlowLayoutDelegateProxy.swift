//
//  HorizontalSnapCarouselFlowLayoutDelegateProxy.swift
//  ModernCollectionView
//
//  Created by Ilya Cherkasov on 20.11.2023.
//

import UIKit

final class HorizontalSnapCarouselFlowLayoutDelegateProxy: NSObject {

    // MARK: - Public and internal vars

    var cellSizeProvider: ((UICollectionView, UICollectionViewLayout, IndexPath) -> (CGSize))?
    var onDidScroll: (() -> Void)?
    var onDidEndScrolling: (() -> Void)?
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalSnapCarouselFlowLayoutDelegateProxy:
    UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        self.cellSizeProvider?(collectionView, collectionViewLayout, indexPath) ?? .zero
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.onDidEndScrolling?()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onDidEndScrolling?()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.onDidScroll?()
    }
}

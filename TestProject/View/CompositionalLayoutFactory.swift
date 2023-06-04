//
//  CompositionalLayoutFactory.swift
//  TestProject
//
//  Created by 김동우 on 2023/06/02.
//

import UIKit

// MARK: dimension 옵션 정리
// absolute: 절대 값 고정 값
// estimated: 동적인 레이아웃이 필요한 경우나 컨텐츠의 크기를 정확하게 알 수 없는 경우에 유용하게 사용될 수 있습니다.
// fractional: 실제 크기가 아닌 상대적인 크기를 지정하는 속성입니다. 예를 들어, fractionalWidth가 1이면 해당 아이템이 전체 너비를 차지하고, 0.5이면 반 너비를 차지합니다. 이러한 속성을 사용하여 동적인 레이아웃을 생성할 수 있습니다.

class CompositionalLayoutFactory {
    func createLayout(_ data: [CompanySection]) -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let strongSelf = self else {
                return (self?.getEmptySection())!
            }
            
            let item = strongSelf.createItem()
            let group = strongSelf.createGroup([item])
            
            let section = strongSelf.createLayoutSection(data[sectionIndex].direction,group)
            
            return section
        }
    }
    
    private func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(300),
                                              heightDimension: .absolute(200))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 10)
        return item
    }
    
    private func createGroup(_ items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(300),
                                               heightDimension: .estimated(200))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: items)
        return group
    }
    
    private func createLayoutSection(_ number: Int,
                                     _ group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        if number == 0 {
            section.orthogonalScrollingBehavior = .continuous
        } else {
            section.orthogonalScrollingBehavior = .none
        }
        let header = createSectionHeader()
        let footer = createSectionFooter()
        
        section.boundarySupplementaryItems = [ header, footer ]
        return section
    }
    
    internal func getEmptySection() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(
            layoutSize: .init(widthDimension: .absolute(0),
                              heightDimension: .absolute(0))
        )
        
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(widthDimension: .absolute(0),
                              heightDimension: .absolute(0)),
            subitems: [item])
        
        return .init(group: group)
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return headerItem
    }
    
    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let footerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        return footerItem
    }
}


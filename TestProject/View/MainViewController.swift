//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

class MainViewController: UIViewController {
    let dummyData = CompanySection.getCompanyDummyData()
    var sections: [MainViewController.Section] = []
    
    private let layoutFactory = CompositionalLayoutFactory()
    
    lazy var collectionView: UICollectionView = {
        let layout = layoutFactory.createLayout(self.dummyData)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.register(CompositionalFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CompositionalFooter.identifier)
        collectionView.register(CompositionalHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CompositionalHeader.identifier)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<MainViewController.Section, BaseCellItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        reloadData()
    }
    
    private func setupData() {
        dummyData.forEach {
            sections.append(MainViewController.Section(type: checkDirection($0.direction),
                                                        items: $0.companies.map {
                CompositionalCellItem(companyText: $0.companyName,
                                      locationText: $0.companyPosition)
            })
            )
        }
        
    }
    
    private func checkDirection(_ number: Int) -> MainViewController.Section.SectionType {
        if number == 0 {
            return .horizontal
        } else {
            return .vertical
        }
    }
    
    private func setupUI() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collectionView) { [weak self] in
            let sectionType = self?.sections[$1.section].type
            
            switch sectionType {
            case .horizontal:
                guard let item = $2 as? CompositionalCellItem else {
                    return UICollectionViewCell()
                }
                let cell = self?.dequeueReusableCell($0, $1) as? CollectionViewCell
                cell?.contentView.backgroundColor = .systemBlue
                cell?.setupCell(item)
                
                return cell
            case .vertical:
                guard let item = $2 as? CompositionalCellItem else {
                    return UICollectionViewCell()
                }
                let cell = self?.dequeueReusableCell($0, $1) as? CollectionViewCell
                cell?.contentView.backgroundColor = .orange
                cell?.setupCell(item)
                return cell
            case .none: break
            }
            
            return $0.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                          for: $1)
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CompositionalHeader.identifier,
                    for: indexPath) as? CompositionalHeader else {
                    return UICollectionReusableView()
                }
                
                switch indexPath.section {
                case 0:
                    headerView.headerLabel.text = "가로모드"
                default:
                    headerView.headerLabel.text = "세로모드"
                }
                
                return headerView
            } else {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CompositionalFooter.identifier,
                    for: indexPath) as? CompositionalFooter else {
                    return UICollectionReusableView()
                }
                footerView.footerLabel.text = "다리다"
                footerView.footerLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                return footerView
            }
        }
    }
    
    private func dequeueReusableCell(_ collectionView: UICollectionView,
                                     _ indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as? CollectionViewCell {
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<MainViewController.Section, BaseCellItem>()
        
        sections.forEach {
            snapShot.appendSections([$0])
            snapShot.appendItems($0.items, toSection: $0)
        }
        
        dataSource?.apply(snapShot)
    }
}

extension MainViewController {
    internal class Section: Hashable {
        let identifier: UUID = .init()
        
        let type: SectionType
        var items: [BaseCellItem]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: MainViewController.Section,
                        rhs: MainViewController.Section) -> Bool {
            lhs.identifier ==  rhs.identifier
        }
        
        init(type: SectionType,
             items: [BaseCellItem]) {
            self.type = type
            self.items = items
        }
        
        public enum SectionType {
            case vertical
            case horizontal
        }
    }
}

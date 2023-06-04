//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

class MainViewController: UIViewController {
    let dummyData = CompanySection.getCompanyDummyData()
    
    private let layoutFactory = CompositionalLayoutFactory()
    
    lazy var collectionView: UICollectionView = {
        let layout = layoutFactory.createLayout(self.dummyData)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dummyData[section].companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                            for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.contentView.backgroundColor = .blue
        case 1:
            cell.contentView.backgroundColor = .orange
        case 2:
            cell.contentView.backgroundColor = .systemRed
        default:
            return UICollectionViewCell()
        }
        cell.setupCell(dummyData[indexPath.section].companies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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

extension MainViewController: UICollectionViewDelegate {
    
}

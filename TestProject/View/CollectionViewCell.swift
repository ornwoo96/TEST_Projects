//
//  CollectionViewCell.swift
//  TestProject
//
//  Created by 김동우 on 2023/06/02.
//

import UIKit

class CompositionalCellItem: BaseCellItem {
    let companyText: String
    let locationText: String
    
    init(companyText: String, locationText: String) {
        self.companyText = companyText
        self.locationText = locationText
    }
}

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 30
        setupCompanyLabel()
        setupLocationLabel()
    }
    
    private func setupCompanyLabel() {
        contentView.addSubview(companyLabel)
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            companyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            companyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20)
        ])
    }
    
    private func setupLocationLabel() {
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func setupCell(_ item: CompositionalCellItem) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.companyLabel.text = item.companyText
            strongSelf.locationLabel.text = item.locationText
        }
    }
}

//
//  CompositionalFooter.swift
//  TestProject
//
//  Created by 김동우 on 2023/06/04.
//

import UIKit

class CompositionalFooter: UICollectionReusableView {
    static let identifier = "CompositionalFooter"
    
    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,
                                       weight: .bold)
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
        setupLabel()
    }
    
    private func setupLabel() {
        self.addSubview(footerLabel)
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            footerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}

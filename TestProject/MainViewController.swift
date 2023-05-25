//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

struct Company {
    let direction: Int
    let person: [Person]
}

struct Person {
    
}

class MainViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let 
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: <#T##UICollectionViewLayout#>)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}

//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchImageData()
    }
    
    private func fetchImageData() {
        do {
            let gifData = (try getDataFromAsset(named: "export_0"))!
            self.setupGIFImage(gifData)
        } catch {
            print("image fetch Failure")
        }
    }
    
    private func setupGIFImage(_ gifData: Data) {
        let gifImage = createUIImageArrayAndAnimationDuration(gifData)
        self.imageView.animationImages = gifImage?.0
        self.imageView.animationDuration = gifImage?.1 ?? 0.0
        self.imageView.startAnimating()
    }
    
    private func setupUI() {
        setupImageView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func createUIImageArrayAndAnimationDuration(_ gifImageData: Data) -> ([UIImage], Double)? {
        guard let imageSource = CGImageSourceCreateWithData(gifImageData as CFData, nil) else {
            return nil
        }
        
        let gifImageCount = CGImageSourceGetCount(imageSource)
        var animationDuration: Double = 0.0
        var imageArray: [UIImage] = []
        
        for i in 0..<gifImageCount {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil),
                  let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any],
                  let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { return nil }
            
            imageArray.append(UIImage(cgImage: image))
            
            animationDuration += gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
        }
        
        return (imageArray, animationDuration)
    }
    
    private func getDataFromAsset(named fileName: String) throws -> Data? {
        guard let asset = NSDataAsset(name: fileName) else {
            throw fatalError()
        }
        return asset.data
    }
}

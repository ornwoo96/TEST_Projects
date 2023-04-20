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
    
    private lazy var animationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("StopAnimating", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(animationButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func animationButtonDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "StopAnimating" {
            animationButton.setTitle("StartAnimating", for: .normal)
            imageView.stopAnimating()
        } else {
            animationButton.setTitle("StopAnimating", for: .normal)

            do {
                let gifData = (try getDataFromAsset(named: "export_0"))!
                let gifImage = createUIImageArrayAndAnimationDuration(gifData)
                
                imageView.animationImages = gifImage?.0
                imageView.animationDuration = gifImage?.1 ?? 0.0
                imageView.startAnimating()
            } catch {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchImageData()
    }
    
    private func fetchImageData() {
        do {
            let gifData = (try getDataFromAsset(named: "export_0"))!
            let gifImage = createUIImageArrayAndAnimationDuration(gifData)
            
            imageView.animationImages = gifImage?.0
            imageView.animationDuration = gifImage?.1 ?? 0.0
            imageView.startAnimating()
        } catch {
            
        }
    }
    
    private func setupUI() {
        setupImageView()
        setupAnimationButton()
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
    
    private func setupAnimationButton() {
        view.addSubview(animationButton)
        animationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 175),
            animationButton.heightAnchor.constraint(equalToConstant: 50),
            animationButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func createUIImageArrayAndTotalDuration(_ gifImageData: Data) -> UIImage? {
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
        
        return UIImage.animatedImage(with: imageArray, duration: animationDuration)
    }
    
    private func createUIImageArrayAndAnimationDuration(_ gifImageData: Data) -> ([UIImage], Double)? {
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
    
    func getDataFromAsset(named fileName: String) throws -> Data? {
        guard let asset = NSDataAsset(name: fileName) else {
            throw fatalError()
        }
        
        return asset.data
    }
}

//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

class MainViewController: UIViewController {
    private var timer: Timer?
    private var currentFrameIndex = 0
    private var gifImageArray: [CGImage] = []
    private var gifDuration = 0.0
    
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
        self.gifImageArray = gifImage?.0 ?? []
        self.gifDuration = gifImage?.1 ?? 0.0
        self.startAnimating()
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
    
    private func startAnimating() {
        timer = Timer.scheduledTimer(withTimeInterval: gifDuration, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentFrameIndex += 1
            self.currentFrameIndex %= self.gifImageArray.count
            DispatchQueue.main.async {
                self.imageView.layer.contents = self.gifImageArray[self.currentFrameIndex]
            }
        }
    }
    
    private func stopAnimating() {
        timer?.invalidate()
    }
    
    @objc private func animationButtonDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "StopAnimating" {
            animationButton.setTitle("StartAnimating", for: .normal)
            stopAnimating()
        } else {
            animationButton.setTitle("StopAnimating", for: .normal)
            startAnimating()
        }
    }
}

// MARK: Create Image Data
extension MainViewController {
    private func createUIImageArrayAndAnimationDuration(_ gifImageData: Data) -> ([CGImage], Double)? {
        guard let imageSource = CGImageSourceCreateWithData(gifImageData as CFData, nil) else {
            return nil
        }
        
        let gifImageCount = CGImageSourceGetCount(imageSource)
        var animationDuration: Double = 0.0
        var imageArray: [CGImage] = []
        
        for i in 0..<gifImageCount {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil),
                  let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any],
                  let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { return nil }
            
            imageArray.append(image)
            
            animationDuration += gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
        }
        
        
        return (imageArray, animationDuration/Double(gifImageCount))
    }
    
    private func getDataFromAsset(named fileName: String) throws -> Data? {
        guard let asset = NSDataAsset(name: fileName) else {
            throw fatalError()
        }
        return asset.data
    }
}

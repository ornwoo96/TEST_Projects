//
//  ViewController.swift
//  TestProject
//
//  Created by 김동우 on 2023/01/18.
//

import UIKit

class MainViewController: UIViewController {
    private var currentFrameIndex = 0
    private var currentFrameDuration = 0.0
    private var gifImageArray: [CGImage] = []
    private var gifDurationArray: [Double] = []
    private var lastFrameTime: TimeInterval = 0.0
    private let maxFrameDuration = 1.0
    private var isPaused = false
    private var displayLink: CADisplayLink?
    
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
            self.setupDisplayLink()
        } catch {
            print("image fetch Failure")
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc private func updateFrame() {
        checkIsPaused()
    }
    
    private func checkIsPaused() {
        if !isPaused {
            updateLoopCount()
            updateImageWithElapsedTime()
        }
    }
    
    private func updateLoopCount() {
        if currentFrameIndex >= gifImageArray.count {
            currentFrameIndex = 0
        }
    }
    
    private func updateImageWithElapsedTime() {
        incrementTimeSinceLastFrameChange()
        updateCurrentFrameDuration()
        
        if currentFrameDuration <= lastFrameTime {
            updateCurrentImage()
            resetLastFrameTime()
            updateCurrentFrameIndex()
        }
    }
    
    private func updateCurrentFrameDuration() {
        currentFrameDuration = gifDurationArray[currentFrameIndex]
    }
    
    private func updateCurrentImage() {
        imageView.layer.contents = gifImageArray[currentFrameIndex]
    }
    
    private func updateCurrentFrameIndex() {
        currentFrameIndex += 1
    }
    
    private func incrementTimeSinceLastFrameChange() {
        lastFrameTime += min(maxFrameDuration, displayLink!.duration)
    }
    
    private func resetLastFrameTime() {
        lastFrameTime -= currentFrameDuration
    }
    
    private func startAnimating() {
        displayLink?.isPaused = false
    }
    
    private func stopAnimating() {
        displayLink?.isPaused = true
    }
    
    private func setupGIFImage(_ gifData: Data) {
        let gifImage = createUIImageArrayAndAnimationDurationArray(gifData)
        self.gifImageArray = gifImage?.0 ?? []
        self.gifDurationArray = gifImage?.1 ?? []
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
    private func createUIImageArrayAndAnimationDurationArray(_ gifImageData: Data) -> ([CGImage], [Double])? {
        guard let imageSource = CGImageSourceCreateWithData(gifImageData as CFData, nil) else {
            return nil
        }
        
        let gifImageCount = CGImageSourceGetCount(imageSource)
        var animationDurations: [Double] = []
        var imageArray: [CGImage] = []
        
        for i in 0..<gifImageCount {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil),
                  let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any],
                  let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { return nil }
            
            imageArray.append(image)
            animationDurations.append(gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1)
        }
        
        
        return (imageArray, animationDurations)
    }
    
    private func getDataFromAsset(named fileName: String) throws -> Data? {
        guard let asset = NSDataAsset(name: fileName) else {
            throw fatalError()
        }
        return asset.data
    }
}

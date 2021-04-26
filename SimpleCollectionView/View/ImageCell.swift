//
//  ImageCell.swift
//  SimpleCollectionView
//
//  Created by Vladislav Garifulin on 25.04.2021.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .topLeft
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
        
    func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    var value: Image? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = nil
            }
            
            DispatchQueue.global().async {
                guard let value = self.value else { return }
                
                value.get { [weak self] (imageData, error) in
                    guard
                        let self = self,
                        error == nil,
                        self.value?.path == value.path,
                        let imageData = imageData,
                        let image = UIImage(data: imageData)
                    else {
                        return
                    }
                    
                    let scaledImage = image.scaled(to: DispatchQueue.main.sync { return self.bounds.size }, scalingMode: .aspectFill)
                    
                    DispatchQueue.main.async {
                        self.imageView.image = scaledImage
                    }
                }
            }
        }
    }
    
    func didLoaded() -> Bool {
        return imageView.image != nil
    }
}

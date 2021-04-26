//
//  UIImage+Scaling.swift
//  SimpleCollectionView
//
//  Created by Vladislav Garifulin on 26.04.2021.
//

import UIKit

extension UIImage {
    enum ScalingMode {
        case aspectFill
        case aspectFit

        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height

            switch self {
            case .aspectFill:
               return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }

    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage? {
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y = (newSize.height - size.height * aspectRatio) / 2.0

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }
}

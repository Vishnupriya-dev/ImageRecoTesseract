//
//  UIImage+ImageScaling.swift
//  ImageExtractor
//
//  Created by Vishnu on 07/06/21.
//

import Foundation
import UIKit
import GPUImage

extension UIImage {
    
  func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)

    if size.width > size.height {
      scaledSize.height = size.height / size.width * scaledSize.width
    } else {
      scaledSize.width = size.width / size.height * scaledSize.height
    }

    UIGraphicsBeginImageContext(scaledSize)
    draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return scaledImage
  }

    func preprocessedImage() -> UIImage? {
      let stillImageFilter = GPUImageAdaptiveThresholdFilter()
      stillImageFilter.blurRadiusInPixels = 15.0
      let filteredImage = stillImageFilter.image(byFilteringImage: self)
      return filteredImage
    }
}

//
//  Extension.swift
//  tawkExam
//
//  Created by CRAMJ on 8/6/20.
//  Copyright © 2020 CRAMJ. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    override open func awakeFromNib() {
        super.awakeFromNib()
        tintColorDidChange()
    }
    func makeRounded() {

        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        if traitCollection.userInterfaceStyle == .dark
        {
            self.layer.borderColor = UIColor.white.cgColor
        }
        else
        {
            self.layer.borderColor = UIColor.black.cgColor
        }
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}

extension UIImage {
    func invertedColors() -> UIImage? {
        guard let ciImage = CIImage(image: self) ?? ciImage, let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = filter.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }
}


@IBDesignable
class CustomView: UIView{

@IBInspectable var borderWidth: CGFloat = 0.0{

    didSet{

        self.layer.borderWidth = borderWidth
    }
}


@IBInspectable var borderColor: UIColor = UIColor.clear {

    didSet {

        self.layer.borderColor = borderColor.cgColor
    }
}

override func prepareForInterfaceBuilder() {

    super.prepareForInterfaceBuilder()
    }
}

@IBDesignable class CustomButton: UIButton{
    @IBInspectable var borderWidth: CGFloat = 0.0{

        didSet{

            self.layer.borderWidth = borderWidth
        }
    }


    @IBInspectable var borderColor: UIColor = UIColor.clear {

        didSet {

            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize =  CGSize(width: 0.0, height: -3.0) {
        didSet
        {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0{
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    

    override func prepareForInterfaceBuilder() {

        super.prepareForInterfaceBuilder()
        }
}

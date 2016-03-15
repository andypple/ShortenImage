//
//  NYTPhotoImp.swift
//  ShortenImage
//
//  Created by Phat Le on 3/15/16.
//  Copyright © 2016 FourFi. All rights reserved.
//

import NYTPhotoViewer

class NYTPhotoImp: NSObject, NYTPhoto {

    var image: UIImage?
    var imageData: NSData?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "Made in Sai Gon", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "Phat Le", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])

    init(image: UIImage? = nil, imageData: NSData? = nil, attributedCaptionTitle: NSAttributedString) {
        self.image = image
        self.imageData = imageData
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }
}

//
//  ImageCollectionViewCell.swift
//  ShortenImage
//
//  Created by Phat Le on 3/14/16.
//  Copyright © 2016 FourFi. All rights reserved.
//

import UIKit
import FPPicker

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewer: UIImageView!

    func configWithObject(info: FPMediaInfo) {
        if let localPath = info.mediaURL {
            self.imageViewer.image = UIImage(contentsOfFile: localPath.path!)
        } else if let remotePath = info.remoteURL {
            self.imageViewer.imageFromUrl(remotePath.absoluteString)
        }

    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

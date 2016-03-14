//
//  ViewController.swift
//  ShortenImage
//
//  Created by Phat Le on 3/14/16.
//  Copyright © 2016 FourFi. All rights reserved.
//

import UIKit
import FPPicker

class HomeViewController: UIViewController {

    var pickedImages: [FPMediaInfo] = []

    @IBOutlet weak var imageCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }

    @IBAction func showFilePicker(sender: UIButton) {
        let fpController = FPPickerController()
        fpController.fpdelegate = self;
    //    fpController.theme = self.theme;
        fpController.dataTypes = ["image/*", "video/*"]
        fpController.selectMultiple = true;

        fpController.maxFiles = 20;
        fpController.disableFrontCameraLivePreviewMirroring = true;
        fpController.modalPresentationStyle = .Popover
        fpController.preferredContentSize = CGSizeMake(400, 500);

        let presentationController = fpController.popoverPresentationController
        presentationController!.permittedArrowDirections = .Any
        presentationController!.sourceView = sender
        presentationController!.sourceRect = sender.bounds

        self.presentViewController(fpController,
                           animated:true,
                         completion:nil)
    }
}

extension HomeViewController: FPPickerControllerDelegate {

    func fpPickerController(pickerController: FPPickerController!, didFinishPickingMultipleMediaWithResults results: [AnyObject]!) {
        let images = results as! [FPMediaInfo]

        self.pickedImages = images.filter { (mediaInfo) -> Bool in
            return mediaInfo.containsImageAtMediaURL()
        }

        dismissViewControllerAnimated(true) { [unowned self] () -> Void in
            self.imageCollectionView.reloadData()
        }
    }

    func fpPickerControllerDidCancel(pickerController: FPPickerController!) {
        dismissViewControllerAnimated(true) { () -> Void in
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pickedImages.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell

        let imageInfo = self.pickedImages[indexPath.row]
        cell.imageViewer.image = UIImage(contentsOfFile: imageInfo.mediaURL.path!)

        return cell
    }
}

//
//  ViewController.swift
//  ShortenImage
//
//  Created by Phat Le on 3/14/16.
//  Copyright © 2016 FourFi. All rights reserved.
//

import UIKit
import FPPicker
import NYTPhotoViewer

class HomeViewController: UIViewController {

    var pickedImages: [FPMediaInfo] = []

    @IBOutlet weak var shortenLinkTF: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.shortenLinkTF.delegate = self
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
            self.createGroup()
        }
    }

    func fpPickerControllerDidCancel(pickerController: FPPickerController!) {
        dismissViewControllerAnimated(true) { () -> Void in
        }
    }

    internal func createGroup() {
        let imageURLs = self.pickedImages.map { (mediaInfo) -> String in
            return mediaInfo.remoteURL.absoluteString
        }
        ShortenImageNetwork().createGroup(imageURLs,completion: { [unowned self] (success, text) -> Void in
            if success {
                self.shortenLinkTF.text = text
            } else {
                self.showErrorMessage(text)
            }
        })
    }

    internal func fetchGroup() {
        ShortenImageNetwork().fetchGroup(self.shortenLinkTF.text!) { [unowned self] (success, images) -> Void in

            if success {
                self.pickedImages = images.map({ (url) -> FPMediaInfo in
                    let media = FPMediaInfo()
                    media.remoteURL = NSURL(string: url)
                    return media
                })

                self.imageCollectionView.reloadData()
            } else {
                self.showErrorMessage("Something went wrong")
            }
        }
    }

    internal func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pickedImages.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell

        let imageInfo = self.pickedImages[indexPath.row]
        cell.configWithObject(imageInfo)

        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (CGRectGetWidth(self.view.bounds) - 8)/3
        return CGSizeMake(size, size)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let nytPhotos = self.pickedImages.map { (mediaInfo) -> NYTPhoto in
            return NYTPhotoImp(image: nil, imageData: NSData(contentsOfURL: mediaInfo.remoteURL), attributedCaptionTitle: NSAttributedString())
        }
        let nytController = NYTPhotosViewController(photos: nytPhotos)
        self.presentViewController(nytController, animated: true) { () -> Void in

        }
    }

}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if validateUrl(textField.text!) {
            self.fetchGroup()
        } else {
            showErrorMessage("Please enter valid link")
        }

        textField.resignFirstResponder()
        return true;
    }

    func validateUrl (stringURL : NSString) -> Bool {

        let urlRegEx = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])

        return predicate.evaluateWithObject(stringURL)
    }
}

extension HomeViewController {

    @IBAction func shareAction(sender: AnyObject) {
        if let link = self.shortenLinkTF.text {
            let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)

            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}

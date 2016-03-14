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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

        dismissViewControllerAnimated(true) { () -> Void in
        }
    }

    func fpPickerControllerDidCancel(pickerController: FPPickerController!) {
        dismissViewControllerAnimated(true) { () -> Void in
        }
    }
}
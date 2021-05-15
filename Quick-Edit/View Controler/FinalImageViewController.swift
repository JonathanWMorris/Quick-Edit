//
//  FinalImageViewController.swift
//  Quick-Edit
//
//  Created by Jonathan Morris on 5/13/21.
//

import UIKit
import CoreML

class FinalImageViewController: UIViewController {
    
    @IBOutlet var finalImageView: UIImageView!
    var foregroundImage: UIImage? = nil
    var backgroundImage: UIImage? = nil
    var finalImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finalImage = foregroundImage?.removeBackground(returnResult: .finalImage)
        
        let size = foregroundImage!.size
        
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage!.draw(in: areaSize)
        
        finalImage!.draw(in: areaSize, blendMode: .normal, alpha: 1)
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        finalImageView.image = finalImage
    }
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        // set up activity view controller
        let imageToShare = [ finalImage! ]
        
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//
//  FinalImageViewController.swift
//  Quick-Edit
//
//  Created by Jonathan Morris on 5/13/21.
//

import UIKit
import CoreML
import LinkPresentation
import GoogleMobileAds

class FinalImageViewController: UIViewController, UIActivityItemSource {
    
    @IBOutlet var finalImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var finalImage:UIImage? = nil
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let finalImage = finalImage {
            finalImageView.image = finalImage
        }
        
        // Setup for the Ad
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-7507216219120305/7218858661"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [finalImage!, self], applicationActivities: nil)
        
        // so that iPads won't crash
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.right
        activityViewController.popoverPresentationController?.sourceView = sender
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    @IBAction func coppyButtonPressed(_ sender: UIButton) {
        UIPasteboard.general.image = finalImage
        let alert = UIAlertController(title: "Image Coppied", message: "The image you created has been coppied to clip board.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let image = finalImage!
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        metadata.title = "Quick Edit Image"
        return metadata
    }
}

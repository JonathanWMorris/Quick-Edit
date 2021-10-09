//
//  ViewController.swift
//  Quick-Edit
//
//  Created by Jonathan Morris on 5/13/21.
//

import UIKit
import PhotosUI
import GoogleMobileAds

class SelectionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    fileprivate var imagepicker = UIImagePickerController()
    
    fileprivate var isForegroundImage = false
    
    fileprivate var foregroundImage: UIImage? = nil
    fileprivate var backgroundImage: UIImage? = nil
    
    @IBOutlet var selectForegroundButton: UIButton!
    @IBOutlet var foregroundImageCheck: UIImageView!
    @IBOutlet var foregroundImageView: UIImageView!
    
    @IBOutlet var selectBackgroundButton: UIButton!
    @IBOutlet var backgroundImageCheck: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var nextButton: UIButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.delegate = self
        selectForegroundButton.layer.cornerRadius = 10
        selectBackgroundButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 5
        
        // Setup for the Ad
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-7507216219120305/7218858661"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        switch isForegroundImage {
        case true:
            foregroundImage = image
            foregroundImageView.image = image
            
            if foregroundImage != nil {
                foregroundImageCheck.isHidden = false
            }
            checkUnhideNextButton()
            
        default:
            backgroundImage = image
            backgroundImageView.image = image
            
            if backgroundImage != nil {
                backgroundImageCheck.isHidden = false
            }
            checkUnhideNextButton()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func checkUnhideNextButton() {
        if foregroundImage != nil && backgroundImage != nil {
            nextButton.isHidden = false
        }else{
            nextButton.isHidden = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectBackgroundPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        isForegroundImage = false
        present(imagepicker, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
    @IBAction func SelectForegroundPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        isForegroundImage = true
        present(imagepicker, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants().segues.selectionToFinal {
            self.activityIndicator.startAnimating()
            
            let destinationVC = segue.destination as! FinalImageViewController
            
            backgroundImage = cropToBounds(image: backgroundImage!, width: 513, height: 513)
            foregroundImage = cropToBounds(image: foregroundImage!, width: 513, height: 513)
            
            var finalImage: UIImage? = nil
            
            finalImage = foregroundImage?.removeBackground(returnResult: .finalImage)
            
            let size = CGSize(width: 513, height: 513)
            
            UIGraphicsBeginImageContext(size)
            
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            backgroundImage!.draw(in: areaSize)
            
            finalImage!.draw(in: areaSize, blendMode: .normal, alpha: 1)
            
            finalImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            destinationVC.finalImage = finalImage
            self.activityIndicator.stopAnimating()
        }
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
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
    }
}


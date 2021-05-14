//
//  ViewController.swift
//  Quick-Edit
//
//  Created by Jonathan Morris on 5/13/21.
//

import UIKit
import CoreML
import PhotosUI

class SelectionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    fileprivate var imagepicker = UIImagePickerController()
    
    fileprivate var isForegroundImage = false
    
    fileprivate var foregroundImage: UIImage? = nil
    fileprivate var backgroundImage: UIImage? = nil
    
    @IBOutlet var SelectForegroundButton: UIButton!
    @IBOutlet var foregroundImageCheck: UIImageView!
    
    @IBOutlet var selectBackgroundButton: UIButton!
    @IBOutlet var backgroundImageCheck: UIImageView!
    
    
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        switch isForegroundImage {
        case true:
            foregroundImage = image
            if foregroundImage != nil {
                foregroundImageCheck.isHidden = false
            }
        default:
            backgroundImage = image
            if backgroundImage != nil {
                backgroundImageCheck.isHidden = false
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectBackgroundPressed(_ sender: UIButton) {
        isForegroundImage = false
        present(imagepicker, animated: true, completion: nil)
    }
    
    @IBAction func SelectForegroundPressed(_ sender: UIButton) {
        isForegroundImage = true
        present(imagepicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants().segues.selectionToFinal {
            let destinationVC = segue.destination as! FinalImageViewController
            destinationVC.foregroundImage = foregroundImage
        }
    }
}


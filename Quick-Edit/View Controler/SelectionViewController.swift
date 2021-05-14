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
    
    fileprivate var foregroundImage: UIImage?
    
    @IBOutlet var SelectForegroundButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        foregroundImage = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SelectForegroundPressed(_ sender: UIButton) {
        present(imagepicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants().segues.selectionToFinal {
            let destinationVC = segue.destination as! FinalImageViewController
            destinationVC.foregroundImage = foregroundImage
        }
    }
}


//
//  FinalImageViewController.swift
//  Quick-Edit
//
//  Created by Jonathan Morris on 5/13/21.
//

import UIKit

class FinalImageViewController: UIViewController {
    
    @IBOutlet var FinalImageView: UIImageView!
    var foregroundImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FinalImageView.image = foregroundImage
    }
    
    

}

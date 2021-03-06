//
//  CompartirPageItemController.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 06/12/15.
//  Copyright © 2015 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import FBSDKShareKit
import TwitterKit

class CompartirPageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
    }
    
    @IBAction func bTwitter(sender: AnyObject) {

        
        // Generate the image of the poem.
        let poemImage = UIImage(named: imageName)
        
        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()
        
        // Prepare the Tweet with the poem and image.
        composer.setImage(poemImage)
        composer.setText("¡Esta receta me encanta!")
        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                //print("Tweet composition completed.")
            } else if result == .Cancelled {
               // print("Tweet composition cancelled.")
            }
        }
    }
    @IBAction func bFaceBook(sender: AnyObject) {
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        
        
        photo.image =  UIImage(named: imageName)
        
        photo.userGenerated = true
        
        let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()

        content.photos = [photo];
        
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
        //let button : FBSDKShareButton = FBSDKShareButton()
        //button.shareContent = content


    }
    @IBAction func bPrinteres(sender: AnyObject) {
    }
    
}

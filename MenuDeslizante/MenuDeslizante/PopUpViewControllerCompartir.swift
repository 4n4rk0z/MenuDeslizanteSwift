//
//  PopUpViewControllerCompartir.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 27/01/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//


import UIKit
import QuartzCore
import Parse
import PinterestSDK
import FBSDKShareKit

import TwitterKit

@objc public class PopUpViewControllerCompartir : UIViewController, FBSDKSharingDelegate{
    
    var mainViewController: UIView!

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var imageViewReceta: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    
    

    var context:PrincipalTableViewController!
    var opcion:String!
    var tituloEmpresa:String = "Toukanmango"
    var receta:PFObject!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    
    public func showInView(aView: UIView!, animated: Bool, receta:PFObject!, imagenReceta:UIImage){
        
        
        mainViewController = aView
        aView.addSubview(self.view)
        self.showAnimate()

        
        self.imageViewReceta.image = imagenReceta
        self.receta = receta
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    
    @IBAction func btnFacebook(sender: AnyObject) {
        
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        
        
        photo.image =  self.imageViewReceta.image
        
        photo.userGenerated = true
        
        let content: FBSDKSharePhotoContent = FBSDKSharePhotoContent()

        content.photos = [photo];

        
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
        //let button : FBSDKShareButton = FBSDKShareButton()
        //button.shareContent = content
        
    }
    
    func completeFbShare(){
        self.removeAnimate()
    }
    
    public func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
       
        
        if self.opcion != nil && self.opcion == "viral" {
            
            self.context.objBusqueda = self.receta
            self.context.imagenBusqueda = self.imageViewReceta.image
            
            self.context.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
        }
        
        print(results.description)
       
        self.removeAnimate()
        
    }
    
    
    public func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print(error)
    }
    
    public func sharerDidCancel(sharer: FBSDKSharing!) {
        print(sharer.debugDescription)
    }
    
    
    
    @IBAction func btnTwitter(sender: AnyObject) {
        
        // Generate the image of the poem.
        let poemImage = self.imageViewReceta.image
        
        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()
        
        // Prepare the Tweet with the poem and image.
        composer.setImage(poemImage)
        composer.setText(self.labelTitulo.text! + "\n¡Esta receta me encanta!\n\n"+self.tituloEmpresa)
        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                //print("Tweet composition completed.")
                if self.opcion != nil && self.opcion == "viral" {
                    
                    self.context.objBusqueda = self.receta
                    self.context.imagenBusqueda = self.imageViewReceta.image
                    
                    self.context.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
                }
                

                self.removeAnimate()
                
            } else if result == .Cancelled {
                // print("Tweet composition cancelled.")
            }
        }
    }
    
    @IBAction func btnPinteres(sender: AnyObject) {
        
        var url : NSString = receta["Url_Imagen"] as! String
        var urlStr = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let imgURL : NSURL = NSURL(string: urlStr as String)!
        url = "http://www.toukanmango.com"
        urlStr = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let direccion : NSURL = NSURL(string: urlStr as String)!
        
        PDKPin.pinWithImageURL(imgURL, link: direccion, suggestedBoardName: "ToukanMango", note: "Me encanta esta receta", withSuccess: { () -> Void in
            
            //print("successfully pinned pin")
            if self.opcion != nil && self.opcion == "viral" {
                
                self.context.objBusqueda = self.receta
                self.context.imagenBusqueda = self.imageViewReceta.image
                
                self.context.performSegueWithIdentifier("PlatilloSegueBuscador", sender: nil)
            }

            self.removeAnimate()

            }) { (NSError) -> Void in
                print("pin it failed")
        }

    }
    
    @IBAction func tapView(sender: AnyObject) {
        self.removeAnimate()
    }
    
}

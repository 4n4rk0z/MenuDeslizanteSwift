//
//  carusselMenuViewController.swift
//  MenuDeslizante
//
//  Created by Billy Jack Bates Garcia on 10/5/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import ImageSlideshow

class carusselMenuViewController: UIViewController {
    
    @IBOutlet weak var imagenGrande: ImageSlideshow!
    
    @IBOutlet weak var textoUno: ImageSlideshow!
    
    @IBOutlet weak var flor: ImageSlideshow!

    @IBOutlet weak var textDos: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "fondo_pago")!.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        //imagenGrande.backgroundColor = UIColor.whiteColor()
        imagenGrande.slideshowInterval = 3.0
        //imagenGrande.pageControlPosition = PageControlPosition.UnderScrollView
        //textoUno.backgroundColor = UIColor.whiteColor()
        textoUno.slideshowInterval = 3.0
        //textoUno.pageControlPosition = PageControlPosition.UnderScrollView
        //flor.backgroundColor = UIColor.whiteColor()
        flor.slideshowInterval = 3.0
        //flor.pageControlPosition = PageControlPosition.UnderScrollView
        //textDos.backgroundColor = UIColor.whiteColor()
        textDos.slideshowInterval = 3.0
        //textDos.pageControlPosition = PageControlPosition.UnderScrollView
        
        imagenGrande.setImageInputs([ImageSource(imageString:"imagenGrande_1.png" )!, ImageSource(imageString: "imagenGrande_2.png")!,ImageSource(imageString: "imagenGrande_3.png")!])
        
        textoUno.setImageInputs([ImageSource(imageString:"textUno_1" )!, ImageSource(imageString: "textUno_2")!,ImageSource(imageString: "textUno_3")!])
        
        flor.setImageInputs([ImageSource(imageString:"flor_trans" )!, ImageSource(imageString: "flor_trans")!,ImageSource(imageString: "flor_trans")!])
        
        textDos.setImageInputs([ImageSource(imageString:"text2_1" )!, ImageSource(imageString: "text2_2")!,ImageSource(imageString: "text2-3")!])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registroAction(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("Login") as! UINavigationController
        
        self.presentViewController(vc, animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

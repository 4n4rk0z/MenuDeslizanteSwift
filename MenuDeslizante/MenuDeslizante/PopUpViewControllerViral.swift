//
//  PopUpViral.swift
//  MenuDeslizante
//
//  Created by sergio ivan lopez monzon on 07/02/16.
//  Copyright © 2016 sergio ivan lopez monzon. All rights reserved.
//

import UIKit
import Parse

class PopUpViewControllerViral: UIViewController, UIPageViewControllerDataSource {
    
    var popTransparentView: UIView!
    
    
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    private var objReceta : PFObject!
    
    // Initialize it right away here
    private let contentImages = ["arabe.png",
        "chatarra.png",
        "salchichas.png",
        "carne.png"];
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //PopUp
        self.view.layer.cornerRadius = 5
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.view.layer.masksToBounds = true
        self.view.layer.zPosition = 1;
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureHandler:")
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        createPageViewController()
        setupPageControl()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureHandler(sender:UIPanGestureRecognizer){
        self.removeAnimate()
    }
    
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("CompartirPageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CompartirPageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! CompartirPageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> CompartirPageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("CompartirController") as! CompartirPageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    func showInView(aView: UIView!, animated: Bool, scaleX: CGFloat, scaleY: CGFloat) {
        
        self.popTransparentView = UIView.init(frame:  aView.frame)
        self.popTransparentView.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
        
        aView.addSubview(self.popTransparentView )
        aView.addSubview(self.view)
        
        if animated {
            
            self.showAnimate(scaleX, sY: scaleY)
        }
    }
    
    func showAnimate(sX: CGFloat, sY: CGFloat) {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(sX, sY)
        });
    }
    
    func removeAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished) {
                    
                    self.view.removeFromSuperview()
                    self.popTransparentView.removeFromSuperview()
                }
        });
    }
    
  /*  @IBAction func closePopUp(sender: AnyObject) {
        
        self.removeAnimate()
    }*/
    
}

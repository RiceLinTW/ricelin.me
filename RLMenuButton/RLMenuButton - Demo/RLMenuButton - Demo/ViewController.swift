//
//  ViewController.swift
//  RLMenuButton - Demo
//
//  Created by RiceLin on 9/2/16.
//  Copyright © 2016 Rice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menuButton              : RLMenuButton!
    var startCountingButton     : UIButton!
    var pauseCountingButton     : UIButton!
    var continueCountingButton  : UIButton!
    var endCountingButton       : UIButton!
    var resetButton             : UIButton!
    var statisticButton         : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCountingButton = UIButton(type: .Custom)
        startCountingButton.backgroundColor = UIColor.darkGrayColor()
        startCountingButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        startCountingButton.setImage(UIImage(named: "wht_start_counting"), forState: .Normal)
//        startCountingButton.addTarget(self, action: #selector(WHTViewController.startCountingButtonAction), forControlEvents: .TouchUpInside)
        
        pauseCountingButton = UIButton(type: .Custom)
        pauseCountingButton.backgroundColor = UIColor.darkGrayColor()
        pauseCountingButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        pauseCountingButton.setImage(UIImage(named: "wht_pause_counting"), forState: .Normal)
//        pauseCountingButton.addTarget(self, action: #selector(WHTViewController.pauseCountingButtonAction), forControlEvents: .TouchUpInside)
        
        continueCountingButton = UIButton(type: .Custom)
        continueCountingButton.backgroundColor = UIColor.darkGrayColor()
        continueCountingButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        continueCountingButton.setImage(UIImage(named: "wht_resume_counting"), forState: .Normal)
//        continueCountingButton.addTarget(self, action: #selector(WHTViewController.continueCountingButtonAction), forControlEvents: .TouchUpInside)
        
        endCountingButton = UIButton(type: .Custom)
        endCountingButton.backgroundColor = UIColor.darkGrayColor()
        endCountingButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        endCountingButton.setImage(UIImage(named: "wht_end_counting"), forState: .Normal)
//        endCountingButton.addTarget(self, action: #selector(WHTViewController.endCountingButtonAction), forControlEvents: .TouchUpInside)
        
        resetButton = UIButton(type: .Custom)
        resetButton.backgroundColor = UIColor.darkGrayColor()
        resetButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        resetButton.setImage(UIImage(named: "wht_reset"), forState: .Normal)
//        resetButton.addTarget(self, action: #selector(WHTViewController.resetButtonAction), forControlEvents: .TouchUpInside)
        
        statisticButton = UIButton(type: .Custom)
        statisticButton.backgroundColor = UIColor.darkGrayColor()
        statisticButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        statisticButton.setImage(UIImage(named: "wht_show_statistics"), forState: .Normal)
//        statisticButton.addTarget(self, action: #selector(WHTViewController.showStatistics), forControlEvents: .TouchUpInside)
        
        // TODO: - Still don't know should I put manual actions or not.
        menuButton = RLMenuButton(frame: CGRect(origin: CGPointMake(100, 100), size: CGSizeMake(40, 40)), menuItems: [resetButton, endCountingButton, continueCountingButton, pauseCountingButton, startCountingButton], expandDirection: RLMenuButtonExpandDirection(rawValue: 7)!)
        menuButton.center = view.center
        view.addSubview(menuButton)
    }

}


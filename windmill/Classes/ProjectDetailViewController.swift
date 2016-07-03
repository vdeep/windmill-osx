//
//  ProjectDetailViewController.swift
//  windmill
//
//  Created by Markos Charatzas on 20/03/2016.
//  Copyright © 2016 qnoid.com. All rights reserved.
//

import AppKit

extension CALayer {
    
    struct Windmill {
        
        static func positionAnchorPoint(layer: CALayer, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
            let frame = layer.frame
            layer.anchorPoint = anchorPoint
            layer.frame = frame
        }
    }
}

class ProjectDetailViewController: NSViewController {
    
    @IBOutlet weak var activityIndicatorImageView: NSImageView!
    @IBOutlet weak var activityTextfield: NSTextField!
    @IBOutlet weak var checkoutActivityView: ActivityView!
    @IBOutlet weak var buildActivityView: ActivityView!
    @IBOutlet weak var testActivityView: ActivityView!
    @IBOutlet weak var archiveActivityView: ActivityView!
    weak var topConstraint: NSLayoutConstraint!
    
    lazy var activityViews: [ActivityType: ActivityView] = { [unowned self] in
        return [.Checkout: self.checkoutActivityView, .Build: self.buildActivityView, .Test: self.testActivityView, .Archive: self.archiveActivityView]
    }()
    
    let defaultCenter = NSNotificationCenter.defaultCenter()
    var scheduler: Scheduler!
    
    override func updateViewConstraints() {
        
        if(self.topConstraint == nil) {
        
            let topAnchor = self.view.window!.contentLayoutGuide!.topAnchor
        
            let topConstraint = self.checkoutActivityView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 8)
        
            topConstraint!.active = true
        
            self.topConstraint = topConstraint
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        self.view.layer?.backgroundColor = NSColor.blackColor().CGColor


        self.defaultCenter.addObserver(self, selector: Selector("\(NSTask.Notifications.taskDidLaunch):"), name: NSTask.Notifications.taskDidLaunch, object: nil)
        self.defaultCenter.addObserver(self, selector: Selector("\(NSTask.Notifications.taskDidExit):"), name: NSTask.Notifications.taskDidExit, object: nil)
    }
    
    override func viewDidAppear() {
        CALayer.Windmill.positionAnchorPoint(self.activityIndicatorImageView.layer!)
        self.activityIndicatorImageView.layer?.addAnimation(CAAnimation.Windmill.spinAnimation, forKey: "spinAnimation")
    }
    
    func windmill(windmill: Windmill, willDeployProject project: Project) {
        self.activityIndicatorImageView.image = NSImage(named: "windmill-activity-indicator-inactive")
        for activityView in self.activityViews.values {
            activityView.hidden = true
            activityView.alphaValue = 0.5
        }
    }
    
    func taskDidLaunch(aNotification: NSNotification) {
        
        let activityType = ActivityType(rawValue: aNotification.userInfo!["activity"] as! String)!
        debugPrint("DEBUG: \(__FUNCTION__) \(activityType)")
        
        switch(activityType){
            case .Checkout, .Build, .Test, .Archive:
                self.activityIndicatorImageView.image = NSImage(named: activityType.imageName)
                self.activityViews[activityType]?.hidden = false
            default:
            break
        }
        
        self.activityTextfield.stringValue = activityType.description
    }
    
    func taskDidExit(aNotification: NSNotification) {
        
        let activityType = ActivityType(rawValue: aNotification.userInfo!["activity"] as! String)!
        
        switch(activityType){
        case .Checkout, .Build, .Test, .Archive:
            self.activityViews[activityType]?.alphaValue = 1.0
        default:
            break
        }
    }
}
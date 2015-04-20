//
//  ViewController.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import UIKit
import SceneKit
import CoreText
import AVFoundation

class ViewController: UIViewController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(anim : Bool) {
        initCameraFeed()
        self.view.addSubview(classes.verifyButton)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(true) {
                usleep(1000000)
                if(classes.canContinue) {
                    self.initApp()
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        for var i = 0; i < classes.manage.waypoints.count; i++ {
                            self.view.addSubview(classes.manage.waypoints[i])
                        }
                        classes.addButton.removeFromSuperview()
                        self.view.addSubview(classes.addButton)
                    }
                }
            }
        }
    }
    
    func updateWaypoints() {
        classes.manage.orderWaypoints()
        for var i = 0; i < classes.manage.waypoints.count; i++ {
            self.view.addSubview(classes.manage.waypoints[i])
        }
        
    }
    
    func initApp() {
        if(classes.timesInitRun == 0) {
            usleep(200000)
            classes.verifyButton.removeFromSuperview()
            classes.timesInitRun += 1
        }
        
    }
    
    func calibrateCardnalDirection() -> Bool {
        
        return false;
    }
    
    func editAddButton(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(classes.addButton)
        } else {
            classes.addButton.removeFromSuperview()
        }
    }
    
    func editWaypointEditor(toAddOrRemove : Bool) {
        if(toAddOrRemove) {
            //Make it slide in
            //Tell the editor which waypoint you are changing, or if you are adding
        } else {
            //Make it slide out
        }
    }
    
    func initCameraFeed() {
        let captureSession = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        if let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            var err: NSError? = nil
            classes.cameraAngle = Double(videoDevice.activeFormat.videoFieldOfView)
            println(classes.cameraAngle)
            if let videoIn : AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &err) as? AVCaptureDeviceInput {
                if(err == nil){
                    if (captureSession.canAddInput(videoIn as AVCaptureInput)){
                        captureSession.addInput(videoIn as AVCaptureDeviceInput)
                    }
                    else {
                    }
                }
                else {
                }
            }
            else {
            }
        }
        captureSession.startRunning()
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
    }
    
    
}


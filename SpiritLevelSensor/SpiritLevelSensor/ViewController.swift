//
//  ViewController.swift
//  SpiritLevelSensor
//
//  Created by Michal Moravík on 11/04/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox

class ViewController: UIViewController {
    
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rotation
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        valueLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        motionSetup()
    }
    
    func motionSetup() {
        motionManager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            print(motion?.attitude.pitch ?? "")
            
            DispatchQueue.main.async {
                self.slider.value = Float((motion?.attitude.pitch ?? 0) + 0.5) // 0.5 is the initial value and the value where tracking of pitch starts. If you want to start from the beginning of slider, delete 0.5
                
                // calculation, formation, and setting this as a label value
                let integerValue = motion!.attitude.pitch * 10
                let integerValueWithoutDecimals = Double(round(10*integerValue)/10) // 10 means only one decimal number... 100 means 2, etc.
                self.valueLabel.text = String(abs(integerValueWithoutDecimals)) // abs makes absolute number - convert minus value to absolute (only plus number)
            }
        }
                           }
}


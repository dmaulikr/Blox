//
//  levels.swift
//  Blox
//
//  Created by Jeffrey Li on 1/4/17.
//  Copyright © 2017 Jeffrey Li. All rights reserved.
//

import Foundation
import UIKit

class levels: UIViewController{
    
    @IBOutlet weak var level1button: UIButton!
    @IBOutlet weak var level2button: UIButton!
    @IBOutlet weak var level3button: UIButton!
    @IBOutlet weak var level4button: UIButton!
    @IBOutlet weak var level5button: UIButton!
    @IBOutlet weak var level6button: UIButton!
    @IBOutlet weak var level7button: UIButton!
    @IBOutlet weak var level8button: UIButton!
    @IBOutlet weak var level9button: UIButton!
    @IBOutlet weak var level10button: UIButton!
    
    
    let slideAnimator = slideAnimateLeft()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        level1button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
        level1button.isEnabled = true
        if (defaults.value(forKey: "level1") != nil) {
            level1button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level1button.isEnabled = true
        }
        if (defaults.value(forKey: "level1") != nil) {
            level2button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level2button.isEnabled = true
        }
        if (defaults.value(forKey: "level2") != nil) {
            level3button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level3button.isEnabled = true
        }
        if (defaults.value(forKey: "level3") != nil) {
            level4button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level4button.isEnabled = true
        }
        if (defaults.value(forKey: "level4") != nil) {
            level5button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level5button.isEnabled = true
        }
        if (defaults.value(forKey: "level5") != nil) {
            level6button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level6button.isEnabled = true
        }
        if (defaults.value(forKey: "level6") != nil) {
            level7button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level7button.isEnabled = true
        }
        if (defaults.value(forKey: "level7") != nil) {
            level8button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level8button.isEnabled = true
        }
        if (defaults.value(forKey: "level8") != nil) {
            level9button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level9button.isEnabled = true
        }
        if (defaults.value(forKey: "level9") != nil) {
            level10button.backgroundColor = UIColor(red: 26/255, green: 193/255, blue: 124/255, alpha: 1)
            level10button.isEnabled = true
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        destination.transitioningDelegate = slideAnimator
    }
    
    @IBAction func reset(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        for key in Array(defaults.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        //print(defaults.bool(forKey: "level1"))
        
    }
    
    //40001 are blocks connected
    //4 are separate blocks
    //1111 are spiked blocks (1 are the spikes and 9 are non) up, right, down, left
    //1 is wall
    //0 is ground
    //2 is goal
    //3 is player
    
    struct Static {
        static var level1 = [ [1, 1, 1, 9919, 1, 1, 1, 1, 1, 1, 1, 1],
                              [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                              [9199, 0, 3, 4, 4, 0, 0, 0, 0, 2, 0, 9991],
                              [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1],
                              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
        
        static var level2 = [ [-1, -1, -1, 1, 1, 1, -1, -1],
                              [-1, -1, 1, 0, 0, 0, 1, -1],
                              [-1, 1, 0, 0, 3, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 1],
                              [-1, 1, 0, 0, 1, 0, 1, -1],
                              [-1, -1, 1, 1, 1, 0, 1, -1],
                              [-1, -1, -1, -1, 1, 0, 1, -1],
                              [-1, -1, 1, 1, 1, 0, 1, -1],
                              [-1, 1, 2, 0, 0, 0, 1, -1],
                              [-1, -1, 1, 1, 1, 1, 1, -1]]
        
        static var level3 = [ [1, 1, 1, 1, 1],
                              [1, 0, 2, 0, 1],
                              [1, 0, 2, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 3, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1],
                              [1, 0, 4, 0, 1],
                              [1, 1, 1, 1, 1] ]
        
        static var level4 = [ [1, 1, 1, -1, -1, -1, -1],
                              [1, 2, 1, -1, -1, -1, -1],
                              [1, 2, 1, 1, 1, 1, 1],
                              [1, 2, 1, 4, 0, 0, 1],
                              [1, 2, 1, 0, 0, 0, 1],
                              [1, 3, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1, 0, 1],
                              [1, 4, 0, 0, 1, 4, 1],
                              [1, 1, 1, 1, 1, 1, 1]]
        
        static var level5 = [ [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                              [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 3, 0, 1, 0, 0, 1],
                              [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
                              [1, 0, 0, 2, 0, 1, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
        
        static var level6 = [ [-1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1],
                              [1, 2, 2, 2, 0, 0, 0, 0, 0, 1, 0, 1],
                              [1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
                              [1, 0, 0, 4, 0, 0, 0, 3, 0, 0, 4, 1],
                              [1, 0, 0, 4, 1, 0, 0, 0, 0, 0, 4, 1],
                              [-1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, -1],
                              [-1, -1, 1, 1, 1, 0, 0, 0, 0, 1, -1, -1],
                              [-1, -1, -1, -1, -1, 1, 1, 1, 1, -1, -1, -1]]
        
        static var level7 = [ [-1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                              [-1, -1, 1, 0 ,0, 0, 0, 40001, 40001, 0, 0, 40002, 40002, 1],
                              [-1, 1, 0, 0 ,0, 0, 0, 40001, 0, 0, 0, 0, 40002, 1],
                              [1, 0, 0, 0 ,0, 0, 0, 40001, 0, 0, 0, 0, 40002, 1],
                              [1, 2, 2, 2 ,2, 2, 0, 40001, 0, 0, 0, 0, 40002, 1],
                              [1, 2, 0, 0 ,0, 2, 0, 40001, 40001, 40001, 0, 40002, 40002, 1],
                              [1, 2, 0, 3 ,0, 2, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 2, 0, 0 ,0, 2, 0, 0, 0, 0, 0, 0, 1, -1],
                              [1, 2, 2, 2 ,2, 2, 0, 0, 0, 0, 0, 1, -1, -1],
                              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1]]
        
        static var level8 = [ [-1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1],
                              [-1, -1, 1, 0, 0, 0, 0, 0, 0, 1, -1, -1],
                              [-1, 1, 0, 0, 0, 0, 0, 0, 0, 4, 1, -1],
                              [1, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 2, 0, 0, 0, 0, 1, 0, 1, 1],
                              [-1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, -1],
                              [-1, -1, 1, 0, 0, 1, 0,  0, 0, 1, -1, -1],
                              [-1, -1, -1, 1, 1, 1, 1, 1, 1, -1, -1, -1]]
        
        static var level9 = [ [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                              [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1],
                              [1, 0, 2, 0, 0, 0, 0, 0, 4, 0, 0, 1],
                              [1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                              [1, 0, 2, 2, 0, 3, 0, 0, 4, 0, 0, 1],
                              [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1],
                              [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
        
        static var level10 = [[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1],
                              [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
                              [1, 0, 0, 4, 0, 4, 4, 0, 0, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1],
                              [1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 1],
                              [1, 0, 0, 0, 0, 3, 0, 0, 2, 0, 0, 1],
                              [-1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, -1],
                              [-1, -1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1]]
    }
}


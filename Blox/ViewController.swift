//
//  ViewController.swift
//  Blox
//
//  Created by Jeffrey Li on 1/4/17.
//  Copyright © 2017 Jeffrey Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func open(_ sender: Any) {
        let defaults = UserDefaults.standard
        var stringBuild = "level"
        
        var levelNum = 1
        
        if (defaults.value(forKey: "maxLevel") == nil) {
            defaults.set(1, forKey: "maxLevel")
        }
        else {
            levelNum = defaults.integer(forKey: "maxLevel")
        }
        
        print(levelNum)
        stringBuild += String(levelNum)
        stringBuild += "id"
        
        let controller = (self.storyboard?.instantiateViewController(withIdentifier: stringBuild))! as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    let slideAnimator = slideAnimate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

}


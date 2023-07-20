//
//  ViewController.swift
//  CustomUISwitch
//
//  Created by ZEUS on 20/7/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewCustomSwitch: CustomSwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomSwitch.areLabelsShown = true
        viewCustomSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    @objc func switchValueChanged(_ customSwitch: CustomSwitch){
        if customSwitch.isOn{
            print("Custom Switch is on")
        }else{
            print("Custom Switch is off")
        }
    }

}


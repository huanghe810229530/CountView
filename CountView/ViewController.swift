//
//  ViewController.swift
//  CountView
//
//  Created by huanghe on 5/3/16.
//  Copyright © 2016 HCFData. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let frame = CGRect(x: 100, y: 200, width: 140, height: 44)
        let aview = CounterView(frame: frame)
        aview.minValue = 8
        aview.maxValue = 987
        aview.styleLineColor = UIColor.lightGrayColor()
//        aview.countControlSideLength = 30
        aview.hightlightColor = UIColor.lightGrayColor()
        aview.valueChanged = { d in
            print("changed to value: \(d)")
        }

        view.addSubview(aview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


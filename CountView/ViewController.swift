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
        let frame = CGRect(x: 100, y: 200, width: 120, height: 44)
        let aview = CounterView(frame: frame, maxValue: 666, minValue: 2)
        aview.styleColor = UIColor(red: 100/255.0, green: 200/255.0, blue: 100/255.0, alpha: 1)
        aview.countControlSideLength = 30
        aview.hightlightColor = UIColor.redColor()
        view.addSubview(aview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


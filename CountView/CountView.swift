//
//  CountView.swift
//  CountView
//
//  Created by huanghe on 5/3/16.
//  Copyright © 2016 HCFData. All rights reserved.
//

import UIKit

class CounterView: UIView, UITextFieldDelegate {
    
    var minValue: Int = 1
    var maxValue: Int = 999
    private(set) var currentValue = 1
    
    var hGap: CGFloat = 2
    var vGap: CGFloat = 2
    
    
    var countControlSideLength: CGFloat = 40 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var styleColor: UIColor = UIColor.blackColor() {
        didSet {
            addControl.lineColor = styleColor
            plusControl.lineColor = styleColor
            setNeedsDisplay()
        }
    }
    
    var hightlightColor: UIColor = UIColor(white: 0.8, alpha: 1) {
        didSet {
            addControl.hightlightColor = hightlightColor
            plusControl.hightlightColor = hightlightColor
            setNeedsDisplay()
        }
    }
    
    var lineWidth: CGFloat = 1 {
        didSet {
            addControl.lineWidth = lineWidth
            plusControl.lineWidth = lineWidth
            setNeedsDisplay()
        }
    }
    
    
    private var addControl: CountControl!
    private var plusControl: CountControl!
    private var textfield: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        let contidion = (frame.size.width >= 120 && frame.size.height >= 40)
        precondition(contidion, "frame too small")
        
        configureSubViews()
    }
    
    convenience init(frame: CGRect, maxValue: Int, minValue: Int) {
        self.init(frame: frame)
        self.maxValue = maxValue
        self.minValue = minValue
        currentValue = minValue
    }
    
    private func configureSubViews() {
        
        plusControl = CountControl(type: .System)
        plusControl.addTarget(self, action: #selector(CounterView.add(_:)), forControlEvents: .TouchUpInside)

        addControl = CountControl(type: .System)
        addControl.isAddButton = true
        addControl.addTarget(self, action: #selector(CounterView.add(_:)), forControlEvents: .TouchUpInside)
        
        textfield = UITextField()
        textfield.textAlignment = .Center
        textfield.keyboardType = .NumberPad
        textfield.delegate = self
        
        addSubview(plusControl)
        addSubview(addControl)
        addSubview(textfield)
    }
    
    func add(btn: UIButton)  {
        if  btn == plusControl {
            currentValue = currentValue <= minValue ? minValue : currentValue - 1
        }else {
            currentValue = currentValue >= maxValue ? maxValue : currentValue + 1
        }
        textfield.text = String(currentValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if countControlSideLength > bounds.size.height {
            countControlSideLength = bounds.size.height
        }
        
        plusControl.frame = CGRect(x: hGap,
                                   y: bounds.size.height / 2 - countControlSideLength / 2,
                                   width: countControlSideLength,
                                   height: countControlSideLength)
        addControl.frame = CGRect(x: bounds.size.width - CGRectGetWidth(plusControl.frame) - hGap,
                                  y: CGRectGetMinY(plusControl.frame),
                                  width: CGRectGetWidth(plusControl.frame),
                                  height: CGRectGetHeight(plusControl.frame))
        let rect = CGRect(x: CGRectGetMaxX(plusControl.frame),
                          y: CGRectGetMinY(plusControl.frame),
                          width: CGRectGetWidth(bounds) - 2 * countControlSideLength - 2 * hGap,
                          height: countControlSideLength)
        textfield.frame = rect
        textfield.text = String(currentValue)
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        styleColor.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.moveToPoint(CGPoint(x: CGRectGetMinX(textfield.frame), y: CGRectGetMinY(plusControl.frame)+1))
        path.addLineToPoint(CGPoint(x: CGRectGetMaxX(textfield.frame), y: CGRectGetMinY(plusControl.frame)+1))
        path.moveToPoint(CGPoint(x: CGRectGetMinX(textfield.frame), y: CGRectGetMaxY(plusControl.frame)-1))
        path.addLineToPoint(CGPoint(x: CGRectGetMaxX(textfield.frame), y: CGRectGetMaxY(plusControl.frame)-1))
        path.stroke()
    }
 
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if  Int(string) == nil && string != "" { // 输入非数字字符
            return false
        }
        
        if string == "" { // 删除字符
            if let text = textfield.text {
                
                let tx = text as NSString
                let value = tx.substringToIndex(range.location)
                if let x = Int(value as String) {
                    currentValue = x
                }else {
                    currentValue = minValue
                }
            }
            
            return true
        }
        
        if let str = textfield.text {
            
            if Int(str) > maxValue {
                return false
            }
            let final = Int(str + string)! // 最终字符串转Int
            if final > maxValue {
                return false
            }
            currentValue = final
        }else {
            currentValue = Int(string)!
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textfield.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0  {
            currentValue = Int(textField.text!)!
        }
    }
}

@IBDesignable
class CountControl: UIButton {
    
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    @IBInspectable private var fillColor: UIColor = UIColor.clearColor()
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var isAddButton: Bool = false
    var hightlightColor: UIColor = UIColor(white: 0.8, alpha: 1)
    
    override func drawRect(rect: CGRect) {
        lineColor.setStroke()
        fillColor.setFill()
        
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = lineWidth
        path.stroke()
        
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        path.lineWidth = plusHeight
        
        path.moveToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2,
            y:bounds.height/2))
        
        path.addLineToPoint(CGPoint(
            x:bounds.width/2 + plusWidth/2,
            y:bounds.height/2))
        
        if isAddButton {
            path.moveToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 - plusWidth/2 + 0.5))
            
            path.addLineToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 + plusWidth/2 + 0.5))
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        if tracking {
            CGContextSetFillColorWithColor(ctx, hightlightColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
        }

        path.stroke()
        path.fill()
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !highlighted {
            highlighted = true
            setNeedsDisplay()
        }
        return highlighted
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        highlighted = false
        setNeedsDisplay()
    }
}

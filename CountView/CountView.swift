//
//  CountView.swift
//  CountView
//
//  Created by huanghe on 10/3/16.
//  Copyright © 2016 HCFData. All rights reserved.
//

import UIKit

/// a Control for count add/plus
public class CounterView: UIView, UITextFieldDelegate {
    
    public var minValue: Int = 1
    public var maxValue: Int = 99
    
    /// a block invoke by value changed
    public var valueChanged: ((value: Int) -> Void)?
    
    private(set) var currentValue = 1 {
        
        didSet {
            guard currentValue != oldValue else { return }
            
            if currentValue <= minValue {
                plusControl.enabled = false
            }else if currentValue == maxValue {
                addControl.enabled = false
            }else {
                plusControl.enabled = true
                addControl.enabled = true
            }
            
            valueChanged?(value: currentValue)
        }
    }
    
    /// 边框颜色
    var styleLineColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            addControl.lineColor = styleLineColor
            plusControl.lineColor = styleLineColor
        }
    }
    
    /// 风格颜色
    var styleColer: UIColor = UIColor.blackColor() {
        didSet {
            addControl.plusColor = styleColer
            plusControl.plusColor = styleColer
            textfield.textColor = styleColer
        }
    }
    
    /// 边框宽度
    var lineWidth: CGFloat = 1 {
        didSet {
            addControl.lineWidth = lineWidth
            plusControl.lineWidth = lineWidth
        }
    }
    /// 加减控件的加减线条宽度
    var plusWidth: CGFloat = 2
    
    /// 点击的高亮颜色
    var hightlightColor: UIColor = UIColor(white: 0.8, alpha: 1) {
        didSet {
            addControl.hightlightColor = hightlightColor
            plusControl.hightlightColor = hightlightColor
        }
    }
    
    /// 加减控件边长
    var countControlSideLength: CGFloat = 40
    
    //MARK: - Private properties
    /// 加号控件距离父视图的水平距离
    private var hGap: CGFloat = 2
    /// 加号控件距离父视图的垂直距离
    private var vGap: CGFloat = 2
    /// textField距离加减控件的左右边距
    private var filedGap: CGFloat = 5
    
    private var addControl: CountControl!
    private var plusControl: CountControl!
    private var textfield: UITextField!
    
    
    //MARK: - Initerlizers
    convenience required public init(frame: CGRect, maxValue: Int, minValue: Int) {
        self.init(frame: frame)
        
        self.maxValue = maxValue
        self.minValue = minValue
        currentValue = minValue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureSubViews()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    public func changeCurrentValueTo(newValue: Int) {
        currentValue = newValue
        textfield.text = String(newValue)
    }
    
    //MARK: - Privates Methods
    private func configureSubViews() {
        
        plusControl = CountControl(type: .System)
        plusControl.addTarget(self, action: #selector(CounterView.addOrPlus(_:)), forControlEvents: .TouchUpInside)
        plusControl.enabled = false
        
        addControl = CountControl(type: .System)
        addControl.isAddButton = true
        addControl.addTarget(self, action: #selector(CounterView.addOrPlus(_:)), forControlEvents: .TouchUpInside)
        
        textfield = UITextField()
        textfield.textAlignment = .Center
        textfield.layer.borderWidth = 1
        textfield.keyboardType = .NumberPad
        textfield.delegate = self
        
        addSubview(plusControl)
        addSubview(addControl)
        addSubview(textfield)
    }
    
    //MARK: - UIActions
    func addOrPlus(btn: UIButton)  {
        if  btn == plusControl {
            currentValue = currentValue <= minValue ? minValue : currentValue - 1
        }else {
            currentValue = currentValue >= maxValue ? maxValue : currentValue + 1
        }
        textfield.text = String(currentValue)
    }
    
    //MARK: - Overrides Methods
    override public func layoutSubviews() {
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
        let rect = CGRect(x: CGRectGetMaxX(plusControl.frame) + filedGap,
                          y: CGRectGetMinY(plusControl.frame),
                          width: CGRectGetWidth(bounds) - 2 * countControlSideLength - 2 * hGap - 2 * filedGap,
                          height: countControlSideLength)
        textfield.frame = rect
        textfield.text = String(currentValue)
        textfield.layer.borderColor = styleLineColor.CGColor
    }
    
    // MARK: - UITextFieldDelegate
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
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
            
            if Int(string) == 0 && str.isEmpty {
                return false
            }
            
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
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if textfield.text?.isEmpty == false {
            currentValue = Int(textField.text!)!
        }else {
            textField.text = String(currentValue)
        }
    }
}

@IBDesignable
/// a control can plus or add
class CountControl: UIButton {
    
    /// 线框颜色
    @IBInspectable var lineColor: UIColor = UIColor.lightGrayColor()
    /// 加减按钮颜色
    @IBInspectable var plusColor: UIColor = UIColor.blackColor()
    /// 线框宽度
    @IBInspectable var lineWidth: CGFloat = 2
    /// 加减号按钮宽度
    @IBInspectable var plusWidth: CGFloat = 2
    /// 是否是加号控件，否则是减号控件
    @IBInspectable var isAddButton: Bool = false
    /// 点击后的高亮颜色
    var hightlightColor: UIColor = UIColor(white: 0.8, alpha: 1)
    
    
    @IBInspectable private var fillColor: UIColor = UIColor.clearColor()
    
    override func drawRect(rect: CGRect) {
        
        lineColor.setStroke()
        fillColor.setFill()
        
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = lineWidth
        path.stroke()
        path.closePath()
        
        let plusPath = UIBezierPath()
        let theplusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        plusPath.lineWidth = plusWidth
        
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 - theplusWidth/2,
            y:bounds.height/2))
        
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + theplusWidth/2,
            y:bounds.height/2))
        
        if isAddButton {
            plusPath.moveToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 - theplusWidth/2 + 0.5))
            
            plusPath.addLineToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 + theplusWidth/2 + 0.5))
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        if tracking {
            CGContextSetFillColorWithColor(ctx, hightlightColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
        }
        
        if enabled {
            plusColor.setStroke()
        }else {
            UIColor.lightGrayColor().setStroke()
        }
        
        plusPath.stroke()
        path.appendPath(plusPath)
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

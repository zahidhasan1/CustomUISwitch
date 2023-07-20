//
//  CustomSwitch.swift
//  CustomUISwitch
//
//  Created by ZEUS on 20/7/23.
//

import UIKit

@IBDesignable
class CustomSwitch: UIControl{
    
    @IBInspectable public var onTintColor: UIColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1){
        didSet{
            self.layoutSubviews()
        }
    }
    
    @IBInspectable public var offTintColor: UIColor = UIColor.lightGray{
        didSet{
            self.layoutSubviews()
        }
    }
    
    //View Corner Radius
    @IBInspectable public var cornerRadius: CGFloat{
        get{
            return self.privateCornerRadius
        }set{
            if newValue > 0.5 || newValue < 0.0 {
                privateCornerRadius = 0.5
            }else{
                privateCornerRadius = newValue
            }
        }
    }
    private var privateCornerRadius: CGFloat = 0.5{
        didSet{
            self.layoutSubviews()
        }
    }
    
    //ThumbCornerRadius
    @IBInspectable public var thumbCornerRadius: CGFloat{
        get{
            return self.privateThumbCornerRadius
        }set{
            if newValue > 0.5 || newValue < 0.0{
                privateThumbCornerRadius = 0.5
            }else{
                privateThumbCornerRadius = newValue
            }
        }
    }
    private var privateThumbCornerRadius: CGFloat = 0.5{
        didSet{
            self.layoutSubviews()
        }
    }
    
    
    //MARK: - ThumbView Prop.
    @IBInspectable public var thumbTintColor: UIColor = UIColor.white{
        didSet{
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    public var thumbSize = CGSize.zero{
        didSet{
            self.layoutSubviews()
        }
    }
    @IBInspectable public var padding: CGFloat = 1{
        didSet{
            self.layoutSubviews()
        }
    }
    @IBInspectable public var shadowColor: UIColor = UIColor.black{
        didSet{
            self.thumbView.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    @IBInspectable public var shadowRadius: CGFloat = 1.5{
        didSet{
            self.thumbView.layer.shadowRadius = self.shadowRadius
        }
    }
    @IBInspectable public var shadowOpacity: Float = 0.5{
        didSet{
            self.thumbView.layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    //MARK: - Setup ThumbviewImgae
    @IBInspectable public var thumbImage: UIImage?{
        didSet{
            thumbView.thumbImageView.image = thumbImage
        }
    }
    
    //MARK: - Labels
    public var labelOff: UILabel = UILabel()
    public var labelOn: UILabel = UILabel()
    public var areLabelsShown: Bool = false{
        didSet{
            self.setupUI()
        }
    }
    
    public var isOn: Bool = true
    
    public var animationDuration = 0.5
    
    //MARK: - FilePrivate Prop.
    //fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var thumbView = CustomThumbView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    fileprivate func setupLabel(){
        guard self.areLabelsShown else{
            self.labelOff.alpha = 0
            self.labelOn.alpha = 0
            return
        }
        
        self.labelOff.alpha = 1
        self.labelOn.alpha = 1
        let labelWidth = self.bounds.width / 2 - self.padding * 2
        self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        self.labelOn.font = UIFont.boldSystemFont(ofSize: 12)
        self.labelOff.font = UIFont.boldSystemFont(ofSize: 12)
        self.labelOn.textColor = UIColor.white
        self.labelOff.textColor = UIColor.white
        self.labelOff.sizeToFit()
        self.labelOff.text = "Off"
        self.labelOn.text = "On"
        self.labelOff.textAlignment = .center
        self.labelOn.textAlignment = .center
        self.insertSubview(self.labelOff, belowSubview: self.thumbView)
        self.insertSubview(self.labelOn, belowSubview: self.thumbView)
    }
    
    //MARK: -
    
    //MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    //MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.privateCornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            // thumb managment
            
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                                                                                        self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * privateThumbCornerRadius
            
        }
        //label frame
        if self.areLabelsShown {
            setupLabel()
            let labelWidth = self.bounds.width / 2 - self.padding * 2
            self.labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
            self.labelOff.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
    //MARK: - Private Method
    private func clear (){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    //MARK: - Setup UI
    func setupUI(){
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.thumbView.layer.shadowColor = self.shadowColor.cgColor
        self.thumbView.layer.shadowRadius = shadowRadius
        self.thumbView.layer.shadowOpacity = shadowOpacity
        self.thumbView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        //self.thumbView.thumbImageView.image = thumbImage
        self.addSubview(self.thumbView)
    }
    

    

    
    
}

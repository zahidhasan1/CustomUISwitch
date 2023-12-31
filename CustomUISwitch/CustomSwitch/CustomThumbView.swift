//
//  CustomThumbView.swift
//  CustomUISwitch
//
//  Created by ZEUS on 20/7/23.
//

import UIKit

class CustomThumbView: UIView{
    fileprivate(set) var thumbImageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addSubview(self.thumbImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubview(self.thumbImageView)
    }
}

extension CustomThumbView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.thumbImageView.layer.cornerRadius = self.layer.cornerRadius
        self.thumbImageView.clipsToBounds = self.clipsToBounds
    }
}

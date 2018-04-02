//
//  ErrorMessageView.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/15/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit

public class FxErrorMessageView: UIView {

    public weak var label: UILabel?

    convenience init(with text:String, color:UIColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        initCommon(with: text, color:color)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon(with: "", color:nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon(with: "", color:nil)
    }

    public func initCommon(with text:String, color:UIColor?) {
        // create background
        if let color = color {
            self.backgroundColor = color
        }
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false

        // create message
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        // constraints
        let margins = self.layoutMarginsGuide
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        self.label = label
    }

}

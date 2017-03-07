//
//  FormTextField.swift
//  Darts301
//
//  Created by Greg Haines on 3/6/17.
//  Copyright © 2017 Aly & Friends. All rights reserved.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

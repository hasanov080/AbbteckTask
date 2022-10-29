//
//  Extensions.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import UIKit
extension UIView{
    @IBInspectable
    var cornerradius: CGFloat{
        get{
            self.layer.cornerRadius
        }set{
            self.layer.cornerRadius = newValue
        }
    }
}
extension String{
    func getSize(with attributes: [NSAttributedString.Key: Any]?) -> CGSize{
        let size = NSString(string: self).size(withAttributes: attributes)
        return size
    }
}
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

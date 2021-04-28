//
//  UIView.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/28.
//

import UIKit

extension UIView {
    
    func makeEdges(cornerRadius: CGFloat, borderWidth: CGFloat, _ color: CGColor = UIColor.white.cgColor) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = color
    }
    
    func makeShadow(opacity: Float, radius: CGFloat, _ color: CGColor = UIColor.systemGray4.withAlphaComponent(0.7).cgColor) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func makeShadowWithCAShapeLayer(roundedRect: CGRect, opacity: Float, radius: CGFloat) {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: radius).cgPath
        shadowLayer.fillColor = UIColor.black.cgColor

        shadowLayer.shadowColor = UIColor.systemGray4.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius

        layer.insertSublayer(shadowLayer, at: 0)
    }
}

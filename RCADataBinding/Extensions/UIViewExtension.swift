//
//  UIViewExtension.swift
//  RCADataBinding
//
//  Created by Rafael Couto Estrela on 04/10/19.
//  Copyright © 2019 RCA Digital. All rights reserved.
//

import Foundation
import UIKit

enum ComplexAnchor {
    case greater
    case less
}

enum AnchorType {
    case top
    case bottom
    case leading
    case trailing
    case heigth
    case width
    case centerX
    case centerY
}

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    func applyAnchors(ofType: [AnchorType], equalTo referenceView: UIView) {
        
        if ofType.contains(.bottom) {
            self.bottomAnchor.constraint(equalTo: referenceView.bottomAnchor).isActive = true
        }
        
        if ofType.contains(.top) {
            self.topAnchor.constraint(equalTo: referenceView.topAnchor).isActive = true
        }
        
        if ofType.contains(.trailing) {
            self.trailingAnchor.constraint(equalTo: referenceView.trailingAnchor).isActive = true
        }
        
        if ofType.contains(.leading) {
            self.leadingAnchor.constraint(equalTo: referenceView.leadingAnchor).isActive = true
        }
        
        if ofType.contains(.heigth) {
            self.heightAnchor.constraint(equalTo: referenceView.heightAnchor).isActive = true
        }
        
        if ofType.contains(.width) {
            self.widthAnchor.constraint(equalTo: referenceView.widthAnchor).isActive = true
        }
        
        if ofType.contains(.centerX) {
            self.centerXAnchor.constraint(equalTo: referenceView.centerXAnchor).isActive = true
        }
        if ofType.contains(.centerY) {
            self.centerYAnchor.constraint(equalTo: referenceView.centerYAnchor).isActive = true
        }
    }
    
    func applyTopAnchor(to: NSLayoutYAxisAnchor, padding: CGFloat? , type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.topAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.topAnchor.constraint(lessThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            }
        } else {
            self.topAnchor.constraint(equalTo: to, constant: padding ?? 0).isActive = true
        }
    }
    
    func applyBottomAnchor(to: NSLayoutYAxisAnchor, padding: CGFloat?, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.bottomAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.bottomAnchor.constraint(lessThanOrEqualTo: to, constant: -(padding ?? 0)).isActive = true
            }
        } else {
            self.bottomAnchor.constraint(equalTo: to, constant: -(padding ?? 0)).isActive = true
        }
    }
    
    func applyLeadingAnchor(to: NSLayoutXAxisAnchor, padding: CGFloat, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.leadingAnchor.constraint(greaterThanOrEqualTo: to, constant: padding).isActive = true
            case .less:
                self.leadingAnchor.constraint(lessThanOrEqualTo: to, constant: padding).isActive = true
            }
        } else {
            self.leadingAnchor.constraint(equalTo: to, constant: padding).isActive = true
        }
    }
    
    func applyTrailingAnchor(to: NSLayoutXAxisAnchor, padding: CGFloat?, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.trailingAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.trailingAnchor.constraint(lessThanOrEqualTo: to, constant: -(padding ?? 0)).isActive = true
            }
        } else {
            self.trailingAnchor.constraint(equalTo: to, constant: -(padding ?? 0)).isActive = true
        }
    }
    
    func applyCenterX(to: UIView, padding: CGFloat? = 0) {
        
        centerXAnchor.constraint(equalTo: to.centerXAnchor,constant: padding ?? 0).isActive = true
    }
    
    func applyCenterY(to: UIView, padding: CGFloat?) {
        
        centerYAnchor.constraint(equalTo: to.centerYAnchor,constant: padding ?? 0).isActive = true
    }
    
    func heigth(equalTo heightValue: CGFloat) {
        
        self.heightAnchor.constraint(equalToConstant: heightValue).isActive = true
    }
    
    func width(equalTo widthValue: CGFloat) {
        
        self.widthAnchor.constraint(equalToConstant: widthValue).isActive = true
    }
    
    func sized(with size: CGSize) {
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    func anchorEqualTo(view: UIView) {
        
        self.applyAnchors(ofType: [.top, .bottom, .leading, .trailing], equalTo: view)
    }
    
    func anchorCenteredTo(view: UIView) {
        
        self.applyAnchors(ofType: [.centerX, .centerY], equalTo: view)
    }
}

//
//  UIView.swift
//  Places
//
//  Created by Matheus Dutra on 06/11/18.
//  Copyright � 2018 Matheus Dutra. All rights reserved.
//

extension UIView {
    
    
    
    func applyAnchors(ofType: [AnchorType], to referenceView: UIView) {
        
        if ofType.contains(.bottom) {
            self.bottomAnchor.constraint(equalTo: referenceView.bottomAnchor).isActive = true
        }
        
        if ofType.contains(.top) {
            self.topAnchor.constraint(equalTo: referenceView.topAnchor).isActive = true
        }
        
        if ofType.contains(.trailing) {
            self.trailingAnchor.constraint(equalTo: referenceView.trailingAnchor).isActive = true
        }
        
        if ofType.contains(.leading) {
            self.leadingAnchor.constraint(equalTo: referenceView.leadingAnchor).isActive = true
        }
        
        if ofType.contains(.heigth) {
            self.heightAnchor.constraint(equalTo: referenceView.heightAnchor).isActive = true
        }
        
        if ofType.contains(.width) {
            self.widthAnchor.constraint(equalTo: referenceView.widthAnchor).isActive = true
        }
        
        if ofType.contains(.centerX) {
            self.centerXAnchor.constraint(equalTo: referenceView.centerXAnchor).isActive = true
        }
        if ofType.contains(.centerY) {
            self.centerYAnchor.constraint(equalTo: referenceView.centerYAnchor).isActive = true
        }
    }
    
    func top(to: NSLayoutYAxisAnchor, padding: CGFloat? , type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.topAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.topAnchor.constraint(lessThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            }
        } else {
            self.topAnchor.constraint(equalTo: to, constant: padding ?? 0).isActive = true
        }
    }
    
    func bottom(to: NSLayoutYAxisAnchor, padding: CGFloat?, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.bottomAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.bottomAnchor.constraint(lessThanOrEqualTo: to, constant: -(padding ?? 0)).isActive = true
            }
        } else {
            self.bottomAnchor.constraint(equalTo: to, constant: -(padding ?? 0)).isActive = true
        }
    }
    
    func leading(to: NSLayoutXAxisAnchor, padding: CGFloat, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.leadingAnchor.constraint(greaterThanOrEqualTo: to, constant: padding).isActive = true
            case .less:
                self.leadingAnchor.constraint(lessThanOrEqualTo: to, constant: padding).isActive = true
            }
        } else {
            self.leadingAnchor.constraint(equalTo: to, constant: padding).isActive = true
        }
    }
    
    func trailing(to: NSLayoutXAxisAnchor, padding: CGFloat?, type: ComplexAnchor? = nil) {
        
        if let type = type {
            switch type {
            case .greater:
                self.trailingAnchor.constraint(greaterThanOrEqualTo: to, constant: padding ?? 0).isActive = true
            case .less:
                self.trailingAnchor.constraint(lessThanOrEqualTo: to, constant: -(padding ?? 0)).isActive = true
            }
        } else {
            self.trailingAnchor.constraint(equalTo: to, constant: -(padding ?? 0)).isActive = true
        }
    }
    
    func centerX(to: UIView, padding: CGFloat? = 0) {
        
        centerXAnchor.constraint(equalTo: to.centerXAnchor,constant: padding ?? 0).isActive = true
    }
    
    func centerY(to: UIView, padding: CGFloat? = 0) {
        
        centerYAnchor.constraint(equalTo: to.centerYAnchor,constant: padding ?? 0).isActive = true
    }
    
    func equalWidths(to view: UIView) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func anchors(equalTo view: UIView) {
        
        self.applyAnchors(ofType: [.top, .bottom, .leading, .trailing], to: view)
    }
    
    func center(to view: UIView) {
        
        self.applyAnchors(ofType: [.centerX, .centerY], to: view)
    }
}

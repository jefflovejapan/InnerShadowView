//
//  InnerShadowView.swift
//  DualShadowView
//
//  Created by Jeffrey Blagdon on 2020-05-21.
//  Copyright © 2020 polyergy. All rights reserved.
//

import UIKit
import CoreGraphics

extension Shadow {
    static let defaultShadow = Shadow(
        color: .black,
        opacity: 1,
        offset: CGSize(width: 5, height: 5),
        radius: 8
    )
    static let defaultHighlight = Shadow(
        color: .white,
        opacity: 1,
        offset: CGSize(width: -5, height: -5),
        radius: 8
    )
}

struct Shadow {
    var color: UIColor // Layers use CGColors but this might reduce light/dark boilerplate
    var opacity: Float
    var offset: CGSize
    var radius: CGFloat
}


extension CGContext {
    func perform(stuff: (CGContext) -> Void) {
        self.saveGState()
        stuff(self)
        self.restoreGState()
    }

    func inTransparencyLayer(stuff: (CGContext) -> Void) {
        self.beginTransparencyLayer(auxiliaryInfo: nil)
        stuff(self)
        self.endTransparencyLayer()
    }
}

class InnerShadowView: UIView {
    var path: UIBezierPath = UIBezierPath(rect: .zero) {
        didSet {
            setNeedsDisplay()
        }
    }

    var shadow: Shadow = .defaultShadow {
        didSet {
            setNeedsDisplay()
        }
    }

    var highlight: Shadow = .defaultHighlight {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        drawInnerShadow(in: ctx, path: path, shadow: shadow)
        drawInnerShadow(in: ctx, path: path, shadow: highlight)
    }

    // https://blog.helftone.com/demystifying-inner-shadows-in-quartz/
    private func drawInnerShadow(in context: CGContext, path: UIBezierPath, shadow: Shadow) {
        context.perform { ctx in
            ctx.addPath(path.cgPath)
            ctx.clip()
            let shadowColor = shadow.color.withAlphaComponent(1).cgColor
            ctx.setAlpha(shadowColor.alpha)
            ctx.inTransparencyLayer { ctx in
                ctx.setShadow(offset: shadow.offset, blur: shadow.radius, color: shadowColor)
                ctx.setBlendMode(.sourceOut)
                ctx.setFillColor(shadowColor)
                ctx.addPath(path.cgPath)
                ctx.fillPath()
            }
        }
    }
}

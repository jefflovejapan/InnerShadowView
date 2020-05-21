//
//  ViewController.swift
//  InnerShadowView
//
//  Created by Jeffrey Blagdon on 2020-05-21.
//  Copyright © 2020 polyergy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let shadowView = InnerShadowView()
    let smallShadow = Shadow(color: .black, opacity: 1, offset: CGSize(width: 10, height: 10), radius: 10)
    let bigShadow = Shadow(color: .black, opacity: 1, offset: CGSize(width: 20, height: 20), radius: 20)
    let smallHighlight = Shadow(color: .white, opacity: 1, offset: CGSize(width: -10, height: -10), radius: 10)
    let bigHighlight = Shadow(color: .white, opacity: 1, offset: CGSize(width: -20, height: -20), radius: 20)

    var areShadowsBig = false {
        didSet {
            updateShadows(areShadowsBig: areShadowsBig)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        shadowView.backgroundColor = .red
        updateShadows(areShadowsBig: areShadowsBig)

        let tgr = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        shadowView.addGestureRecognizer(tgr)
    }

    @objc private func viewTapped() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.areShadowsBig.toggle()
        }
    }

    private func updateShadows(areShadowsBig: Bool) {
        if areShadowsBig {
            shadowView.shadow = bigShadow
            shadowView.highlight = bigHighlight
        } else {
            shadowView.shadow = smallShadow
            shadowView.highlight = smallHighlight
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerWidth = shadowView.frame.height / 2
        shadowView.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerWidth, height: cornerWidth))
    }


}


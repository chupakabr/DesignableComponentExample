//
//  MyDesignableComponent.swift
//  DesignableComponent
//
//  Created by Valerii Chevtaev on 10/04/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

@IBDesignable
class MyDesignableComponent: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupViews()
        setupRevealOnTap()
        setupRelealOnSwipeIfNeeded()
    }

    // MARK: - Inspectables

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var canSwipeToReveal: Bool = false {
        didSet {
            guard oldValue != canSwipeToReveal else { return }
            setupRelealOnSwipeIfNeeded()
        }
    }

    @IBInspectable
    var showRevealed: Bool = false {
        didSet {
            #if TARGET_INTERFACE_BUILDER
                linkLabel.alpha = showRevealed ? 1.0 : 0.0
            #endif
        }
    }

    @IBInspectable
    var titleText: String = "Tap to reveal" {
        didSet {
            titleLabel.text = titleText
        }
    }

    @IBInspectable
    var linkText: String = "http://badoo.com" {
        didSet {
            linkLabel.text = linkText
        }
    }

    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            titleLabel.textColor = textColor
        }
    }

    @IBInspectable
    var linkColor: UIColor = .purple {
        didSet {
            linkLabel.textColor = linkColor
        }
    }

    // MARK: - Actions

    private var tapGesture: UITapGestureRecognizer!
    private var swipeGesture: UISwipeGestureRecognizer?

    private func setupRevealOnTap() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(reveal))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    private func setupRelealOnSwipeIfNeeded() {
        if canSwipeToReveal, swipeGesture == nil {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(reveal))
            swipeGesture.direction = .down
            addGestureRecognizer(swipeGesture)
            self.swipeGesture = swipeGesture
        } else if !canSwipeToReveal, let swipeGesture = swipeGesture {
            removeGestureRecognizer(swipeGesture)
            self.swipeGesture = nil
        }
    }

    @objc
    private func reveal() {
        isRevealed = !isRevealed
    }

    // MARK: - Views

    private lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.text = titleText
        addSubview(label)
        return label
    }()
    private lazy var linkLabel: UILabel! = {
        let label = UILabel()
        label.text = linkText
        addSubview(label)
        return label
    }()

    private var isRevealed: Bool = false {
        didSet {
            showLink(isRevealed ? true : false)
        }
    }

    private func setupViews() {
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        linkLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        linkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true

        linkLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }

    private func showLink(_ shouldShow: Bool) {
        UIView.animate(withDuration: 0.33) {
            self.linkLabel.alpha = shouldShow ? 1.0 : 0.0
        }
    }
}

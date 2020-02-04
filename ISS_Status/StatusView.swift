//
//  TestView.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/30/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import UIKit

protocol StatusViewProtocol {
    func showError(_ errorMessage: String)
    func updateState(with color: UIColor, text: String)
}

protocol StatusViewFactory {
    static func makeView() -> StatusViewProtocol
}

class StatusView: UIView {
    private let viewSize: CGFloat = 50
    private lazy var colorView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: viewSize).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewSize).isActive = true
        view.layer.cornerRadius = viewSize / 2
        view.layer.masksToBounds = true
        view.backgroundColor = .orange
        // Creating click button
        let btn = UIButton(frame: view.frame)
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(userDidClickInfoButton), for: .touchUpInside)
        btn.setImage(UIImage(named: "question"), for: .normal)
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()

    private lazy var stateLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var currentMessage: String = "" {
        didSet {
            stateLabel.text = currentMessage
        }
    }

    private var isMessageDisplayed: Bool = false
}

private extension StatusView {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: viewSize + 20).isActive = true
        setupColorView()
        setupStateLabel()
    }

    func setupColorView() {
        addSubview(colorView)
        colorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorView.isHidden = true
    }

    func setupStateLabel() {
        addSubview(stateLabel)
        stateLabel.adjustsFontSizeToFitWidth = true
        stateLabel.trailingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -5).isActive = true
        stateLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor).isActive = true
        stateLabel.font =  UIFont.systemFont(ofSize: 12)
        stateLabel.textAlignment = .right
        stateLabel.alpha = 0
    }
}

// MARK: Protocols and Factory

extension StatusView: StatusViewProtocol {
    func updateState(with color: UIColor, text: String) {
        if colorView.isHidden { colorView.isHidden = false }
        colorView.backgroundColor = color
        currentMessage = text
    }

    func showError(_ errorMessage: String) {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = errorMessage
        addSubview(label)
    }

    @objc func userDidClickInfoButton() {
        func showMessage() { UIView.animate(withDuration: 0.5) { self.stateLabel.alpha = 1 } }
        func hideMessage() { UIView.animate(withDuration: 0.5) { self.stateLabel.alpha = 0 } }
        isMessageDisplayed = !isMessageDisplayed
        isMessageDisplayed ? showMessage() : hideMessage()
    }
}

extension StatusView: StatusViewFactory {
    static func makeView() -> StatusViewProtocol {
        let view = StatusView()
        view.setupView()
        return view
    }
}

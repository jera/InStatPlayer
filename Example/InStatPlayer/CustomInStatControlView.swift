//
//  CustomInStatControlView.swift
//  InStatPlayer_Example
//
//  Created by workmachine on 19/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import InStatPlayer

class CustomInStatControlView: InStatControlView {

	override init(customIndicatorView: UIView?) {
		super.init(customIndicatorView: customIndicatorView)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func customizeControlView() {

		previousButton.removeFromSuperview()
		playButton.removeFromSuperview()
		nextButton.removeFromSuperview()

		currentTimeLabel.removeFromSuperview()
		progressView.removeFromSuperview()
		progressSlider.removeFromSuperview()
		totalTimeLabel.removeFromSuperview()

		fullscreenButton.removeFromSuperview()
		airplayButton.removeFromSuperview()

		let bottomView = UIView()
		bottomView.translatesAutoresizingMaskIntoConstraints = false
		bottomView.layer.cornerRadius = 25
		bottomView.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
		mainMaskView.addSubview(bottomView)

		bottomView.leftAnchor.constraint(equalTo: mainMaskView.leftAnchor, constant: 30).isActive = true
		bottomView.rightAnchor.constraint(equalTo: mainMaskView.rightAnchor, constant: -30).isActive = true
		bottomView.bottomAnchor.constraint(equalTo: mainMaskView.bottomAnchor, constant: -30).isActive = true
		bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true

		bottomView.addSubview(progressView)
		progressView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 25).isActive = true
		progressView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25).isActive = true
		progressView.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25).isActive = true

		bottomView.addSubview(progressSlider)
		progressSlider.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
		progressSlider.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25).isActive = true
		progressSlider.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25).isActive = true

		bottomView.addSubview(currentTimeLabel)
		currentTimeLabel.topAnchor.constraint(equalTo: progressSlider.topAnchor, constant: 20).isActive = true
		currentTimeLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25).isActive = true

		bottomView.addSubview(totalTimeLabel)
		totalTimeLabel.topAnchor.constraint(equalTo: progressSlider.topAnchor, constant: 20).isActive = true
		totalTimeLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -25).isActive = true

		bottomView.addSubview(airplayButton)
		airplayButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true
		airplayButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 25).isActive = true

		bottomView.addSubview(playButton)
		playButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
		playButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -5).isActive = true
		nextButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 57).isActive = true

		bottomView.addSubview(previousButton)
		previousButton.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: 24).isActive = true
		previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
		nextButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 57).isActive = true

		bottomView.addSubview(nextButton)
		nextButton.leftAnchor.constraint(equalTo: playButton.rightAnchor, constant: -25).isActive = true
		nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
		nextButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
	}
}

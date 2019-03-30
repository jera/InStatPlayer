//
//  ViewController.swift
//  InStatPlayer
//
//  Created by tularovbeslan@gmail.com on 02/19/2019.
//  Copyright (c) 2019 tularovbeslan@gmail.com. All rights reserved.
//

import UIKit
import InStatPlayer
import AVFoundation

class InStatPlayerViewController: UIViewController, InStatPlayerDelegate {

	var player: InStatPlayerView!
	open var indicatorView = InStatIndicatorView()

	var isStatusBarHidden: Bool = false {
		didSet {
			UIView.animate(withDuration: 0.5) { () -> Void in
				self.setNeedsStatusBarAppearanceUpdate()
			}
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		indicatorView.startAnimation()
		setupPlayer()
		setupPlayerConstraints()
	}

	func setupPlayer() {

		let url = URL(string: "http://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4")!
		let item0 = AVPlayerItem(url: url)
		let item1 = AVPlayerItem(url: url)
		let item2 = AVPlayerItem(url: url)
		let item3 = AVPlayerItem(url: url)

		let queue = [[item0, item1, item2], [item3]]

		let control = CustomInStatControlView(customIndicatorView: indicatorView)
		player = InStatPlayerView(queue, customControlView: control)
		player.translatesAutoresizingMaskIntoConstraints = false
		player.delegate = self
		view.addSubview(player)
	}

	func setupPlayerConstraints() {

		player.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		player.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		player.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		player.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	func playerDidFullscreen(_ player: InStatPlayerView) {

		if player.isFullScreen {
			UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
			isStatusBarHidden = false
		} else {
			UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
			isStatusBarHidden = true
		}
	}

	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .slide
	}

	override var prefersStatusBarHidden: Bool {
		return isStatusBarHidden
	}
}

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
	@IBOutlet weak var segmentedControl: UISegmentedControl!
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

		view.addSubview(segmentedControl)
	}

	func setupPlayer() {

		let url = URL(string: "rtsp://184.72.239.149/vod/mp4")!
		let item0 = AVPlayerItem(url: url)
		let item1 = AVPlayerItem(url: url)
		let item2 = AVPlayerItem(url: url)
		let item3 = AVPlayerItem(url: url)

//		let queue = [[item0, item1,item2]]
//
//		let control = CustomInStatControlView(customIndicatorView: indicatorView)
		player = InStatPlayerView(item0)
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

	@IBAction func changeRatio(_ sender: UISegmentedControl) {

		switch sender.selectedSegmentIndex {
		case 0:
			let index = IndexPath(row: 0, section: 0)
			player.playItemAt(index)
			player.aspectRatio = .resize
		case 1:
			let index = IndexPath(row: 1, section: 0)
			player.playItemAt(index)
			player.aspectRatio = .resizeAspect
		case 2:
			let index = IndexPath(row: 2, section: 0)
			player.playItemAt(index)
			player.aspectRatio = .resizeAspectFill
		case 3:
			player.aspectRatio = .sixteenToNINE
		case 4:
			player.aspectRatio = .fourToTHREE
		default:
			break
		}
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

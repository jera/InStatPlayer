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

class InStatPlayerViewController: UIViewController {

	@IBOutlet weak var playerView: InStatPlayerView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
	fileprivate let videoPlayerHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16

	open var indicatorView = InStatIndicatorView()
	var queue: [[AVPlayerItem]] = []

	var isStatusBarHidden: Bool = false {
		didSet {
			UIView.animate(withDuration: 0.5) { () -> Void in
				self.setNeedsStatusBarAppearanceUpdate()
			}
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		title = "Standard"
		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		indicatorView.startAnimation()
		setupTableView()
		generateData()
	}

	func generateData() {

		guard let url = URL(string: "http://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4") else { return }

		for index in 0..<5 {
			if index == 2 {
				queue.append([AVPlayerItem(url: url), AVPlayerItem(url: url)])
			} else {
				queue.append([AVPlayerItem(url: url)])
			}
		}

		playerView.delegate = self
		playerView.queue = queue
		playerView.realoadData()
		playerView.play()
	}

	func setupTableView() {

		tableView.tableFooterView = UIView(frame: .zero)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: String(describing: PlayerTableViewCell.self))
		tableView.register(PlayerTableViewHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: PlayerTableViewHeader.self))
	}


	// change fullscreen frame

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let orientation:UIDeviceOrientation = UIDevice.current.orientation
		changeVideoPlayerFrame(orientation: orientation)
	}

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		changeVideoPlayerFrame(orientation: UIDevice.current.orientation)
	}

	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return .fade
	}

	override var prefersStatusBarHidden: Bool {
		return isStatusBarHidden
	}

	fileprivate func changeVideoPlayerFrame(orientation: UIDeviceOrientation) {

		UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
		switch orientation {
		case .landscapeLeft, .landscapeRight: orientationLandscape()
		case .portrait, .portraitUpsideDown: orientationPortrait()
		default: break
		}
		self.view.layoutIfNeeded()
	}

	fileprivate func orientationLandscape() {

		tabBarController?.tabBar.isHidden = true
		isStatusBarHidden = true
		navigationController?.setNavigationBarHidden(true, animated: true)
		playerView.frame = UIScreen.main.bounds
		playerViewHeightConstraint.constant = UIScreen.main.bounds.height
	}

	fileprivate func orientationPortrait() {

		tabBarController?.tabBar.isHidden = false
		isStatusBarHidden = false
		navigationController?.setNavigationBarHidden(false, animated: true)
		playerView.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: videoPlayerHeight)
		playerViewHeightConstraint.constant = videoPlayerHeight
	}
}

// MARK: - UITableViewDataSource

extension InStatPlayerViewController: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return queue.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return queue[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlayerTableViewCell.self), for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
		cell.setup("Row \(indexPath.row)")
		return cell
	}
}

// MARK: - UITableViewDelegate

extension InStatPlayerViewController: UITableViewDelegate {

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: PlayerTableViewHeader.self)) as? PlayerTableViewHeader  else { return UIView() }

		cell.setup("Section \(section)")
		return cell
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		playerView.playItemAt(indexPath)
	}
}

// MARK: - InStatPlayerDelegate

extension InStatPlayerViewController : InStatPlayerDelegate {

	func player(_ player: InStatPlayerView, didPlay item: AVPlayerItem, at indexPath: IndexPath) {
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
	}

	func player(_ player: InStatPlayerView, didFail error: Error, item: AVPlayerItem, at indexPath: IndexPath) {
		print(item.debugDescription)
	}

	func playerDidFullscreen(_ player: InStatPlayerView) {

		if player.isFullScreen {
			changeVideoPlayerFrame(orientation: UIDeviceOrientation.portrait)
		} else {
			changeVideoPlayerFrame(orientation: UIDeviceOrientation.landscapeRight)
		}
	}
}

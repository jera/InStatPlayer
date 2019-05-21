//
//  InStatPlayerView.swift
//  InStatPlayer
//

import Foundation
import AVFoundation
import UIKit

open class InStatPlayerView: UIView {

	// MARK: - Properties

	public weak var delegate: InStatPlayerDelegate?
	fileprivate var totalDuration   : TimeInterval = 0
	fileprivate var shouldSeekTo    : TimeInterval = 0
	fileprivate var timer: Timer?
	fileprivate var indexPath: IndexPath = IndexPath(row: 0, section: 0)
	fileprivate var controlView: InStatControlView!
	open var customControlView: InStatControlView?
	fileprivate var playerLayer: AVPlayerLayer?
	public var player: AVPlayer?

	public var isPlayLoops: Bool = false
	public var isFullScreen: Bool = false
	public var queue: [[AVPlayerItem]] = []

	public var playerItem: AVPlayerItem!

	open var videoGravity = AVLayerVideoGravity.resizeAspect {
		didSet { self.playerLayer?.videoGravity = videoGravity }
	}

	open var aspectRatio: InStatPlayerAspectRatio = .resizeAspect {
		didSet { self.setNeedsLayout() }
	}

	open func realoadData() {
		setupPlayer()
	}

	// MARK: - Life cycle

	open override func awakeFromNib() {
		super.awakeFromNib()

		prepareToInit()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		prepareToInit()
	}

	public convenience init(_ queue: [[AVPlayerItem]], customControlView: InStatControlView?) {
		self.init()

		prepareToInit()
		self.customControlView = customControlView
		self.queue = queue
	}

	public convenience init(_ queue: [[AVPlayerItem]]) {
		self.init()

		prepareToInit()
		self.queue = queue
	}

	public convenience init(_ playerItem: AVPlayerItem) {
		self.init()

		prepareToInit()
		self.playerItem = playerItem
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public init(customControlView: InStatControlView?) {
		super.init(frame:CGRect.zero)

		prepareToInit()
		self.customControlView = customControlView
	}

	deinit {
		prepareToDeinit()
	}

	func prepareToInit() {

		player = AVPlayer()
		playerLayer?.removeFromSuperlayer()
		playerLayer = AVPlayerLayer(player: player)
		playerLayer?.videoGravity = videoGravity
		layer.insertSublayer(playerLayer!, at: 0)
		setNeedsLayout()
		layoutIfNeeded()
	}

	open func prepareToDeinit() {

		NotificationCenter.default.removeObserver(self,
												  name: UIDevice.orientationDidChangeNotification,
												  object: nil)
		self.player?.pause()
		self.shouldSeekTo = 0
		self.timer?.invalidate()
		self.playerLayer?.removeFromSuperlayer()
		self.player?.replaceCurrentItem(with: nil)
		self.player = nil
	}

	override open func layoutSubviews() {
		super.layoutSubviews()

		switch self.aspectRatio {
		case .resize:

			self.playerLayer?.videoGravity = AVLayerVideoGravity.resize
			self.playerLayer?.frame  = self.bounds
		case .resizeAspect:

			self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
			self.playerLayer?.frame  = self.bounds
		case .resizeAspectFill:

			self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
			self.playerLayer?.frame  = self.bounds
		case .sixteenToNINE:

			self.playerLayer?.videoGravity = AVLayerVideoGravity.resize
			self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width / (16 / 9))
		case .fourToTHREE:

			self.playerLayer?.videoGravity = AVLayerVideoGravity.resize
			let width = self.bounds.height * 3 / 4
			self.playerLayer?.frame = CGRect(x: (self.bounds.width - width ) / 2, y: 0, width: width, height: self.bounds.height)
		}
	}

	// MARK: - Setup

	fileprivate func setupControls() {

		if let customView = customControlView {
			if controlView != nil {
				controlView.removeFromSuperview()
			}
			controlView = customView
		} else {

			customControlView?.removeFromSuperview()
			controlView = InStatControlView()
		}

		controlView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(controlView)
		controlView.delegate = self
		controlView.playerView   = self
		controlView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		controlView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		controlView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		controlView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	fileprivate func setupPlayer() {

		NotificationCenter.default.addObserver(self,
											   selector: #selector(orientationDidChange),
											   name: UIDevice.orientationDidChangeNotification,
											   object: nil)

		if queue.isEmpty && playerItem == nil { return }

		let item: AVPlayerItem!
		if queue.isEmpty {
			item = playerItem
		} else {
			item = queue[indexPath.section][indexPath.row]
		}

		player?.replaceCurrentItem(with: item)
		delegate?.player?(self, ready: item, at: indexPath)
		setupControls()
	}

	func setupTimer() {

		timer?.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 0.25,
									 target: self,
									 selector: #selector(timerDidChange),
									 userInfo: nil,
									 repeats: true)
		timer?.fireDate = Date()
	}

	// MARK: - Actions

	@objc fileprivate func timerDidChange() {

		guard let item = player?.currentItem else { return }

		if item.duration.timescale != 0 {

			let currentTime = CMTimeGetSeconds(self.player!.currentTime())
			let totalTime   = TimeInterval(item.duration.value) / TimeInterval(item.duration.timescale)
			delegate?.player?(self,
							  didChangeTo: currentTime,
							  for: item,
							  at: indexPath,
							  total: totalTime)
			controlView.stateChange(.playing)
			controlView.totalDuration = totalTime
			totalDuration = totalTime
			controlView.playbackChange(currentTime, totalTime: totalTime)
		}

		if let player = player {

			if item.isPlaybackLikelyToKeepUp || item.isPlaybackBufferFull {
				delegate?.player?(self,
								  bufferingReady: item,
								  at: indexPath)
			} else if item.status == .failed {

				delegate?.player?(self,
								  didFail: item.error!,
								  item: item,
								  at: indexPath)
				controlView.stateChange(.error)
			} else if item.status == .unknown {

				delegate?.player?(self,
								  bufferingUnknown: item,
								  at: indexPath)
				controlView.stateChange(.unknown)
			} else {

				delegate?.player?(self,
								  bufferingDelayed: item,
								  at: indexPath)
				controlView.stateChange(.buffering)
			}

			let timeRanges = item.loadedTimeRanges
			if let timeRange = timeRanges.first?.timeRangeValue {

				let bufferedTime = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration))
				let totalTime   = TimeInterval(item.duration.value) / TimeInterval(item.duration.timescale)
				delegate?.player?(self,
								  bufferingTimeDidChangeTo: bufferedTime,
								  item: item,
								  at: indexPath,
								  total: totalTime)
				controlView.bufferChange(bufferedTime, total: totalTime)
			}

			if player.rate == 0.0 {

				if player.error != nil {

					delegate?.player?(self,
									  didFail: player.error!,
									  item: item,
									  at: indexPath)
					controlView.stateChange(.error)
					return
				}

				if let currentItem = player.currentItem {

					if player.currentTime() >= currentItem.duration {

						delegate?.player?(self, didEnd: item, at: indexPath)
						self.timer?.invalidate()
						isPlayLoops ? loopingPlayback() : playerDidEnd()
						return
					}
				}
			} else if player.error != nil {
				controlView.stateChange(.playing)
			}
		}
	}

	func playerDidEnd() {

		if isLastItem() {
			stop()
			controlView.stateChange(.ended)
		} else {
			next()
		}
	}

	@objc fileprivate func orientationDidChange() {

		switch UIDevice.current.orientation {
		case .landscapeLeft, .landscapeRight: fullScreenButton(isSelected: true)
		case .portrait, .portraitUpsideDown: fullScreenButton(isSelected: false)
		default: break
		}
	}

	fileprivate func fullScreenButton(isSelected: Bool) {

		if controlView != nil {

			isFullScreen = isSelected
			controlView.fullscreenButton.isSelected = isSelected
		}
	}

	// MARK: - Control actions

	public func playItemAt(_ indexPath: IndexPath, fromItems items: [[AVPlayerItem]]) {

		DispatchQueue.global(qos: .userInteractive).async {
			if items.count > indexPath.section {
				if items[indexPath.section].count > 0 {

					let item = items[indexPath.section][indexPath.item]
					self.indexPath =  indexPath
					DispatchQueue.main.async {

						self.player?.seek(to: CMTime(value: 0, timescale: 1))
						self.pause()
						self.player?.replaceCurrentItem(with: item)
						self.play()
					}
				}
			}
		}
	}

	public func playItemAt(_ indexPath: IndexPath) {

		self.indexPath = indexPath
		playItemAt(indexPath, fromItems: queue)
	}

	public func playItem(_ item: AVPlayerItem) {

		DispatchQueue.main.async {

			self.player?.replaceCurrentItem(with: item)
			self.play()
		}
	}

	open func play() {

		guard let item = player?.currentItem else { return }
		setupTimer()
		player?.play()
		delegate?.player?(self, didPlay: item, at: indexPath)
	}

	open func pause() {

		guard let item = player?.currentItem else { return }
		player?.pause()
		timer?.fireDate = Date.distantFuture
		delegate?.player?(self, didPause: item, at: indexPath)
		controlView.stateChange(.paused)
	}

	open func stop() {

		guard let item = player?.currentItem else { return }
		player?.pause()
		player?.seek(to: CMTime.zero)
		delegate?.player?(self, didStop: item, at: indexPath)
		controlView.stateChange(.stopped)
	}

	open func next() {

		let reset = 0
		let step = 1
		let stepForward = indexPath.section + 1
		let section = indexPath.section
		let item = indexPath.item

		if section <= queue.count - step {
			if item + step > queue[section].count - step {
				indexPath = IndexPath(item: reset, section: stepForward)
			} else {
				indexPath = IndexPath(item: item + step, section: section)
			}
			playItemAt(indexPath, fromItems: queue)
		}
	}

	open func previous() {

		let zero = 0
		let step = 1
		let stepBack = indexPath.section - step
		var section = indexPath.section
		var item = indexPath.item
		if section >= queue.count {
			indexPath = IndexPath(item: zero, section: stepBack)
			section = stepBack
			item = zero
		}

		if item - step <  queue[section].count - step {
			if section == zero && queue[section].count == step {
				indexPath = IndexPath(item: zero, section: zero)
			} else if section == zero && item == zero {
				indexPath = IndexPath(item: zero, section: zero)
			} else if section == zero && item != zero {
				indexPath = IndexPath(item: item - step, section: section)
			} else if section != zero && queue[section].count == step {
				indexPath = IndexPath(item: queue[stepBack].count - step, section: stepBack)
			} else if item == zero && queue[section].count != step {
				indexPath = IndexPath(item: queue[stepBack].count - step, section: stepBack)
			} else {
				indexPath = IndexPath(item: item - step, section: section)
			}
		}
		playItemAt(indexPath, fromItems: queue)
	}

	open func seek(to secounds: TimeInterval) {
		if secounds.isNaN {
			return
		}
		setupTimer()
		if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
			let draggedTime = CMTimeMake(value: Int64(secounds), timescale: 1)
			self.player!.seek(to: draggedTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (_) in
			})
		} else {
			self.shouldSeekTo = secounds
		}
	}

	open func startFromBeginning() {

		let indexPath = IndexPath(item: 0, section: 0)
		playItemAt(indexPath, fromItems: queue)
		guard let item = player?.currentItem else { return }
		delegate?.player?(self, willStartFromBeginning: item, at: indexPath)
	}

	open func loopingPlayback() {

		guard let item = player?.currentItem else { return }
		player?.pause()
		player?.seek(to: CMTime.zero)
		play()
		delegate?.player?(self, willLoop: item, at: indexPath)
	}

	public func isLastItem() -> Bool {

		if queue.isEmpty { return true }

		let lastSection = queue.count - 1
		guard let  lastItem = queue[lastSection].last else { return false }
		guard let item = player?.currentItem else { return false }
		return item === lastItem
	}

	public func isFirstItem() -> Bool {

		if queue.isEmpty { return true }

		guard let  firstItem = queue.first?.first else { return false }
		guard let item = player?.currentItem else { return false }
		return item === firstItem
	}
}

extension InStatPlayerView: InStatControlViewDelegate {

	public func controlView(controlView: InStatControlView, slider: UISlider, onSliderEvent event: UIControl.Event) {
		switch event {
		case .touchDown:
			pause()
			if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
				self.timer?.fireDate = Date.distantFuture
			}
		case .touchUpInside :
			play()
		case .valueChanged:
			let target = self.totalDuration * Double(slider.value)
			guard let item = player?.currentItem else { return }
			delegate?.player?(self, seekTo: target, for: item, at: indexPath)
			seek(to: target)
		default:
			break
		}
	}
}

extension InStatPlayerView {

	public enum InStatPlayerAspectRatio : Int {

		case resize
		case resizeAspect
		case resizeAspectFill
		case sixteenToNINE
		case fourToTHREE
	}
}

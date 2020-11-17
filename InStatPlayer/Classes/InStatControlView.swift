//
//  InStatControlView.swift
//  InStatPlayer
//

import UIKit
import MediaPlayer

public enum InStatPlayerState: String {

	case unknown
	case ready
	case playing
	case paused
	case stopped
	case buffering
	case bufferingForSomeTime
	case error
	case ended
}

@objc public protocol InStatControlViewDelegate: class {

	func controlView(controlView: InStatControlView, slider: UISlider, onSliderEvent event: UIControl.Event)
}

open class InStatControlView: UIView {

	// MARK: - Properties

	open var indicatorView: UIView = {

		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		let indicator = UIActivityIndicatorView(style: .gray)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.tintColor = .white
		indicator.startAnimating()
		view.addSubview(indicator)
		indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		return view
	}()

	open var maskImageView: UIImageView = {

		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	open var mainMaskView: UIView = {

		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(white: 0, alpha: 0.5)
		return view
	}()

//    open var airplayButton: UIButton = {
//
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(imageResourcePath("airplay"), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self,
//                         action: #selector(airplayDidPress(_:)),
//                         for: .touchUpInside)
//        return button
//    }()

	open var playButton: UIButton = {

		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(imageResourcePath("play"), for: .normal)
		button.setImage(imageResourcePath("pause"), for: .selected)
		button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 25, bottom: 18, right: 25)
		button.tintColor = .white
		button.addTarget(self,
						 action: #selector(playDidPress),
						 for: .touchUpInside)
		return button
	}()

	open var nextButton: UIButton = {

		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(imageResourcePath("next"), for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 20, right: 17)
		button.tintColor = .white
		button.addTarget(self,
						 action: #selector(nextDidPress),
						 for: .touchUpInside)
		return button
	}()

	open var previousButton: UIButton = {

		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(imageResourcePath("previous"), for: .normal)
		button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 17, bottom: 20, right: 17)
		button.tintColor = .white
		button.addTarget(self,
						 action: #selector(previousDidPress),
						 for: .touchUpInside)
		return button
	}()

	open var fullscreenButton: UIButton = {

		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(imageResourcePath("fullscreen"), for: .normal)
		button.setImage(imageResourcePath("portialscreen"), for: .selected)
		button.addTarget(self,
						 action: #selector(fullScreenDidPress),
						 for: .touchUpInside)
		button.tintColor = .white
		return button
	}()

	open var videoGravityButton: UIButton = {

		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(imageResourcePath("videogravityFill"), for: .normal)
		button.setImage(imageResourcePath("videogravity"), for: .selected)
		button.addTarget(self,
						 action: #selector(videoGravityButtonDidPress),
						 for: .touchUpInside)
		button.tintColor = .white
		return button
	}()

	open var titleLabel: UILabel = {

		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textColor = UIColor.white
		label.text      = ""
		label.font      = UIFont.systemFont(ofSize: 16)
		return label
	}()

	open var subtitleLabel: UILabel = {

		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		label.font = UIFont.systemFont(ofSize: 13)
		return label
	}()

	open var currentTimeLabel: UILabel = {

		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textColor	= UIColor.white
		label.font		= UIFont.systemFont(ofSize: 12)
		label.text		= "00:00"
		label.textAlignment	= NSTextAlignment.center
		return label
	}()

	open var totalTimeLabel: UILabel = {

		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textColor	= UIColor.white
		label.font		= UIFont.systemFont(ofSize: 12)
		label.text		= "00:00"
		label.textAlignment	= NSTextAlignment.center
		return label
	}()

	open var progressSlider: InStatSlider = {

		let slider = InStatSlider()
		slider.translatesAutoresizingMaskIntoConstraints = false
		slider.maximumValue = 1.0
		slider.minimumValue = 0.0
		slider.value        = 0.0
		slider.maximumTrackTintColor = UIColor.clear
		slider.minimumTrackTintColor = UIColor.red
		slider.setThumbImage(imageResourcePath("sliderThumb"), for: .normal)
		slider.addTarget(self,
						 action: #selector(sliderTouchBegan(_:)),
						 for: UIControl.Event.touchDown)
		slider.addTarget(self,
						 action: #selector(sliderValueChanged(_:)),
						 for: UIControl.Event.valueChanged)
		slider.addTarget(self,
						 action: #selector(sliderTouchEnded(_:)),
						 for: [UIControl.Event.touchUpInside, UIControl.Event.touchCancel,
							   UIControl.Event.touchUpOutside])
		return slider
	}()

	open var progressView: UIProgressView = {

		let progress = UIProgressView()
		progress.translatesAutoresizingMaskIntoConstraints = false
		progress.tintColor      = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6 )
		progress.trackTintColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3 )
		return progress
	}()

	open weak var delegate: InStatControlViewDelegate?
	open weak var playerView: InStatPlayerView?
	fileprivate var customIndicatorView: UIView?
	fileprivate var state: InStatPlayerState = .unknown
	fileprivate var isScrubbing: Bool = false
	open var delayItem: DispatchWorkItem?
	open var totalDuration: TimeInterval = 0
	open var isFullscreen  = false
	open var isMaskShowing = true
	open var tapGesture: UITapGestureRecognizer!
	open var isAutoFade: Bool = true {
		didSet {
			autoFadeControlView()
		}
	}
	open var fadeTimeInterval: TimeInterval = 4
	open var fadeDuration: TimeInterval = 0.3

	fileprivate var isFullScreen: Bool {
		get {
			return UIApplication.shared.statusBarOrientation.isLandscape
		}
	}

	// MARK: - Init

	override public init(frame: CGRect) {
		super.init(frame: frame)

		setupUIComponents()
		customizeControlView()
	}

	public init(customIndicatorView: UIView?) {
		super.init(frame: CGRect.zero)

		self.customIndicatorView = customIndicatorView
		setupUIComponents()
		customizeControlView()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open func customizeControlView() {}

	// MARK: - Setup UI

	func setupUIComponents() {

		if let customView = customIndicatorView {
			indicatorView = customView
			indicatorView.translatesAutoresizingMaskIntoConstraints = false
		}

		tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
		addGestureRecognizer(tapGesture)

		setupMaskViewConstraints()
		setupControlButtonsConstraints()
		fullscreenControlConstraints()
		setupTimeLabelsConstraints()
		progressControlsConstraints()
		setupIndicatorViewConstraints()
		autoFadeControlView()
	}

	func setupMaskViewConstraints() {

		addSubview(mainMaskView)
		mainMaskView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		mainMaskView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		mainMaskView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		mainMaskView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	func setupControlButtonsConstraints() {

		mainMaskView.addSubview(playButton)
		playButton.centerXAnchor.constraint(equalTo: mainMaskView.centerXAnchor).isActive = true
		playButton.centerYAnchor.constraint(equalTo: mainMaskView.centerYAnchor).isActive = true
		playButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		playButton.heightAnchor.constraint(equalToConstant: 57).isActive = true

		mainMaskView.addSubview(nextButton)
		nextButton.leftAnchor.constraint(equalTo: playButton.rightAnchor).isActive = true
		nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
		nextButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 57).isActive = true

		mainMaskView.addSubview(previousButton)
		previousButton.rightAnchor.constraint(equalTo: playButton.leftAnchor).isActive = true
		previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
		previousButton.widthAnchor.constraint(equalToConstant: 68).isActive = true
		previousButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
//
//        mainMaskView.addSubview(airplayButton)
//        airplayButton.rightAnchor.constraint(equalTo: mainMaskView.rightAnchor, constant: -15).isActive = true
//        airplayButton.topAnchor.constraint(equalTo: mainMaskView.topAnchor, constant: 15).isActive = true
//        airplayButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
//        airplayButton.heightAnchor.constraint(equalToConstant: 28).isActive = true

		mainMaskView.addSubview(videoGravityButton)
		videoGravityButton.leftAnchor.constraint(equalTo: mainMaskView.leftAnchor, constant: 15).isActive = true
		videoGravityButton.topAnchor.constraint(equalTo: mainMaskView.topAnchor, constant: 15).isActive = true
		videoGravityButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
		videoGravityButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
	}

	func fullscreenControlConstraints() {

		mainMaskView.addSubview(fullscreenButton)
		fullscreenButton.rightAnchor.constraint(equalTo: mainMaskView.rightAnchor, constant: -15).isActive = true
		fullscreenButton.bottomAnchor.constraint(equalTo: mainMaskView.bottomAnchor, constant: -15).isActive = true
		fullscreenButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
		fullscreenButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
	}

	func setupTimeLabelsConstraints() {

		mainMaskView.addSubview(currentTimeLabel)
		currentTimeLabel.leftAnchor.constraint(equalTo: mainMaskView.leftAnchor, constant: 15).isActive = true
		currentTimeLabel.centerYAnchor.constraint(equalTo: fullscreenButton.centerYAnchor).isActive = true

		mainMaskView.addSubview(totalTimeLabel)
		totalTimeLabel.rightAnchor.constraint(equalTo: fullscreenButton.leftAnchor, constant: -15).isActive = true
		totalTimeLabel.centerYAnchor.constraint(equalTo: fullscreenButton.centerYAnchor).isActive = true
	}

	func progressControlsConstraints() {

		mainMaskView.addSubview(progressView)
		progressView.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 10).isActive = true
		progressView.rightAnchor.constraint(equalTo: totalTimeLabel.leftAnchor, constant: -10).isActive = true
		progressView.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor).isActive = true

		mainMaskView.addSubview(progressSlider)
		progressSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor, constant: 10).isActive = true
		progressSlider.rightAnchor.constraint(equalTo: totalTimeLabel.leftAnchor, constant: -10).isActive = true
		progressSlider.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
	}

	func setupIndicatorViewConstraints() {

		addSubview(indicatorView)
		indicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		indicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}

	// MARK: - Helpers

	open func stateChange(_ state: InStatPlayerState) {
		self.state = state
		switch state {
		case .unknown: indicatorShow(true)
		case .ready: indicatorShow(false)
		case .buffering: indicatorShow(false)
		case .bufferingForSomeTime: indicatorShow(false)
		case .playing:
			indicatorShow(false)
			playButton.isSelected = true
		case .stopped: playButton.isSelected = false
		case .error: print("error")
		case .paused: playButton.isSelected = false
		case .ended: print("ended")
		}
	}

	open func indicatorShow(_ show: Bool) {
		indicatorView.isHidden = !show
		if show {
			isShowControlView(!show, animation:  false)
		}
	}

	open func playbackChange(_ currentTime: TimeInterval, totalTime: TimeInterval) {

		currentTimeLabel.text	= formatSecondsToString(currentTime)
		totalTimeLabel.text		= formatSecondsToString(totalTime)
        let progress = Float(currentTime / totalTime)
        progressSlider.value = progress

		if let player = playerView {

			nextButton.isEnabled = player.isLastItem() ? false : true
			previousButton.isEnabled = player.isFirstItem() ? false : true
		}
	}

	open func bufferChange(_ progress: TimeInterval, total: TimeInterval) {
        let progress: Float = Float(progress)/Float(total)
        if progressView.progress < progress {
            progressView.setProgress(progress, animated: true)
        }
	}

	open func isShowControlView(_ isShow: Bool, animation: Bool = true) {

		if animation {
			self.isMaskShowing = isShow
			UIView.animate(withDuration: fadeDuration, animations: {

				self.mainMaskView.backgroundColor = UIColor(white: 0, alpha: isShow ? 0.5 : 0.0)
				self.mainMaskView.alpha = isShow ? 1.0 : 0.0
				self.layoutIfNeeded()
			}) { (_) in if isShow { self.autoFadeControlView() } }
		} else {

			self.mainMaskView.backgroundColor = UIColor(white: 0, alpha: isShow ? 0.5 : 0.0)
			self.mainMaskView.alpha = isShow ? 1.0 : 0.0
			self.layoutIfNeeded()
		}
	}

	open func autoFadeControlView() {

		cancelAutoFadeControlView()

		if isAutoFade {

			delayItem = DispatchWorkItem { [weak self] in

				guard let `self` = self else { return }
				self.isShowControlView(false)
			}
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + fadeTimeInterval,
										  execute: delayItem!)
		}
	}

	open func cancelAutoFadeControlView() { delayItem?.cancel() }

	// MARK: - Actions

	@objc open func playDidPress() {

		state == .playing ? playerView?.pause() : playerView?.play()
		playButton.isSelected = state == .playing ? true : false
	}

	@objc open func stopDidPress() { playerView?.stop() }

	@objc open func nextDidPress() { playerView?.next() }

	@objc open func previousDidPress() { playerView?.previous() }

	@objc open func fullScreenDidPress() {

		guard let player = playerView else { return }
		player.videoGravity = videoGravityButton.isSelected ? .resizeAspect : .resizeAspectFill
		videoGravityButton.isSelected = !videoGravityButton.isSelected
		player.delegate?.playerDidFullscreen?(player)
	}

	@objc open func videoGravityButtonDidPress() {

		guard let player = playerView else { return }
		player.videoGravity = videoGravityButton.isSelected ? .resizeAspect : .resizeAspectFill
		videoGravityButton.isSelected = !videoGravityButton.isSelected
	}

	@objc open func airplayDidPress(_ button: UIButton) {

		let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
		let airplayVolume = MPVolumeView(frame: rect)
		airplayVolume.showsVolumeSlider = false
		addSubview(airplayVolume)
		for view: UIView in airplayVolume.subviews {
			if let button = view as? UIButton {
				button.sendActions(for: .touchUpInside)
				break
			}
		}
		airplayVolume.removeFromSuperview()
	}

	@objc open func shareDidPress() { print("shareDidPress") }

	@objc open func menuDidPress() { print("menuDidPress") }

	@objc func sliderTouchBegan(_ sender: UISlider) {

		delegate?.controlView(controlView: self,
							  slider: sender,
							  onSliderEvent: .touchDown)
	}

	@objc func sliderValueChanged(_ sender: UISlider) {

		cancelAutoFadeControlView()
		let currentTime = Double(sender.value) * totalDuration
		currentTimeLabel.text = formatSecondsToString(currentTime)
		delegate?.controlView(controlView: self,
							  slider: sender,
							  onSliderEvent: .valueChanged)
		isScrubbing = true
	}

	@objc func sliderTouchEnded(_ sender: UISlider) {

		autoFadeControlView()
		delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchUpInside)
		isScrubbing = false
	}

	@objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
		isShowControlView(!isMaskShowing)
	}

	static func imageResourcePath(_ name: String) -> UIImage? {

		let bundle = Bundle(for: InStatPlayerView.self)
		return UIImage(named: name, in: bundle, compatibleWith: nil)
	}

	private func formatSecondsToString(_ interval: TimeInterval) -> String {

		if interval.isNaN { return "00:00:00" }
		let seconds = Int(interval)
		let time: (Int, Int, Int) = (seconds / 3600,
									(seconds % 3600) / 60,
									(seconds % 3600) % 60)
		if time.0 == 0 {
			return String(format: "%02d:%02d", time.1, time.2)
		}
		return String(format: "%02d:%02d:%02d", time.0, time.1, time.2)
	}
}

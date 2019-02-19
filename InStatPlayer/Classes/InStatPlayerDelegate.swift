//
//  InStatPlayerDelegate.swift
//  InStatPlayer
//

import AVFoundation

@objc public protocol InStatPlayerDelegate: class {

	@objc optional func player(_ player: InStatPlayerView, ready item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, didPlay item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, didPause item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, didStop item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, didFail error: Error, item: AVPlayerItem, at index: IndexPath)
	@objc optional func playerDidFullscreen(_ player: InStatPlayerView)
	@objc optional func player(_ player: InStatPlayerView, didChangeTo time: Float64, for item: AVPlayerItem, at index: IndexPath, total: Float64)
	@objc optional func player(_ player: InStatPlayerView, willStartFromBeginning item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, didEnd item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, willLoop item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, bufferingUnknown item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, bufferingReady item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, bufferingDelayed item: AVPlayerItem, at index: IndexPath)
	@objc optional func player(_ player: InStatPlayerView, bufferingTimeDidChangeTo time: Float64, item: AVPlayerItem, at index: IndexPath, total: Float64)
	@objc optional func player(_ player: InStatPlayerView, seekTo time: Double, for item: AVPlayerItem, at index: IndexPath)
}

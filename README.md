# InStatPlayer

![Isometric](https://user-images.githubusercontent.com/4906243/55292060-cf7e6600-53ee-11e9-943c-7e68349fb8c7.png)

[![Twitter](https://img.shields.io/badge/twitter-@JiromTomson-blue.svg?style=flat
)](https://twitter.com/JiromTomson)
[![CI Status](https://travis-ci.org/tularovbeslan/InStatPlayer.svg?branch=master)](https://travis-ci.org/tularovbeslan@gmail.com/InStatPlayer)
[![Version](https://img.shields.io/cocoapods/v/InStatPlayer.svg?style=flat)](https://cocoapods.org/pods/InStatPlayer)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-red.svg)
![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)
[![License](https://img.shields.io/cocoapods/l/InStatPlayer.svg?style=flat)](https://cocoapods.org/pods/InStatPlayer)
[![Platform](https://img.shields.io/cocoapods/p/InStatPlayer.svg?style=flat)](https://cocoapods.org/pods/InStatPlayer)

## Use

InStatPlayer is a flexible media player, the playback queue consists of an embedded array AVPlayerItem, which makes it easy to get IndexPath, it is very convenient to interact with UITableView.

Open example project to see how easy it is to manipulate the UITableView.
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## InStatPlayerDelegate

You should conforms to protocol InStatPlayerDelegate to get more information from InStatPlayer
```swift
        @objc optional func player(_ player: InStatPlayerView,
				     ready item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
			             didPlay item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     didPause item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     didStop item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     didFail error: Error,
				     item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func playerDidFullscreen(_ player: InStatPlayerView)

	@objc optional func player(_ player: InStatPlayerView,
				     didChangeTo time: Float64,
				     for item: AVPlayerItem,
				     at indexPath: IndexPath,
				     total: Float64)

	@objc optional func player(_ player: InStatPlayerView,
				     willStartFromBeginning item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     didEnd item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     willLoop item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     bufferingUnknown item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     bufferingReady item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     bufferingDelayed item: AVPlayerItem,
				     at indexPath: IndexPath)

	@objc optional func player(_ player: InStatPlayerView,
				     bufferingTimeDidChangeTo time: Float64,
				     item: AVPlayerItem,
				     at indexPath: IndexPath,
				     total: Float64)

	@objc optional func player(_ player: InStatPlayerView,
				     seekTo time: Double,
				     for item: AVPlayerItem,
				     at indexPath: IndexPath)
```
## Customization

Using the customizeControlView() method from InStatControlView you can customize the controls according to your desire.
The project example provides an example of how this can be achieved.

## Installation

InStatPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
   pod 'InStatPlayer'
```

# Author

Beslan Tularov | <a href="url"><img src="https://user-images.githubusercontent.com/4906243/54856729-037dcb00-4d0d-11e9-9d6f-8a5b8e316ff8.png" height="15"> </a> [@JiromTomson](https://twitter.com/JiromTomson)

## License

```
MIT License

Copyright (c) 2018 Beslan Tularov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

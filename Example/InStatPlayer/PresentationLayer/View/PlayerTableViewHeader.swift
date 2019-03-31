//
//  PlayerTableViewHeader.swift
//  InStatPlayer_Example
//
//  Created by workmachine on 31/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class PlayerTableViewHeader: UITableViewHeaderFooterView {

	fileprivate var title: UILabel = {

		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 15)
		label.textAlignment = .center
		label.textColor = .black
		return label
	}()

	func setup(_ title: String) {
		self.title.text = title
	}

	func setupTitle() {

		addSubview(title)
		title.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
		title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}

	open override func layoutSubviews() {
		super.layoutSubviews()

		setupTitle()
	}
}

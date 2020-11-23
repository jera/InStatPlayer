//
//  InStatSlider.swift
//  InStatPlayer
//

import UIKit

open class InStatSlider: UISlider {

	override open func trackRect(forBounds bounds: CGRect) -> CGRect {

		var result = super.trackRect(forBounds: bounds)
		result.origin.x = 0
		result.origin.y = result.origin.y - 1
		result.size.width = bounds.size.width
		result.size.height = 4
		return result
	}
}

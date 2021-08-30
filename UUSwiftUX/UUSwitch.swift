//
//  UUSwitch.swift
//  UUSwiftUX
//
//  Created by Jonathan Hays on 8/29/21.
//

#if os(iOS)

import UIKit
import UUSwiftCore

extension UISwitch
{
	@IBInspectable public var uuOffTint: UIColor?
	{
		get
		{
			return self.backgroundColor
		}

		set
		{
			self.layer.cornerRadius = 16
			self.clipsToBounds = true
			self.backgroundColor = newValue
		}
	}
}

#endif

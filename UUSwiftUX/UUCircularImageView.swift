//
//  UUCircularImageView
//  Useful Utilities - UIImageView subclass that maintains circular clipping
//
//	License:
//  You are free to use this code for whatever purposes you desire.
//  The only requirement is that you smile everytime you use it.
//
#if os(iOS)

import UIKit
import UUSwiftCore

public class UUCircularImageView: UIImageView
{
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }
}


#endif

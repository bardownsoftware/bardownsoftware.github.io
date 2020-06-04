//
//  Timer
//
//  Created by bwk on Mon.14.Nov.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

class ActiveView: UIView
{
    var borderView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(borderView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius = 0.5 * min(bounds.width, bounds.height)

        borderView.frame = CGRect(
            x: bounds.midX - radius,
            y: bounds.midY - radius,
            width: radius * 2,
            height: radius * 2)
        borderView.layer.cornerRadius = radius
    }
}

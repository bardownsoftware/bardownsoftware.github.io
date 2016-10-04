//
//  Created by bwk on Mon.05.Sep.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

extension UIColor {

    //  Create a colour from string of RGB components.
    //  For example:
    //  let color = UIColor.init(string: "255 128 0")
    //
    convenience init(string: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0

        let characterSet = CharacterSet.whitespaces

        let trimmed = string.trimmingCharacters(in: characterSet)
        let reduced = trimmed.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression)

        let components = reduced.components(separatedBy: characterSet)
        if 4 == components.count {
            red   = CGFloat(Int(components[0]) ?? 0) / 255
            green = CGFloat(Int(components[1]) ?? 0) / 255
            blue  = CGFloat(Int(components[2]) ?? 0) / 255
            alpha = CGFloat(Int(components[3]) ?? 0) / 255
        } else if 3 == components.count {
            red   = CGFloat(Int(components[0]) ?? 0) / 255
            green = CGFloat(Int(components[1]) ?? 0) / 255
            blue  = CGFloat(Int(components[2]) ?? 0) / 255
            alpha = 1.0
        } else {
            print("### bad color string: \(string) has \(components.count) components")
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(r: Int, g: Int, b: Int, a: Int) {
        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    class func appLightGray() -> UIColor { return UIColor(r:230, g:230, b:230, a:255) }
    class func appRed      () -> UIColor { return UIColor(r:222, g: 70, b:106, a:255) }
    class func appGreen    () -> UIColor { return UIColor(r:  0, g:228, b:106, a:255) }
    class func appBlue     () -> UIColor { return UIColor(r: 60, g:118, b:212, a:255) }
    class func appOrange   () -> UIColor { return UIColor(r:255, g:147, b:  0, a:255) }

    class func ready () -> UIColor { return appBlue() }
    class func go    () -> UIColor { return appGreen() }
    class func rest  () -> UIColor { return appOrange() }
}

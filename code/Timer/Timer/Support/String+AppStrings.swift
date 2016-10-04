//
//  Created by bwk on Fri.09.Sep.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import Foundation

extension String {

    static func ready() -> String { return NSLocalizedString("Ready", comment: "Ready state") }
    static func go()    -> String { return NSLocalizedString("Go", comment: "Go state") }
    static func rest()  -> String { return NSLocalizedString("Rest", comment: "Rest state") }
    static func done()  -> String { return NSLocalizedString("Done", comment: "Done state") }

    static func newTimer()  -> String { return NSLocalizedString("New Timer", comment: "New timer name") }
}

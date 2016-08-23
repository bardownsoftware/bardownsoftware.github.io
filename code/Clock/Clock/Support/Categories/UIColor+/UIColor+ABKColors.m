//
//  Created by Brian Kramer on 15.09.14.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "UIColor+ABKColors.h"

@implementation UIColor (ABKColors)

+ (UIColor *)abk_redColor     { return [UIColor kdg_colorWithRed:222 green: 70 blue:106 alpha:255]; }
+ (UIColor *)abk_blueColor    { return [UIColor kdg_colorWithRed:103 green:185 blue:225 alpha:255]; }
+ (UIColor *)abk_greenColor   { return [UIColor kdg_colorWithRed: 23 green:173 blue:170 alpha:255]; }
+ (UIColor *)abk_yellowColor  { return [UIColor kdg_colorWithRed:255 green:232 blue:127 alpha:255]; }
+ (UIColor *)abk_orangeColor  { return [UIColor kdg_colorWithRed:239 green:125 blue: 43 alpha:255]; }

+ (UIColor *)abk_selectionColor { return [UIColor kdg_colorWithRed: 74 green:217 blue: 99 alpha:255]; }

@end

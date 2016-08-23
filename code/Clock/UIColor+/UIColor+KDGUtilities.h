//
//  Created by Brian Kramer on 15.09.14.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KDGUtilities)

/**
 Return color initialized with RGB components where all values range from 0 to 255.
 */
+ (UIColor *)kdg_colorWithRed:(NSInteger)red
                        green:(NSInteger)green
                         blue:(NSInteger)blue
                        alpha:(NSInteger)alpha;

/**
 String must be 4 integer values separated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
+ (UIColor *)kdg_colorWithRGBString:(NSString *)string;

/**
 Return color as string of 4 integer values seperated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
- (NSString *)kdg_asRGBString;

/**
 Return red, green, and blue color components.
 Works on all colors regardless of color space.
 */
- (void)kdg_getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

/**
 Test equality of colors.
 */
- (BOOL)kdg_isEqualToColor:(UIColor *)color;

@end

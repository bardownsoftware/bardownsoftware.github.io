//
//  Created by Brian Kramer on 15.09.14.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KDGUtilities)

/**
 Return random color.
 */
+ (UIColor *)kdg_random;

/**
 Return color initialized with RGB components where all values range from 0 to 255.
 */
+ (UIColor *)kdg_colorWithRed:(NSInteger)red
                        green:(NSInteger)green
                         blue:(NSInteger)blue
                        alpha:(NSInteger)alpha;

/**
 Return color initialized with HSB components where hue ranges from 0 to 359,
 saturation and brightness range from 0 to 100, and alpha ranges from 0 to 255.
 */
+ (UIColor *)kdg_colorWithHue:(NSInteger)hue
                   saturation:(NSInteger)saturation
                   brightness:(NSInteger)brightness
                        alpha:(NSInteger)alpha;

/**
 String must be 4 integer values separated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
+ (UIColor *)kdg_colorWithString:(NSString *)string; // todo: remove
+ (UIColor *)kdg_colorWithRGBString:(NSString *)string;

/**
 String must be 4 integer values separated by a single space.
 The values represent the hue, saturation, brightness, and alpha color components.
 Hue value ranges from 0 to 359. Saturation and brightness range from 0 to 100, and alpha 
 ranges from 0 to 255.
 */
+ (UIColor *)kdg_colorWithHSBString:(NSString *)string;

/**
 Return color as string of 4 integer values seperated by a single space.
 Each value ranges from 0 to 255 and represent the red, green, blue, and alpha color components.
 */
- (NSString *)kdg_asString;
- (NSString *)kdg_asRGBString;
- (NSString *)kdg_asHSBString;

/**
 Return red, green, and blue color components.
 Works on all colors regardless of color space.
 */
- (void)kdg_getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

/**
 Return hue, saturation, and brightness color components.
 Works on all colors regardless of color space.
 */
- (void)kdg_getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;

/**
 Test equality of colors.
 */
- (BOOL)kdg_isEqualToColor:(UIColor *)color;

/**
 Return a lighter color.
 */
- (UIColor *)kdg_lighterColor;

/**
 Return a darker color.
 */
- (UIColor *)kdg_darkerColor;

/**
 Return current color with hue.
 */
- (UIColor *)kdg_colorWithHue:(CGFloat)hue;

/**
 Return current color with saturation.
 */
- (UIColor *)kdg_colorWithSaturation:(CGFloat)saturation;

/**
 Return current color with brightness.
 */
- (UIColor *)kdg_colorWithBrightness:(CGFloat)brightness;

/**
 Return a color which is a linear interpolation between the receiver
 and the provided color argument.
 */
- (UIColor *)kdg_mixWith:(UIColor *)color value:(CGFloat)value;

#pragma mark - tests;

+ (void)runTests;

@end

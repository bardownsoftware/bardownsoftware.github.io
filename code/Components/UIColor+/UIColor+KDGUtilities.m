//
//  Created by Brian Kramer on 15.09.14.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import "UIColor+KDGUtilities.h"

@implementation UIColor (KDGUtilities)

+ (UIColor *)kdg_random
{
    return [UIColor kdg_colorWithRed:arc4random() % 255
                               green:arc4random() % 255
                                blue:arc4random() % 255
                               alpha:255];
}

+ (UIColor *)kdg_colorWithRed:(NSInteger)red
                        green:(NSInteger)green
                         blue:(NSInteger)blue
                        alpha:(NSInteger)alpha
{
    return [UIColor colorWithRed:red   / 255.0
                           green:green / 255.0
                            blue:blue  / 255.0
                           alpha:alpha / 255.0];
}

+ (UIColor *)kdg_colorWithRGBString:(NSString *)string
{
    UIColor *color = [UIColor whiteColor];

    if (string)
    {
        NSArray *values = [string componentsSeparatedByString:@" "];
        if (values.count == 4)
        {
            CGFloat red   = [values[0] floatValue] / 255.0;
            CGFloat green = [values[1] floatValue] / 255.0;
            CGFloat blue  = [values[2] floatValue] / 255.0;
            CGFloat alpha = [values[3] floatValue] / 255.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        }
    }

    return color;
}

- (NSString *)kdg_asRGBString
{
    CGFloat red, green, blue, alpha;

    [self kdg_getRed:&red green:&green blue:&blue alpha:&alpha];

    NSInteger r = red   * 255;
    NSInteger g = green * 255;
    NSInteger b = blue  * 255;
    NSInteger a = alpha * 255;

    return [NSString stringWithFormat:@"%ld %ld %ld %ld", (long)r, (long)g, (long)b, (long)a];
}

- (void)kdg_getRed:(CGFloat *)red
             green:(CGFloat *)green
              blue:(CGFloat *)blue
             alpha:(CGFloat *)alpha
{
    CGFloat white, r, g, b, a;

    if ([self getRed:&r green:&g blue:&b alpha:&a])
    {
        *red   = r;
        *green = g;
        *blue  = b;
        *alpha = a;
    }
    else if ([self getWhite:&white alpha:&a])
    {
        *red   = white;
        *green = white;
        *blue  = white;
        *alpha = a;
    }
    else
    {
        *red   = 0.0;
        *green = 0.0;
        *blue  = 0.0;
        *alpha = 1.0;
        NSLog(@"# error: couldn't get red, green, and blue components.");
    }
}

- (BOOL)kdg_isEqualToColor:(UIColor *)color
{
    NSString *aString = [self kdg_asRGBString];
    NSString *bString = [color kdg_asRGBString];
    return [aString isEqualToString:bString];
}

@end

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

+ (UIColor *)kdg_colorWithHue:(NSInteger)hue
                   saturation:(NSInteger)saturation
                   brightness:(NSInteger)brightness
                        alpha:(NSInteger)alpha
{
    return [UIColor colorWithHue:hue        / 360.0
                      saturation:saturation / 100.0
                      brightness:brightness / 100.0
                           alpha:alpha      / 255.0];

}

+ (UIColor *)kdg_colorWithString:(NSString *)string
{
    return [UIColor kdg_colorWithRGBString:string];
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

+ (UIColor *)kdg_colorWithHSBString:(NSString *)string
{
    UIColor *color = [UIColor whiteColor];

    if (string)
    {
        NSArray *values = [string componentsSeparatedByString:@" "];
        if (values.count == 4)
        {
            NSInteger h, s, b, a;
            h = [values[0] integerValue];
            s = [values[1] integerValue];
            b = [values[2] integerValue];
            a = [values[3] integerValue];

            if (h < 0) h = 0;
            else if (h >= 360) h = h % 360;

            if (s < 0) s = 0;
            else if (s > 100) s = 100;

            if (b < 0) b = 0;
            else if (b > 100) b = 100;

            if (a < 0) a = 0;
            else if (a > 255) a = 255;

            CGFloat hue        = h / 360.0;
            CGFloat saturation = s / 100.0;
            CGFloat brightness = b / 100.0;
            CGFloat alpha      = a / 255.0;

            color = [UIColor colorWithHue:hue
                               saturation:saturation
                               brightness:brightness
                                    alpha:alpha];
        }
    }

    return color;
}

- (NSString *)kdg_asString;
{
    return [self kdg_asRGBString];
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

- (NSString *)kdg_asHSBString
{
    CGFloat hue, saturation, brightness, alpha;

    [self kdg_getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    NSInteger h = hue        * 360;
    NSInteger s = saturation * 100;
    NSInteger b = brightness * 100;
    NSInteger a = alpha      * 255;

    return [NSString stringWithFormat:@"%ld %ld %ld %ld", (long)h, (long)s, (long)b, (long)a];
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

- (void)kdg_getHue:(CGFloat *)hue
        saturation:(CGFloat *)saturation
        brightness:(CGFloat *)brightness
             alpha:(CGFloat *)alpha
{
    CGFloat white, h, s, b, a;

    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    {
        if (h >= 1.0) h = 0.0;

        *hue        = h;
        *saturation = s;
        *brightness = b;
        *alpha      = a;
    }
    else if ([self getWhite:&white alpha:&a])
    {
        *hue        = 0.0;
        *saturation = 0.0;
        *brightness = white;
        *alpha      = a;
    }
    else
    {
        *hue        = 0.0;
        *saturation = 0.0;
        *brightness = 0.0;
        *alpha      = 1.0;
        NSLog(@"# error: couldn't get hue, saturation, and brightness components.");
    }
}

- (BOOL)kdg_isEqualToColor:(UIColor *)color
{
    NSString *aString = [self kdg_asRGBString];
    NSString *bString = [color kdg_asRGBString];
    return [aString isEqualToString:bString];
}

- (UIColor *)kdg_lighterColor
{
    UIColor *color = [UIColor colorWithCGColor:self.CGColor];

    CGFloat hue, saturation, brightness, alpha;

    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        color = [UIColor colorWithHue:hue
                           saturation:saturation
                           brightness:MIN(brightness * 1.333, 1.0)
                                alpha:alpha];
    }

    return color;
}

- (UIColor *)kdg_darkerColor
{
    UIColor *color = [UIColor colorWithCGColor:self.CGColor];

    CGFloat hue, saturation, brightness, alpha;

    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        color = [UIColor colorWithHue:hue
                           saturation:saturation
                           brightness:brightness * 0.75
                                alpha:alpha];
    }

    return color;
}

- (UIColor *)kdg_colorWithHue:(CGFloat)hue
{
    CGFloat h, s, b, alpha;
    [self kdg_getHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:s brightness:b alpha:alpha];
}

- (UIColor *)kdg_colorWithSaturation:(CGFloat)saturation
{
    CGFloat h, s, b, alpha;
    [self kdg_getHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:h saturation:saturation brightness:b alpha:alpha];
}

- (UIColor *)kdg_colorWithBrightness:(CGFloat)brightness
{
    CGFloat h, s, b, alpha;
    [self kdg_getHue:&h saturation:&s brightness:&b alpha:&alpha];
    return [UIColor colorWithHue:h saturation:s brightness:brightness alpha:alpha];
}

- (UIColor *)kdg_mixWith:(UIColor *)color value:(CGFloat)value
{
    CGFloat redStart, greenStart, blueStart, alphaStart;
    CGFloat redEnd, greenEnd, blueEnd, alphaEnd;

    [self kdg_getRed:&redStart green:&greenStart blue:&blueStart alpha:&alphaStart];
    [color kdg_getRed:&redEnd green:&greenEnd blue:&blueEnd alpha:&alphaEnd];

    CGFloat red   = redStart   + value * (redEnd   - redStart);
    CGFloat green = greenStart + value * (greenEnd - greenStart);
    CGFloat blue  = blueStart  + value * (blueEnd  - blueStart);
    CGFloat alpha = alphaStart + value * (alphaEnd - alphaStart);

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - test framework

//  todo: move test framework out to own files.

static NSInteger sTestFailures = 0;
static NSString *sTestName = @"";

void beginTest(NSString *testName)
{
    sTestFailures = 0;

    sTestName = testName;
}

void endTest()
{
    NSString *result = @"passed";

    if (sTestFailures > 0)
    {
        result = [NSString stringWithFormat:@"%ld %@", (long)sTestFailures, sTestFailures == 1 ? @"failure" : @"failures"];

    }
    NSLog(@"--- %@: %@", sTestName, result);
}

void testAssert(NSString *expectingString, NSString *resultString)
{
    if (![expectingString isEqualToString:resultString])
    {
        sTestFailures++;
        NSLog(@"### test failure: expected %@, got %@", expectingString, resultString);
    }
}

#pragma mark - tests

+ (void)runTests
{
    [self testRGBColorStrings];
    [self testHSBColorStrings];
}

+ (void)testRGBColorStrings
{
    beginTest(@"testRGBColorStrings");

    NSArray *colorStrings = @[@"255 255 255 255",
                              @"0 0 0 255",
                              @"255 0 0 255",
                              @"0 255 0 255",
                              @"0 0 255 255",
                              @"255 255 0 255",
                              @"255 0 255 255",
                              @"0 255 255 255",
                              @"255 128 0 255",
                              @"255 0 128 255",
                              @"0 128 255 255",
                              @"128 0 255 255",
                              @"0 255 128 255",
                              @"128 255 0 255",
                              ];

    for (NSString *colorString in colorStrings)
    {
        UIColor *color = [UIColor kdg_colorWithRGBString:colorString];
        NSString *resultString = [color kdg_asRGBString];
        testAssert(colorString, resultString);
    }

    for (NSInteger a = 0; a <= 255; a++)
    {
        for (NSInteger c = 0; c <= 255; c++)
        {
            NSString *colorString = [NSString stringWithFormat:@"%ld %ld %ld %ld", (long)c, (long)c, (long)c, (long)a];
            UIColor *color = [UIColor kdg_colorWithRGBString:colorString];
            NSString *resultString = [color kdg_asRGBString];
            testAssert(colorString, resultString);
        }
    }

    endTest();
}

+ (void)testHSBColorStrings
{
    beginTest(@"testHSBColorStrings");

    NSArray *colorStrings = @[@"0 100 100 255",
                              @"60 100 100 255",
                              @"120 100 100 255",
                              @"180 100 100 255",
                              @"240 100 100 255",
                              @"300 100 100 255",
                              ];

    UIColor *color;

    for (NSString *colorString in colorStrings)
    {
        color = [UIColor kdg_colorWithHSBString:colorString];
        testAssert(colorString, [color kdg_asHSBString]);
    }

    NSString *colorString;
    NSString *resultString;

    colorString = @"360 100 100 255";
    color = [UIColor kdg_colorWithHSBString:colorString];
    testAssert(@"0 100 100 255", [color kdg_asHSBString]);

    colorString = @"0 0 0 255";
    color = [UIColor kdg_colorWithHSBString:colorString];
    testAssert(colorString, [color kdg_asHSBString]);

    {
        //  if saturation and brightness are 0 then always get black regardless of hue.
        //
        for (NSInteger hue = 0; hue <= 360; hue += 10)
        {
            colorString = [NSString stringWithFormat:@"%ld 0 0 255", (long)hue];
            color = [UIColor kdg_colorWithHSBString:colorString];
            testAssert(@"0 0 0 255", [color kdg_asHSBString]);
        }

        for (NSInteger hue = 0; hue <= 360; hue += 10)
        {
            //  if brightness is 0 then always get black regardless of hue.
            //
            for (NSInteger saturation = 0; saturation <= 100; saturation += 10)
            {
                colorString = [NSString stringWithFormat:@"%ld %ld 0 255", (long)hue, (long)saturation];
                color = [UIColor kdg_colorWithHSBString:colorString];
                testAssert(@"0 0 0 255", [color kdg_asHSBString]);
            }

            //  if saturation is 0 then always get 0 hue and proper brightness value.
            //
            for (NSInteger brightness = 0; brightness <= 100; brightness += 10)
            {
                colorString = [NSString stringWithFormat:@"%ld 0 %ld 255", (long)hue, (long)brightness];
                color = [UIColor kdg_colorWithHSBString:colorString];
                resultString = [NSString stringWithFormat:@"0 0 %ld 255", (long)brightness];
                testAssert(resultString, [color kdg_asHSBString]);
            }
        }
    }
    
    endTest();
}

@end

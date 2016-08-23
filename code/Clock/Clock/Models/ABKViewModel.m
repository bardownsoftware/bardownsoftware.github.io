//
//  Created by bwk on 19.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "ABKViewModel.h"
#import "UIColor+KDGUtilities.h"
#import "NSUserDefaults+KDGUtilities.h"

//  Values must match property name as they are used in Key-Value Observing.
//
NSString * const ABKViewModelForegroundColor = @"foregroundColor";
NSString * const ABKViewModelBackgroundColor = @"backgroundColor";
NSString * const ABKViewModelUse24HourClock = @"use24HourClock";
NSString * const ABKViewModelFontName = @"fontName";

//  Keys for saving values to user defaults.
//
static NSString * const ABKViewModelKeyForegroundColor = @"ABKViewModelKeyForegroundColor";
static NSString * const ABKViewModelKeyBackgroundColor = @"ABKViewModelKeyBackgroundColor";
static NSString * const ABKViewModelKeyUse24HourClock = @"ABKViewModelKeyUse24HourClock";
static NSString * const ABKViewModelKeyFontName = @"ABKViewModelKeyFontName";

@implementation ABKViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadValues];
    }
    return self;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;

    [[NSUserDefaults kdg_defaults] setObject:[_foregroundColor kdg_asRGBString]
                                      forKey:ABKViewModelKeyForegroundColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;

    [[NSUserDefaults kdg_defaults] setObject:[_backgroundColor kdg_asRGBString]
                                      forKey:ABKViewModelKeyBackgroundColor];
}

- (void)setUse24HourClock:(BOOL)use24HourClock
{
    _use24HourClock = use24HourClock;

    [[NSUserDefaults kdg_defaults] setBool:_use24HourClock
                                    forKey:ABKViewModelKeyUse24HourClock];
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;

    [[NSUserDefaults kdg_defaults] setObject:_fontName
                                      forKey:ABKViewModelKeyFontName];
}

- (void)loadValues
{
    UIColor *defaultForegroundColor = [UIColor whiteColor];
    UIColor *defaultBackgroundColor = [UIColor blackColor];
    NSString *defaultFontName = @"AvenirNext-UltraLight";
    BOOL defaultUse24HourClock = NO;

    NSUserDefaults *userDefaults = [NSUserDefaults kdg_defaults];

    _foregroundColor = [userDefaults kdg_colorForKey:ABKViewModelKeyForegroundColor
                                        defaultValue:defaultForegroundColor];

    _backgroundColor = [userDefaults kdg_colorForKey:ABKViewModelKeyBackgroundColor
                                        defaultValue:defaultBackgroundColor];

    _use24HourClock = [userDefaults kdg_boolForKey:ABKViewModelKeyUse24HourClock
                                      defaultValue:defaultUse24HourClock];

    _fontName = [userDefaults kdg_stringForKey:ABKViewModelKeyFontName
                                      defaultValue:defaultFontName];
}

@end

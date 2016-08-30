//
//  Created by bwk on 19.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ABKViewModelForegroundColor;
extern NSString * const ABKViewModelBackgroundColor;
extern NSString * const ABKViewModelUse24HourClock;
extern NSString * const ABKViewModelDigital;
extern NSString * const ABKViewModelFontName;

@interface ABKViewModel : NSObject

@property (nonatomic, copy) UIColor *foregroundColor;
@property (nonatomic, copy) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL use24HourClock;
@property (nonatomic, assign) BOOL digital;
@property (nonatomic, copy) NSString *fontName;

@end

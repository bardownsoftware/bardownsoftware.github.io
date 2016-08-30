//
//  Created by bwk on 17.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDGCustomView.h"

@interface ABKTimeView : KDGCustomView

@property (nonatomic, copy) NSString *fontName;

@property (nonatomic, copy)   IBInspectable UIColor *textColor;
@property (nonatomic, copy)   IBInspectable UIColor *color;
@property (nonatomic, assign) IBInspectable BOOL digital;
@property (nonatomic, assign) IBInspectable BOOL use24HourDisplay;
@property (nonatomic, assign) IBInspectable BOOL displaySeconds;
@property (nonatomic, assign) IBInspectable BOOL displayAMPM;

- (void)start;
- (void)stop;

@end

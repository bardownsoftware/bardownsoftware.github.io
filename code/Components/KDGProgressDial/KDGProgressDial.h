//
//  Created by bwk on 17.08.15.
//  Copyright (c) 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface KDGProgressDial : UIControl

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat trackThickness;
@property (nonatomic, assign) CGFloat progressThickness;
@property (nonatomic, assign) CGFloat handleRadius;
@property (nonatomic, assign) CGFloat inset;

@property (nonatomic, copy) UIColor *trackColor;
@property (nonatomic, copy) UIColor *progressColor;
@property (nonatomic, copy) UIColor *handleColor;
@property (nonatomic, copy) UIColor *highlightColor;

@property (nonatomic, assign) NSInteger numberOfStops;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

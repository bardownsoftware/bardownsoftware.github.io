//
//  Created by bwk on 17.08.15.
//  Copyright (c) 2015 Bar Down Software. All rights reserved.
//

#import "KDGProgressDial.h"
#import "KDGUtilities.h"

static const CGFloat kFramesPerSecond = 100.0;
static const CGFloat kDurationInSeconds = 0.8;
static const CGFloat kDefaultHandleRadius = 12;

@interface KDGProgressDial ()

@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) NSInteger originalPosition;
@property (nonatomic, assign) BOOL dragged;

@end

@implementation KDGProgressDial

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];

    _trackColor = [UIColor lightGrayColor];
    _progressColor = [UIColor orangeColor];
    _handleColor = [UIColor whiteColor];
    _highlightColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    _trackThickness = 0.5;
    _progressThickness = 8.0;
    _handleRadius = kDefaultHandleRadius;
    _inset = _handleRadius + 1.0;
    _numberOfStops = 0;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {

    CGFloat endProgress = progress;
    if (endProgress > 1.0) {
        endProgress = 1.0;
    } else if (endProgress < 0.0) {
        endProgress = 0.0;
    }

    //  Don't bother animating if the change is too small.
    //
    BOOL delta = fabs(endProgress - _progress);

    if (animated && delta > 0.05) {
        if (self.progressTimer) {
            [self.progressTimer invalidate];
            self.progressTimer = nil;
        }

        CGFloat seconds = fabs(endProgress - _progress) * kDurationInSeconds;
        CGFloat numberOfFrames = kFramesPerSecond * seconds;
        CGFloat increment = (endProgress - _progress) / numberOfFrames;

        NSDictionary *userInfo = @{ @"increment" : [NSNumber numberWithFloat:increment],
                                    @"endValue" : [NSNumber numberWithFloat:endProgress]
                                   };
        self.progressTimer
        = [NSTimer scheduledTimerWithTimeInterval:1.0 / kFramesPerSecond
                                           target:self
                                         selector:@selector(updateProgressWithTimer:)
                                         userInfo:userInfo
                                          repeats:YES];

    } else {
        _progress = endProgress;
        [self setNeedsDisplay];
    }
}

- (void)updateProgressWithTimer:(NSTimer *)timer {

    CGFloat increment = [timer.userInfo[@"increment"] floatValue];
    CGFloat endValue = [timer.userInfo[@"endValue"] floatValue];

    _progress += increment;

    if ((increment < 0 && _progress <= endValue) ||
        (increment > 0 && _progress >= endValue)) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        _progress = endValue;
    }

    [self setNeedsDisplay];
}

#pragma mark - highlight

- (void)highlight {
    self.highlighted = YES;
    [self setNeedsDisplay];
}

- (void)unhighlight {
    self.highlighted = NO;
    [self setNeedsDisplay];
}

#pragma mark - draw

- (CGFloat)radius {
    CGFloat diameter = MIN(self.bounds.size.width, self.bounds.size.height);
    CGFloat radius = diameter * 0.5 - self.inset;
    return radius;
}

- (CGRect)handleRect {

    CGPoint centre = KDGRectCenter(self.bounds);
    CGFloat angle = self.progress * 2 * M_PI - M_PI_2;
    CGFloat radius = [self radius];

    CGFloat x = cosf(angle) * radius;
    CGFloat y = sinf(angle) * radius;

    CGFloat handleRadius = self.handleRadius;

    CGRect handleRect = CGRectMake(centre.x - handleRadius + x,
                                   centre.y - handleRadius + y,
                                   2.0 * handleRadius,
                                   2.0 * handleRadius);

    return handleRect;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGPoint centre = KDGRectCenter(self.bounds);
    CGFloat radius = [self radius];

    //  Track.
    {
        CGContextBeginPath(context);
        CGContextAddArc(context,
                        centre.x,
                        centre.y,
                        radius,
                        0,
                        2 * M_PI,
                        0);

        CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor);
        CGContextSetLineWidth(context, self.trackThickness);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }

    if (self.isUserInteractionEnabled) {

        //  Handle.
        //
        [self drawHandle:context];

    } else {

        //  Progress.
        //
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = self.progress * 2 * M_PI - M_PI_2;

        CGContextBeginPath(context);
        CGContextAddArc(context,
                        centre.x,
                        centre.y,
                        radius,
                        startAngle,
                        endAngle,
                        0);

        CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
        CGContextSetLineWidth(context, self.progressThickness);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }

    CGContextRestoreGState(context);
}

- (void)drawHandle:(CGContextRef)context {

    if (self.userInteractionEnabled) {
        UIColor *fillColor = self.highlighted ? self.highlightColor : self.handleColor;
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.trackColor.CGColor);
        CGContextSetLineWidth(context, self.trackThickness);

        CGRect handleRect = [self handleRect];
        CGContextFillEllipseInRect(context, handleRect);
        CGContextStrokeEllipseInRect(context, handleRect);
    }
}

#pragma mark - touches

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point {

    CGPoint centre = KDGRectCenter(self.bounds);
    CGFloat dx = point.x - centre.x;
    CGFloat dy = point.y - centre.y;
    CGFloat d = sqrtf(dx * dx + dy * dy);

    return d;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self pointInsideHandle:point];
}

- (BOOL)pointInsideHandle:(CGPoint)point {

    CGRect handleRect = [self handleRect];
    handleRect = CGRectInset(handleRect, -14.0, -14.0);
    BOOL result = CGRectContainsPoint(handleRect, point);
    return result;
}

- (BOOL)pointInsideTrack:(CGPoint)point {

    CGFloat distance = [self calculateDistanceFromCenter:point];
    CGFloat radius = [self radius];
    BOOL result = fabs(distance - radius) < 10.0;
    return result;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    [self highlight];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint touchPoint = [touch locationInView:self];

    CGFloat newValue = 0.0;

    //  Calculate new position.
    //
    CGPoint centre = KDGRectCenter(self.bounds);

    CGFloat degrees = KDGAngleBetweenPoints(centre, touchPoint);

    //  Convert angle to be 0 at 12 o'clock and increase clockwise.
    //
    degrees -= 90.0;
    if (degrees < 0.0) degrees += 360.0;
    degrees = 360.0 - degrees;

    if (self.numberOfStops > 0) {
        CGFloat increment = roundf(360.0 / self.numberOfStops);
        CGFloat position = roundf(degrees / increment);
        newValue = position / self.numberOfStops;

    } else {
        newValue = degrees / 360.0;
    }

    _progress = newValue;

    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    [self unhighlight];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {

    [self unhighlight];
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    self.dragged = NO;
    UITouch *touch = [touches anyObject];
    [self beginTrackingWithTouch:touch withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    self.dragged = YES;
    UITouch *touch = [touches anyObject];
    [self continueTrackingWithTouch:touch withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self endTrackingWithTouch:touch withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelTrackingWithEvent:event];
}

@end


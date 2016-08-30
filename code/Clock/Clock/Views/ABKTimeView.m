//
//  Created by bwk on 17.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "ABKTimeView.h"
#import "ABKViewModel.h"
#import "KDGUtilities.h"

static NSTimeInterval kTimerInterval = 0.2;
static CGFloat kMaxFontSize = 256.0;

@interface ABKTimeView ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSTimer         *timer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ABKTimeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initTimeView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initTimeView];
    }
    return self;
}

- (void)initTimeView
{
    UIView *view = [self loadViewFromNib];
    [self constrainCustomView:view];

    self.textColor = [UIColor whiteColor];
    self.color = [UIColor whiteColor];

    _digital = YES;
    _displayAMPM = NO;
    _displaySeconds = NO;
    _use24HourDisplay = NO;

    [self setUpDateFormatter];

    _fontName = @"AvenirNext-UltraLight";
    self.timeLabel.adjustsFontSizeToFitWidth = YES;

    [self updateFont];
}

- (void)updateConstraints
{
    [self updateCustomViewConstraints];
    [super updateConstraints];
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setUpDateFormatter
{
    BOOL use24HourDisplay = self.use24HourDisplay;
    BOOL showSeconds = self.displaySeconds;
    BOOL showAMPM = self.displayAMPM;

    self.dateFormatter = [[NSDateFormatter alloc] init];

    NSMutableString *dateFormat = [[NSMutableString alloc] initWithString:@""];

    if (use24HourDisplay) [dateFormat appendString:@"HH"];
    else                  [dateFormat appendString:@"h"];

    [dateFormat appendString:@":mm"];

    if (showSeconds) [dateFormat appendString:@":ss"];

    if (showAMPM) [dateFormat appendString:@" a"];

    [self.dateFormatter setDateFormat:dateFormat];
}

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    [self updateFont];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.timeLabel.textColor = textColor;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.timeLabel.textColor = color;
}

- (void)setDigital:(BOOL)digital {
    _digital = digital;
    self.timeLabel.hidden = !digital;
    [self setNeedsDisplay];
}

- (void)setUse24HourDisplay:(BOOL)use24HourDisplay
{
    _use24HourDisplay = use24HourDisplay;
    [self setUpDateFormatter];
}

- (void)setDisplaySeconds:(BOOL)displaySeconds
{
    _displaySeconds = displaySeconds;
    [self setUpDateFormatter];
}

- (void)setDisplayAMPM:(BOOL)displayAMPM
{
    _displayAMPM = displayAMPM;
    [self setUpDateFormatter];
}

- (void)start
{
    [self update];
    [self startTimer];
}

- (void)stop
{
    [self stopTimer];
}

- (void)update
{
    NSDate *now = [NSDate date];
    NSString *time = [self.dateFormatter stringFromDate:now];
    self.timeLabel.text = time;
    if (!self.digital) {
        [self setNeedsDisplay];
    }
}

- (void)updateFont {
    self.timeLabel.font = [UIFont fontWithName:self.fontName
                                          size:kMaxFontSize];
}

#pragma mark - timer

- (void)startTimer
{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFired:(NSTimer *)timer
{
    [self update];
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect {

    BOOL drawBorder = NO;
    BOOL drawMinute15Ticks = YES;
    BOOL drawMinute5Ticks = YES;
    BOOL drawMinuteTicks = YES;
    BOOL drawRoundTicks = YES;
    BOOL drawCentre = NO;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetShouldAntialias(context, true);
    CGContextSetLineCap(context, kCGLineCapRound);

    if (!self.digital) {

        CGContextSaveGState(context);

        CGFloat faceThickness = 2.0;
        CGFloat hourHandThickness = 4.0;
        CGFloat minuteHandThickness = 3.0;
        CGFloat hourHandLength = 0.6;
        CGFloat minuteHandLength = 0.85;
        CGFloat centreSize = 4.0;

        CGFloat minuteTickLength = 0.0;
        CGFloat minute5TickLength = 0.03;
        CGFloat minute15TickLength = 0.04;

        CGFloat minuteTickSize = 1.0;
        CGFloat minute5TickSize = 3.0;
        CGFloat minute15TickSize = 4.0;

        CGFloat minuteTickThickness = 0.75;
        CGFloat minute5TickThickness = 1.5;
        CGFloat minute15TickThickness = 3.0;

        CGFloat inset = 1.0 + 0.5 * faceThickness;
        CGRect faceBounds = CGRectInset(self.bounds, inset, inset);
        CGFloat radius = 0.5 * MIN(faceBounds.size.width, faceBounds.size.height);
        CGPoint centre = KDGRectCenter(self.bounds);

        faceBounds = CGRectMake(centre.x - radius,
                                centre.y - radius,
                                2.0 * radius,
                                2.0 * radius);

        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGContextSetFillColorWithColor(context, self.color.CGColor);

        //  Face border.
        //
        if (drawBorder) {
            CGContextSetLineWidth(context, faceThickness);
            CGContextStrokeEllipseInRect(context, faceBounds);
        }

        CGFloat x, y;
        CGPoint startPoint, endPoint;

        //  Ticks.
        //
        for (NSInteger degrees = 0; degrees < 360; degrees += 6) {
            x = cos(DEGREES_TO_RADIANS((CGFloat)degrees));
            y = sin(DEGREES_TO_RADIANS((CGFloat)degrees));

            endPoint.x = centre.x + x * radius;
            endPoint.y = centre.y + y * radius;

            if (0 == degrees % 90 && drawMinute15Ticks) {
                if (drawRoundTicks){
                    CGContextFillEllipseInRect(context, KDGRectMake(endPoint, minute15TickSize, minute15TickSize));

                } else {
                    CGContextSetLineWidth(context, minute15TickThickness);
                    startPoint.x = centre.x + x * (1.0 - minute15TickLength) * radius;
                    startPoint.y = centre.y + y * (1.0 - minute15TickLength) * radius;

                    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                    CGContextStrokePath(context);
                }

            } else if (0 == degrees % 30 && drawMinute5Ticks) {
                if (drawRoundTicks){
                    CGContextFillEllipseInRect(context, KDGRectMake(endPoint, minute5TickSize, minute5TickSize));

                } else {
                    CGContextSetLineWidth(context, minute5TickThickness);
                    startPoint.x = centre.x + x * (1.0 - minute5TickLength) * radius;
                    startPoint.y = centre.y + y * (1.0 - minute5TickLength) * radius;

                    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                    CGContextStrokePath(context);
                }

            } else if (drawMinuteTicks) {
                if (drawRoundTicks){
                    CGContextFillEllipseInRect(context, KDGRectMake(endPoint, minuteTickSize, minuteTickSize));

                } else {
                    CGContextSetLineWidth(context, minuteTickThickness);
                    startPoint.x = centre.x + x * (1.0 - minuteTickLength) * radius;
                    startPoint.y = centre.y + y * (1.0 - minuteTickLength) * radius;

                    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
                    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
                    CGContextStrokePath(context);
                }
            }
        }

        //  Hands.
        //
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components
        = [calendar components:(NSCalendarUnitHour |
                                NSCalendarUnitMinute |
                                NSCalendarUnitSecond)
                      fromDate:now];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSInteger seconds = [components second];

        CGFloat hourHandDegrees = 360.0 * (hour + minute / 60.0) / 12.0;
        CGFloat minuteHandDegrees = 360.0 * (minute + seconds / 60.0 ) / 60.0;

        [self drawHand:context
               degrees:hourHandDegrees length:hourHandLength * radius
             thickness:hourHandThickness];

        [self drawHand:context
               degrees:minuteHandDegrees length:minuteHandLength * radius
             thickness:minuteHandThickness];
        
        if (drawCentre) {
            CGContextFillEllipseInRect(context,
                                       KDGRectMake(centre,
                                                   centreSize,
                                                   centreSize));
        }
        
        CGContextRestoreGState(context);
    }
}

- (void)drawHand:(CGContextRef)context
         degrees:(CGFloat)degrees
          length:(CGFloat)length
       thickness:(CGFloat)thickness {

    CGFloat adjustedDegrees = degrees - 90.0;

    CGFloat x = cos(DEGREES_TO_RADIANS((CGFloat)adjustedDegrees));
    CGFloat y = sin(DEGREES_TO_RADIANS((CGFloat)adjustedDegrees));

    CGPoint centre = KDGRectCenter(self.bounds);
    CGPoint endPoint;

    endPoint.x = centre.x + x * length;
    endPoint.y = centre.y + y * length;

    CGContextSetLineWidth(context, thickness);
    CGContextMoveToPoint(context, centre.x, centre.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

@end

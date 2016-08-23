//
//  Created by bwk on 17.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "ABKTimeView.h"
#import "ABKViewModel.h"

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

@end

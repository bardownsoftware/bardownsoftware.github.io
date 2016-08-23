//
//  Created by bwk on Sun.03.Apr.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import "KDGColorSwatch.h"

@interface KDGColorSwatch ()

@end

@implementation KDGColorSwatch

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initColorSwatch];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initColorSwatch];
    }
    return self;
}

- (void)initColorSwatch
{
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor grayColor];
    self.selectionColor = [UIColor whiteColor];
    self.selected = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    if (self.selected) [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);

    CGFloat swatchInset = 2.0;
    CGFloat selectionThickness = 2.0;

    CGRect selectionBounds = CGRectInset(self.bounds,
                                         0.5 * selectionThickness,
                                         0.5 * selectionThickness);

    CGRect swatchBounds = CGRectInset(selectionBounds,
                                      swatchInset + 0.5 * selectionThickness,
                                      swatchInset + 0.5 * selectionThickness);

    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillEllipseInRect(context, swatchBounds);

    if (self.selected)
    {
        CGContextSetStrokeColorWithColor(context, self.selectionColor.CGColor);
        CGContextSetLineWidth(context, selectionThickness);
        CGContextStrokeEllipseInRect(context, selectionBounds);
    }

    CGContextRestoreGState(context);
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self endTrackingWithTouch:touch withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    if ([self pointInside:touchPoint slop:0.0])
    {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint centre = CGPointMake(CGRectGetMidX(self.bounds),
                                 CGRectGetMidY(self.bounds));
    CGFloat dx = point.x - centre.x;
    CGFloat dy = point.y - centre.y;
    CGFloat d = sqrtf(dx * dx + dy * dy);

    return d;
}

- (BOOL)pointInside:(CGPoint)point slop:(CGFloat)slop
{
    BOOL result = NO;

    CGRect bounds = self.bounds;
    CGFloat distance = [self calculateDistanceFromCenter:point];
    result = (distance <= (0.5 * bounds.size.width + slop));

    return result;
}

@end

//
//  Created by bwk on 15.05.15.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import "UIView+KDGAnimation.h"

static CGFloat KDGAnimationDurationFactor = 1.0;

@implementation UIView (KDGAnimation)

+ (void)kdg_animateWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                        options:(UIViewAnimationOptions)options
                          views:(NSArray *)views
                          style:(KDGAnimationStyle)style
                     completion:(void(^)(BOOL finished))completion
{
    //  Fade out.
    //
    if (KDGAnimationStyleFadeOut == style)
    {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:^{
                             for (UIView *view in views)
                             {
                                 view.alpha = 0.0;
                             }
                         } completion:^(BOOL finished) {
                             for (UIView *view in views)
                             {
                                 view.hidden = YES;
                                 view.alpha = 1.0;
                             }
                             if (completion) completion(finished);
                         }];
    }

    //  Fade in.
    //
    else if (KDGAnimationStyleFadeIn == style)
    {
        for (UIView *view in views)
        {
            view.alpha = 0.0;
            view.hidden = NO;
        }

        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:^{
                             for (UIView *view in views)
                             {
                                 view.alpha = 1.0;
                             }
                         } completion:^(BOOL finished) {
                             if (completion) completion(finished);
                         }];
    }
}

+ (void)kdg_presentView:(UIView *)view
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
             completion:(void(^)(void))completion
{
    view.alpha = 0.0;
    view.hidden = NO;

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}

+ (void)kdg_dismissView:(UIView *)view
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
             completion:(void(^)(void))completion
{
    CGFloat alpha = view.alpha;

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         view.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         view.hidden = YES;
                         view.alpha = alpha;
                         if (completion)
                             completion();
                     }];
}

+ (void)kdg_presentView:(UIView *)view
           growDuration:(NSTimeInterval)growDuration
         shrinkDuration:(NSTimeInterval)shrinkDuration
                  delay:(NSTimeInterval)delay
               minScale:(CGFloat)minScale
               maxScale:(CGFloat)maxScale
             completion:(void(^)(void))completion
{
    CGAffineTransform xformBegin = CGAffineTransformMakeScale(minScale, minScale);
    CGAffineTransform xformMid = CGAffineTransformMakeScale(maxScale, maxScale);

    view.transform = xformBegin;

    view.alpha = 0.0;
    view.hidden = NO;

    [UIView animateWithDuration:growDuration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.alpha = 1.0;
                         view.transform = xformMid;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:shrinkDuration
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              view.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished) {
                                              if (completion) completion();
                                          }];
                     }];
}

+ (void)kdg_dismissView:(UIView *)view
           growDuration:(NSTimeInterval)growDuration
         shrinkDuration:(NSTimeInterval)shrinkDuration
                  delay:(NSTimeInterval)delay
               minScale:(CGFloat)minScale
               maxScale:(CGFloat)maxScale
             completion:(void(^)(void))completion
{
    CGAffineTransform xformMid = CGAffineTransformMakeScale(maxScale, maxScale);
    CGAffineTransform xformEnd = CGAffineTransformMakeScale(minScale, minScale);

    [UIView animateWithDuration:growDuration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.transform = xformMid;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:shrinkDuration
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              view.alpha = 0.0;
                                              view.transform = xformEnd;
                                          } completion:^(BOOL finished) {
                                              view.hidden = YES;
                                              view.alpha = 1.0;
                                              view.transform = CGAffineTransformIdentity;
                                              if (completion) completion();
                                          }];
                     }];
}

+ (void)kdg_scaleView:(UIView *)view
        scaleDuration:(NSTimeInterval)scaleDuration
       returnDuration:(NSTimeInterval)returnDuration
                delay:(NSTimeInterval)delay
                scale:(CGFloat)scale
           completion:(void(^)(void))completion;
{
    CGAffineTransform xformMid = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform xformEnd = CGAffineTransformIdentity;

    [UIView animateWithDuration:scaleDuration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = xformMid;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:returnDuration
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              view.transform = xformEnd;
                                          } completion:^(BOOL finished) {
                                              if (completion) completion();
                                          }];
                     }];
}

+ (void)kdg_animateRing:(UIView *)view
               duration:(NSTimeInterval)duration
                  delay:(NSTimeInterval)delay
                  color:(UIColor *)color
            startOffset:(CGFloat)startOffset
              endOffset:(CGFloat)endOffset
         startThickness:(CGFloat)startThickness
           endThickness:(CGFloat)endThickness
           startOpacity:(CGFloat)startOpacity
             endOpacity:(CGFloat)endOpacity
             completion:(void(^)(void))completion
{
    static NSInteger sRingTag = 900;
    sRingTag++;
    NSInteger tag = sRingTag;

    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:^{

            UIView *ringView = [view.superview viewWithTag:tag];
            [ringView removeFromSuperview];
            if (completion) completion();
        }];

        CGRect startFrame = CGRectInset(view.frame, -startOffset, -startOffset);

        UIView *ringView = [[UIView alloc] initWithFrame:startFrame];
        ringView.backgroundColor = [UIColor clearColor];
        ringView.layer.borderColor = color.CGColor;
        ringView.tag = tag;

        CGRect endFrame = CGRectInset(view.frame, -endOffset, -endOffset);

        ringView.frame = startFrame;

        [view.superview addSubview:ringView];

        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.fromValue = [NSNumber numberWithFloat:0.5 * startFrame.size.width];
        cornerRadiusAnimation.toValue = [NSNumber numberWithFloat:0.5 * endFrame.size.width];

        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:startOpacity];
        fadeAnimation.toValue = [NSNumber numberWithFloat:endOpacity];

        CABasicAnimation *borderWidthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        borderWidthAnimation.fromValue = [NSNumber numberWithDouble:startThickness];
        borderWidthAnimation.toValue = [NSNumber numberWithDouble:endThickness];

        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, startFrame.size.width, startFrame.size.height)];
        boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, endFrame.size.width, endFrame.size.height)];

        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = duration;
        animationGroup.beginTime = CACurrentMediaTime() + delay;
        animationGroup.repeatCount = 1;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationGroup.animations = @[cornerRadiusAnimation,
                                      fadeAnimation,
                                      borderWidthAnimation,
                                      boundsAnimation];

        [ringView.layer addAnimation:animationGroup forKey:@"ringAnimation"];
    }
    [CATransaction commit];
}

+ (void)kdgSetAnimationDurationFactor:(CGFloat)factor
{
    KDGAnimationDurationFactor = factor;
}

+ (NSTimeInterval)kdgAdjustAnimationDuration:(NSTimeInterval)duration
{
    return duration * KDGAnimationDurationFactor;
}

- (void)kdgAddAnimateFadeIn:(CFTimeInterval)duration
                      delay:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)kdgAddAnimateFadeOut:(CFTimeInterval)duration
                       delay:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)kdgAddAnimateTransform:(CFTimeInterval)duration
                         delay:(CFTimeInterval)delay
                     fromPoint:(CGPoint)fromPoint
                       toPoint:(CGPoint)toPoint
                     fromScale:(CGSize)fromScale
                       toScale:(CGSize)toScale
{
    CGFloat dx = fromPoint.x - self.center.x;
    CGFloat dy = fromPoint.y - self.center.y;
    
    CGFloat dxTo = toPoint.x - self.center.x;
    CGFloat dyTo = toPoint.y - self.center.y;
    
    CATransform3D fromTransform = CATransform3DMakeTranslation(dx, dy, 0.0);
    fromTransform = CATransform3DScale(fromTransform, fromScale.width, fromScale.height, 1.0);
    
    CATransform3D toTransform = CATransform3DMakeTranslation(dxTo, dyTo, 0.0);
    toTransform = CATransform3DScale(toTransform, toScale.width, toScale.height, 1.0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    animation.toValue = [NSValue valueWithCATransform3D:toTransform];
    
    animation.duration = duration * KDGAnimationDurationFactor;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    
    [self.layer addAnimation:animation forKey:nil];
}

@end

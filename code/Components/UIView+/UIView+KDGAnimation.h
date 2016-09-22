//
//  Created by bwk on 15.05.15.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KDGAnimation)

typedef NS_ENUM(NSInteger, KDGAnimationStyle) {
    KDGAnimationStyleFadeIn,
    KDGAnimationStyleFadeOut
};

/**
 Animate view with a particular animation style.
 */
+ (void)kdg_animateWithDuration:(NSTimeInterval)duration
                          delay:(NSTimeInterval)delay
                        options:(UIViewAnimationOptions)options
                          views:(NSArray *)views
                          style:(KDGAnimationStyle)style
                     completion:(void(^)(BOOL finished))completion;

+ (void)kdg_presentView:(UIView *)view
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
             completion:(void(^)(void))completion;


/**
 Dismiss a view by animating the alpha.
 */
+ (void)kdg_dismissView:(UIView *)view
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
             completion:(void(^)(void))completion;

/**
 Present a view by scaling it up from a small size to a larger size and back
 to the normal size.

 This is good for making a view pop in.

 Try the following values for a good effect:

      growDuration:0.2
    shrinkDuration:0.04
          minScale:0.2
          maxScale:1.2
 */
+ (void)kdg_presentView:(UIView *)view
           growDuration:(NSTimeInterval)growDuration
         shrinkDuration:(NSTimeInterval)shrinkDuration
                  delay:(NSTimeInterval)delay
               minScale:(CGFloat)minScale
               maxScale:(CGFloat)maxScale
             completion:(void(^)(void))completion;

/**
 Dismiss a view by scaling it up to a larger size and down to a small size.

 This is good for making a view pop out.

 Try the following values for a good effect:

      growDuration:0.08
    shrinkDuration:0.16
          minScale:0.2
          maxScale:1.2
 */
+ (void)kdg_dismissView:(UIView *)view
           growDuration:(NSTimeInterval)growDuration
         shrinkDuration:(NSTimeInterval)shrinkDuration
                  delay:(NSTimeInterval)delay
               minScale:(CGFloat)minScale
               maxScale:(CGFloat)maxScale
             completion:(void(^)(void))completion;

/**
 Scale a view and then return it back to the original size.
 */
+ (void)kdg_scaleView:(UIView *)view
        scaleDuration:(NSTimeInterval)scaleDuration
       returnDuration:(NSTimeInterval)returnDuration
                delay:(NSTimeInterval)delay
                scale:(CGFloat)scale
           completion:(void(^)(void))completion;

/**
 Animate a ring that radiates from the target view.
 */
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
             completion:(void(^)(void))completion;

+ (void)kdgSetAnimationDurationFactor:(CGFloat)factor;
+ (NSTimeInterval)kdgAdjustAnimationDuration:(NSTimeInterval)duration;

- (void)kdgAddAnimateFadeIn:(CFTimeInterval)duration
                      delay:(CFTimeInterval)delay;

- (void)kdgAddAnimateFadeOut:(CFTimeInterval)duration
                       delay:(CFTimeInterval)delay;

- (void)kdgAddAnimateTransform:(CFTimeInterval)duration
                         delay:(CFTimeInterval)delay
                     fromPoint:(CGPoint)fromPoint
                       toPoint:(CGPoint)toPoint
                     fromScale:(CGSize)fromScale
                       toScale:(CGSize)toScale;

@end

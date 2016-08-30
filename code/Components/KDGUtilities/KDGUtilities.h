//
//  Created by Brian Kramer on 03.11.14.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGGeometry.h>

/* Definition of KDG_UTILITIES_EXTERN */
#if !defined(KDG_UTILITIES_EXTERN)
#  if defined(__cplusplus)
#   define KDG_UTILITIES_EXTERN extern "C"
#  else
#   define KDG_UTILITIES_EXTERN extern
#  endif
#endif /* !defined(KDG_UTILITIES_EXTERN) */

#pragma mark - radians and degrees

/**
 Convert radians to degrees.

 @return Angle in radians.
 */
#define RADIANS_TO_DEGREES(radians) ((radians) * 180.0 / M_PI)

/**
 Convert degrees to radians.

 @return Angle in degrees.
 */
#define DEGREES_TO_RADIANS(degrees) ((degrees) * M_PI / 180.0)

#pragma mark - angle

/**
 Return angle (in degrees) of vector formed by point b on a circle centred at
 point a.

 The angle returned will range from 0 to 360 where 0 is at 3 o'clock and the
 angle increases counter clockwise.
 */
KDG_UTILITIES_EXTERN const float KDGAngleBetweenPoints(CGPoint a, CGPoint b);

#pragma mark - random

/**
 Return random integer ranging from 0 to n.
 0 is returned for all n <= 0.
 */
KDG_UTILITIES_EXTERN const int KDGRandomInt(int n);

/**
 Return random float ranging from 0.0 to 1.0.
 */
KDG_UTILITIES_EXTERN const float KDGRandomFloat();

/**
 Return random float ranging from min to max.

 @param minimum float value.
 @param maximum float value.
 */
KDG_UTILITIES_EXTERN const float KDGRandomFloatInRange(float minimum, float maximum);

#pragma mark - geometry

KDG_UTILITIES_EXTERN const CGRect KDGRectMake(CGPoint centre, CGFloat width, CGFloat height);
KDG_UTILITIES_EXTERN const CGPoint KDGRectCenter(CGRect rect);

#pragma mark - string

/**
 Return @"YES" or @"NO" as appropriate for argument boolean.

 @return String constant.
 */
KDG_UTILITIES_EXTERN const NSString * NSStringFromBOOL(BOOL b);

#pragma mark - utilities

@interface KDGUtilities : NSObject

@end

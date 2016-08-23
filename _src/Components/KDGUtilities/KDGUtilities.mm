//
//  Created by Brian Kramer on 03.11.14.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "KDGUtilities.h"

#pragma mark - angle

KDG_UTILITIES_EXTERN const float KDGAngleBetweenPoints(CGPoint a, CGPoint b)
{
    CGPoint v = CGPointMake(b.x - a.x, -(b.y - a.y));
    float vmag = sqrt(v.x * v.x + v.y * v.y);

    v.x /= vmag;
    v.y /= vmag;

    double radians = atan2(v.y, v.x);

    float result = RADIANS_TO_DEGREES(radians);
    return (result >= 0.0 ? result : result + 360.0);
}

#pragma mark - random

#define ARC4RANDOM_MAX 0x100000000

/*
 To get an integer value from arc4random() that goes from 0 to x-1, you would do this:

 0 to x - 1
 0 to 255
 
 x - 1 = 255
 x = 256

 int value = arc4random() % x;
 */

KDG_UTILITIES_EXTERN const int KDGRandomInt(int n)
{
    if (n <= 0) return 0;

    n += 1;
    int value = arc4random() % n;
    assert(value <= n);
    return value;
}

KDG_UTILITIES_EXTERN const float KDGRandomFloat()
{
    return KDGRandomFloatInRange(0.0, 1.0);
}

KDG_UTILITIES_EXTERN const float KDGRandomFloatInRange(float min, float max)
{
    assert(max >= min);
    
    float r = (float)arc4random() / ARC4RANDOM_MAX;
    assert(r >= 0.0);
    assert(r <= 1.0);
    
    float value = min + r * (max - min);
    return value;
}

#pragma mark - geometry

KDG_UTILITIES_EXTERN const CGPoint KDGRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

#pragma mark - string

KDG_UTILITIES_EXTERN const NSString * NSStringFromBOOL(BOOL b)
{
    return b ? @"YES" : @"NO";
}

#pragma mark - utilities

@implementation KDGUtilities

@end

//
//  Created by bwk on 19.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "UIColor+KDGUtilities.h"

@implementation NSUserDefaults (KDGUtilities)

+ (NSUserDefaults *)kdg_defaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (BOOL)kdg_hasKey:(NSString *)key
{
    return [[[self dictionaryRepresentation] allKeys] containsObject:key];
}

- (BOOL)kdg_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    return [self kdg_hasKey:key] ? [self boolForKey:key] : defaultValue;
}

- (NSInteger)kdg_intForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    return [self kdg_hasKey:key] ? [self integerForKey:key] : defaultValue;
}

- (CGFloat)kdg_floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue
{
    return [self kdg_hasKey:key] ? [self floatForKey:key] : defaultValue;
}

- (NSString *)kdg_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    return [self kdg_hasKey:key] ? [self stringForKey:key] : defaultValue;
}

- (UIColor *)kdg_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue
{
    return [self kdg_hasKey:key] ? [UIColor kdg_colorWithRGBString:[self stringForKey:key]] : defaultValue;
}

@end

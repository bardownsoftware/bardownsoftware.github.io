//
//  Created by bwk on 19.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSUserDefaults (KDGUtilities)

/**
 Slightly less wordy convenience method to get defaults.
 Equivalent to calling [NSUserDefaults standardUserDefaults].
 */
+ (NSUserDefaults *)kdg_defaults;

/**
 Return YES if key exists.
 */
- (BOOL)kdg_hasKey:(NSString *)key;

/**
 Return key value if it exists, otherwise the default value.
 */
- (BOOL)kdg_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSInteger)kdg_intForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (CGFloat)kdg_floatForKey:(NSString *)key defaultValue:(CGFloat)defaultValue;
- (NSString *)kdg_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (UIColor *)kdg_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue;

@end

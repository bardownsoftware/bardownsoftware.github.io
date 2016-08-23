//
//  Created by Brian Kramer on 15.09.14.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "UIFont+KDGUtilities.h"

@implementation UIFont (KDGUtilities)

+ (void)kdg_printFamiles
{
    NSArray *families = [UIFont familyNames];
    for (NSString *family in families)
    {
        NSLog(@"%@", family);
        NSArray *names = [UIFont fontNamesForFamilyName:family];
        for (NSString *name in names)
        {
            NSLog(@"    %@", name);
        }
    }
}

@end

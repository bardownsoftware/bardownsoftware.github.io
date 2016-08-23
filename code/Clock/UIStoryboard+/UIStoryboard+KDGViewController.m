//
//  Created by bwk on 07.11.15.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import "UIStoryboard+KDGViewController.h"

@implementation UIStoryboard (KDGViewController)

+ (id)kdg_viewController:(NSString *)viewControllerName
                          fromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyBoard = [self storyboardWithName:storyboardName bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:viewControllerName];
}

@end

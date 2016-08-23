//
//  Created by bwk on 07.11.15.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (KDGViewController)

+ (id)kdg_viewController:(NSString *)viewControllerName
          fromStoryboard:(NSString *)storyboardName;

@end

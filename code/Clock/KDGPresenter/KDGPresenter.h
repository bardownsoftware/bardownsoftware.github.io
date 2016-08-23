//
//  Created by bwk on 07.04.16.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDGPresenter : NSObject

@property (nonatomic, strong) NSMutableArray *presentingViewControllers;

- (id)presentViewController:(NSString *)viewControllerIdentifier
             storyboardName:(NSString *)storyboardName
     modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle
       modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle
   presentingViewController:(UIViewController *)presentingViewController;

- (void)dismissViewController:(void (^)(void))completion;

@end

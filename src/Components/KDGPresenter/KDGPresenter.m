//
//  Created by bwk on 07.04.16.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "KDGPresenter.h"
#import "UIStoryboard+KDGViewController.h"

@interface KDGPresenter ()

@end

@implementation KDGPresenter

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        self.presentingViewControllers = [NSMutableArray array];
    }
    return self;
}

- (id)presentViewController:(NSString *)viewControllerIdentifier
             storyboardName:(NSString *)storyboardName
     modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle
       modalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle
   presentingViewController:(UIViewController *)presentingViewController
{
    UIViewController *viewController = [UIStoryboard kdg_viewController:viewControllerIdentifier
                                                         fromStoryboard:storyboardName];

    viewController.modalPresentationStyle = modalPresentationStyle;
    viewController.modalTransitionStyle = modalTransitionStyle;

    [presentingViewController presentViewController:viewController
                                           animated:YES
                                         completion:^{
                                         }];

    [self.presentingViewControllers addObject:presentingViewController];

    return viewController;
}

- (void)dismissViewController:(void (^)(void))completion
{
    UIViewController *presentingViewController = [self.presentingViewControllers lastObject];
    [self.presentingViewControllers removeLastObject];

    [presentingViewController dismissViewControllerAnimated:YES
                                                 completion:^{
                                                     if (completion) completion();
                                                 }];
}

@end

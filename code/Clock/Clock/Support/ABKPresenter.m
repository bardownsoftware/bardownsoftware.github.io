//
//  Created by bwk on 07.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "ABKPresenter.h"
#import "UIStoryboard+KDGViewController.h"

static NSString * const kStoryboardMain = @"Main";

@interface ABKPresenter ()

@end

@implementation ABKPresenter

+ (instancetype)sharedInstance
{
    static ABKPresenter *sharedPresenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPresenter = [[self alloc] initPresenter];
    });
    return sharedPresenter;
}

- (instancetype)init
{
    [NSException raise:@"singleton" format:@"use sharedInstance"];
    return nil;
}

- (instancetype)initPresenter
{
    self = [super init];
    if (self)
    {
    }

    return self;
}

- (void)dealloc
{
}

- (id)presentSettingsView:(UIViewController *)presentingViewController
{
    return [self presentViewController:@"ABKSettingsViewController"
                        storyboardName:kStoryboardMain
                modalPresentationStyle:UIModalPresentationFullScreen
                  modalTransitionStyle:UIModalTransitionStyleCrossDissolve
              presentingViewController:presentingViewController];
}

- (void)dismissSettingsView:(void (^)(void))completion;
{
    [self dismissViewController:completion];
}

- (id)presentBuildView:(UIViewController *)presentingViewController
{
    return [self presentViewController:@"ABKBuildViewController"
                        storyboardName:kStoryboardMain
                modalPresentationStyle:UIModalPresentationFullScreen
                  modalTransitionStyle:UIModalTransitionStyleCrossDissolve
              presentingViewController:presentingViewController];
}

- (void)dismissBuildView:(void (^)(void))completion
{
    [self dismissViewController:completion];
}

@end

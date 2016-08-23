//
//  Created by bwk on 07.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "KDGPresenter.h"

@interface ABKPresenter : KDGPresenter

+ (ABKPresenter *)sharedInstance;

- (id)presentSettingsView:(UIViewController *)presentingViewController;
- (void)dismissSettingsView:(void (^)(void))completion;

- (id)presentBuildView:(UIViewController *)presentingViewController;
- (void)dismissBuildView:(void (^)(void))completion;

@end

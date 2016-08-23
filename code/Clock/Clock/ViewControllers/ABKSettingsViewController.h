//
//  Created by bwk on 28.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABKViewModel;

@protocol ABKSettingsViewControllerDelegate;

@interface ABKSettingsViewController : UIViewController

@property (nonatomic, weak) id<ABKSettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) ABKViewModel *viewModel;

@end

@protocol ABKSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidSelectBuild:(ABKSettingsViewController *)viewController;

@end

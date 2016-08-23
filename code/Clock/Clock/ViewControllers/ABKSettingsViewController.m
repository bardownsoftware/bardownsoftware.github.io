//
//  Created by bwk on 28.11.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "ABKSettingsViewController.h"
#import "ABKPresenter.h"
#import "ABKViewModel.h"
#import "UIColor+ABKColors.h"
#import "KDGColorSwatch.h"

@interface ABKSettingsViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *use24HourSwitch;
@property (nonatomic, weak) IBOutlet KDGColorSwatch *colorSwatch1;
@property (nonatomic, weak) IBOutlet KDGColorSwatch *colorSwatch2;
@property (nonatomic, weak) IBOutlet KDGColorSwatch *colorSwatch3;
@property (nonatomic, weak) IBOutlet KDGColorSwatch *colorSwatch4;
@property (nonatomic, weak) IBOutlet KDGColorSwatch *colorSwatch5;

@property (nonatomic, weak) IBOutlet UIButton *buyButton;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@end

@implementation ABKSettingsViewController

- (NSArray *)colorSwatches
{
    return @[self.colorSwatch1,
             self.colorSwatch2,
             self.colorSwatch3,
             self.colorSwatch4,
             self.colorSwatch5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.colorSwatch1.color = [UIColor whiteColor];
    self.colorSwatch2.color = [UIColor abk_redColor];
    self.colorSwatch3.color = [UIColor abk_greenColor];
    self.colorSwatch4.color = [UIColor abk_blueColor];
    self.colorSwatch5.color = [UIColor abk_yellowColor];

    NSArray *colorSwatches = [self colorSwatches];
    for (KDGColorSwatch *colorSwatch in colorSwatches)
    {
        colorSwatch.selectionColor = [UIColor abk_selectionColor];
    }

    self.doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneButton.layer.borderWidth = 1.0;

    for (UIButton *button in @[self.buyButton])
    {
        button.layer.borderColor = [UIColor abk_blueColor].CGColor;
        button.layer.borderWidth = 1.0;

        [button setTitleColor:[UIColor abk_blueColor]
                     forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self cleanUpKVO];
    self.viewModel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateActiveColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setViewModel:(ABKViewModel *)viewModel
{
    _viewModel = viewModel;
    [self setUpKVO];
}

- (void)updateActiveColor
{
    UIColor *color = self.viewModel.foregroundColor;

    NSArray *colorSwatches = [self colorSwatches];

    for (KDGColorSwatch *colorSwatch in colorSwatches)
    {
        if ([color kdg_isEqualToColor:colorSwatch.color])
        {
            colorSwatch.selected = YES;
        }
        else
        {
            colorSwatch.selected = NO;
        }
    }
}

#pragma mark - kvo

- (void)setUpKVO
{
    for (NSString *keyPath in @[ABKViewModelForegroundColor,
                                ABKViewModelBackgroundColor,
                                ABKViewModelUse24HourClock])
    {
        [self.viewModel addObserver:self
                         forKeyPath:keyPath
                            options:(NSKeyValueObservingOptionNew |
                                     NSKeyValueObservingOptionOld |
                                     NSKeyValueObservingOptionInitial)
                            context:NULL];
    }
}

- (void)cleanUpKVO
{
    for (NSString *keyPath in @[ABKViewModelForegroundColor,
                                ABKViewModelBackgroundColor,
                                ABKViewModelUse24HourClock])
    {
        [self.viewModel removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:ABKViewModelForegroundColor])
    {
    }
    else if ([keyPath isEqualToString:ABKViewModelBackgroundColor])
    {
    }
    else if ([keyPath isEqualToString:ABKViewModelUse24HourClock])
    {
        self.use24HourSwitch.on = self.viewModel.use24HourClock;
    }
}

#pragma mark - actions

- (IBAction)doneAction:(id)sender
{
    [[ABKPresenter sharedInstance] dismissSettingsView:^{
    }];
}

- (IBAction)buildAction:(id)sender
{
    [[ABKPresenter sharedInstance] dismissSettingsView:^{
        if (self.delegate) [self.delegate settingsViewControllerDidSelectBuild:self];
    }];
}

- (IBAction)use24HourClockAction:(id)sender
{
    UISwitch *use24HourClockSwitch = (UISwitch *)sender;
    self.viewModel.use24HourClock = use24HourClockSwitch.on;
}

- (IBAction)colorSwatchAction:(id)sender
{
    KDGColorSwatch *colorSwatch = (KDGColorSwatch *)sender;
    self.viewModel.foregroundColor = colorSwatch.color;
    [self updateActiveColor];
}

@end

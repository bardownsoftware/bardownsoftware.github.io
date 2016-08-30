//
//  Created by bwk on 02.08.15.
//  Copyright (c) 2015 Bar Down Software. All rights reserved.
//

#import "ABKMainViewController.h"
#import "ABKSettingsViewController.h"
#import "ABKTimeView.h"
#import "ABKPresenter.h"
#import "ABKViewModel.h"
#import "UIColor+ABKColors.h"

@interface ABKMainViewController () <ABKSettingsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet ABKTimeView *timeView;
@property (nonatomic, weak) IBOutlet UIButton *moreButton;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@property (nonatomic, assign) CGFloat originalBrightness;
@property (nonatomic, assign) BOOL    brightnessDimmed;

@property (nonatomic, strong) ABKViewModel *viewModel;

@property (nonatomic, strong) NSArray *fontNames;

@end

@implementation ABKMainViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont *systemFont = [UIFont systemFontOfSize:32.0 weight:UIFontWeightThin];
    NSString *systemFontName = [systemFont fontName];

    self.fontNames = @[systemFontName,
                       @"HelveticaNeue-UltraLight",
                       @"AvenirNext-UltraLight",
                       @"Graduate-Regular",
                       @"Gruppo",
                       @"Audiowide",
                       @"Righteous-Regular",
                       @"Chalkduster",
                       @"Farah",
                       @"PoiretOne-Regular",
                       @"MarkerFelt-Thin",
                       @"Iceland"];

    BOOL printFonts = NO;
    if (printFonts) {
        NSArray *families = [UIFont familyNames];
        for (NSString *family in families) {
            NSLog(@"%@", family);
            NSArray *names = [UIFont fontNamesForFamilyName:family];
            for (NSString *name in names) {
                NSLog(@"    %@", name);
            }
        }
    }

    self.viewModel = [[ABKViewModel alloc] init];

    UIScreen *screen = [UIScreen mainScreen];
    self.originalBrightness = screen.brightness;
    self.brightnessDimmed = NO;

    [self setUpGestures];

    [self setUpKVO];
}

- (void)dealloc
{
    [self.timeView stop];
    [self cleanUpKVO];
    self.viewModel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.timeView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timeView stop];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUpGestures
{
    UISwipeGestureRecognizer *upSwipe
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(upSwipeAction:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;

    UISwipeGestureRecognizer *downSwipe
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(downSwipeAction:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;

    UISwipeGestureRecognizer *leftSwipe
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;

    UISwipeGestureRecognizer *rightSwipe
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;

    UITapGestureRecognizer *doubleTap
    = [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;

    [self.view addGestureRecognizer:upSwipe];
    [self.view addGestureRecognizer:downSwipe];
    [self.view addGestureRecognizer:leftSwipe];
    [self.view addGestureRecognizer:rightSwipe];
    [self.view addGestureRecognizer:doubleTap];
}

- (void)updateColor
{
    self.timeView.color = self.viewModel.foregroundColor;
    [self.moreButton setTitleColor:self.viewModel.foregroundColor forState:UIControlStateNormal];
    [self.infoButton setTintColor:self.viewModel.foregroundColor];
    self.view.backgroundColor = self.viewModel.backgroundColor;
}

- (void)update24HourClock
{
    self.timeView.use24HourDisplay = self.viewModel.use24HourClock;
}

- (void)updateFontName
{
    self.timeView.fontName = self.viewModel.fontName;
}

- (void)updateDigital
{
    self.timeView.digital = self.viewModel.digital;
}

#pragma mark - kvo

- (void)setUpKVO
{
    for (NSString *keyPath in @[ABKViewModelForegroundColor,
                                ABKViewModelBackgroundColor,
                                ABKViewModelUse24HourClock,
                                ABKViewModelDigital,
                                ABKViewModelFontName])
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
                                ABKViewModelUse24HourClock,
                                ABKViewModelDigital,
                                ABKViewModelFontName])
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
        [self updateColor];
    }
    else if ([keyPath isEqualToString:ABKViewModelBackgroundColor])
    {
        [self updateColor];
    }
    else if ([keyPath isEqualToString:ABKViewModelUse24HourClock])
    {
        [self update24HourClock];
    }
    else if ([keyPath isEqualToString:ABKViewModelDigital])
    {
        [self updateDigital];
    }
    else if ([keyPath isEqualToString:ABKViewModelFontName])
    {
        [self updateFontName];
    }
}

- (NSString *)nextFontName {
    NSString *currentFontName = self.viewModel.fontName;

    NSInteger index = [self.fontNames indexOfObject:currentFontName];
    if (NSNotFound == index) index = 0;
    else index++;
    if (index >= self.fontNames.count) index = 0;

    return self.fontNames[index];
}

- (NSString *)previousFontName {
    NSString *currentFontName = self.viewModel.fontName;

    NSInteger index = [self.fontNames indexOfObject:currentFontName];
    if (NSNotFound == index) index = 0;
    else index--;
    if (index < 0) index = self.fontNames.count - 1;

    return self.fontNames[index];
}

#pragma mark - actions

- (IBAction)moreAction:(id)sender
{
    ABKSettingsViewController *viewController = [[ABKPresenter sharedInstance] presentSettingsView:self];

    viewController.viewModel = self.viewModel;
    viewController.delegate = self;
}

- (void)upSwipeAction:(UIGestureRecognizer *)gesture
{
    UIScreen *screen = [UIScreen mainScreen];

    if (self.brightnessDimmed)
    {
        screen.brightness = self.originalBrightness;
        self.brightnessDimmed = NO;
    }
    else
    {
    }
}

- (void)downSwipeAction:(UIGestureRecognizer *)gesture
{
    UIScreen *screen = [UIScreen mainScreen];

    if (self.brightnessDimmed)
    {
    }
    else
    {
        screen.brightness = 0.0;
        self.brightnessDimmed = YES;
    }
}

- (void)leftSwipeAction:(UIGestureRecognizer *)gesture
{
    if (self.viewModel.digital) {
        NSString *fontName = [self nextFontName];
        self.viewModel.fontName = fontName;
    }
}

- (void)rightSwipeAction:(UIGestureRecognizer *)gesture
{
    if (self.viewModel.digital) {
        NSString *fontName = [self previousFontName];
        self.viewModel.fontName = fontName;
    }
}

- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    self.viewModel.digital = !self.viewModel.digital;
}

#pragma mark - settings delegate

- (void)settingsViewControllerDidSelectBuild:(ABKSettingsViewController *)viewController
{
    [[ABKPresenter sharedInstance] presentBuildView:self];
}

@end

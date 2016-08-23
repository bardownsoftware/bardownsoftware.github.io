//
//  Created by bwk on Sat.02.Apr.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

#import "ABKBuildViewController.h"
#import "ABKPresenter.h"
#import "UIColor+ABKColors.h"

@interface ABKBuildViewController ()

@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;

@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, assign) NSInteger imageIndex;

@end

@implementation ABKBuildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UIButton *button in @[self.nextButton,
                               self.previousButton])
    {
        button.layer.borderColor = [UIColor abk_blueColor].CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 0.5 * button.bounds.size.width;

        [button setTitleColor:[UIColor abk_blueColor]
                     forState:UIControlStateNormal];
    }

    self.doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneButton.layer.borderWidth = 1.0;

    self.imageIndex = 0;
    self.imageNames = @[@"step0",
                        @"step1",
                        @"step2",
                        @"step3",
                        @"step4",
                        @"step5",
                        @"step6",
                        @"step7",
                        @"step8"
                        ];

    self.slider.value = 0;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.imageNames.count - 1;
    self.slider.minimumTrackTintColor = [UIColor abk_blueColor];
    self.slider.thumbTintColor = [UIColor abk_blueColor];

    self.imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.layer.masksToBounds = YES;

    UISwipeGestureRecognizer *swipeRight
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeRight];

    UISwipeGestureRecognizer *swipeLeft
    = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipeLeftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;

    [self.imageView addGestureRecognizer:swipeRight];
    [self.imageView addGestureRecognizer:swipeLeft];
    self.imageView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateImage];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)nextImage
{
    NSInteger newIndex = self.imageIndex + 1;

    if (newIndex >= self.imageNames.count)
    {
        newIndex = self.imageNames.count - 1;
    }

    if (newIndex != self.imageIndex)
    {
        self.imageIndex = newIndex;
        [self updateImage];
        [self updateSlider];
    }
}

- (void)previousImage
{
    NSInteger newIndex = self.imageIndex - 1;

    if (newIndex < 0)
    {
        newIndex = 0;
    }

    if (newIndex != self.imageIndex)
    {
        self.imageIndex = newIndex;
        [self updateImage];
        [self updateSlider];
    }
}

- (void)updateImage
{
    NSString *imageName = self.imageNames[self.imageIndex];
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)updateSlider
{
    self.slider.value = self.imageIndex;
}

#pragma mark - actions

- (IBAction)doneAction:(id)sender
{
    [[ABKPresenter sharedInstance] dismissSettingsView:^{
    }];
}

- (IBAction)nextAction:(id)sender
{
    [self nextImage];
}

- (IBAction)previousAction:(id)sender
{
    [self previousImage];
}

- (IBAction)sliderChangedAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;

    NSInteger index = slider.value;

    if (index != self.imageIndex)
    {
        self.imageIndex = index;
        [self updateImage];
    }
}

- (void)swipeRightAction:(UIGestureRecognizer *)gestureRecognizer
{
    [self previousImage];
}

- (void)swipeLeftAction:(UIGestureRecognizer *)gestureRecognizer
{
    [self nextImage];
}

@end

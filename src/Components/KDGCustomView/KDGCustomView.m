//
//  Created by bwk on 22.10.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import "KDGCustomView.h"

@interface KDGCustomView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

@implementation KDGCustomView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initCustomView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCustomView];
    }
    return self;
}

- (void)initCustomView
{
    _customConstraints = [[NSMutableArray alloc] init];
    _containerView = nil;
}

- (UIView *)loadViewFromNibWithName:(NSString *)nibName
{
    UIView *view = nil;

    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                     owner:self
                                                   options:nil];

    for (id object in objects)
    {
        if ([object isKindOfClass:[UIView class]])
        {
            view = object;
            break;
        }
    }

    if (view != nil)
    {
        [self addSubview:view];
    }

    return view;
}

- (UIView *)loadViewFromNib
{
    return [self loadViewFromNibWithName:NSStringFromClass([self class])];
}

- (void)constrainCustomView:(UIView *)view
{
    if (view != nil)
    {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateCustomViewConstraints
{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    if (self.containerView != nil)
    {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);

        [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:views]];

        [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:views]];

        [self addConstraints:self.customConstraints];
    }
}

@end

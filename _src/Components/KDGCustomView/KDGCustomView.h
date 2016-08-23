//
//  Created by bwk on 22.10.15.
//  Copyright © 2015 Bar Down Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDGCustomView : UIView

/**
 Convenience method for loading view from nib file.
 Be sure that your class name is the same as your nib file. For example a class
 named MyView should have a nib file MyView.xib.
 */
- (UIView *)loadViewFromNib;
- (UIView *)loadViewFromNibWithName:(NSString *)nibName;

/**
 If you want your custom view to be constrained to the edges of the containing
 view then call constrainCustomView during your initialization (after the nib
 has been loaded and the view within added as a subview).
 
 Also be sure to override updateConstraints in your derived custom view and call
 updateCustomViewConstraints.
 */
- (void)constrainCustomView:(UIView *)view;
- (void)updateCustomViewConstraints;

@end

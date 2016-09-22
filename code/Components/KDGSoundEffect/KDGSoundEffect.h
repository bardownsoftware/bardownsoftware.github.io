//
//  Created by bwk on 11.05.15.
//  Copyright (c) 2015 Bar Down Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

@interface KDGSoundEffect : NSObject

- (id)initWithSoundNamed:(NSString *)filename;
- (void)play;

@end

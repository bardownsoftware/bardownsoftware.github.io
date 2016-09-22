//
//  Created by bwk on 11.05.15.
//  Copyright (c) 2015 Bar Down Software. All rights reserved.
//

#import "KDGSoundEffect.h"

@interface KDGSoundEffect ()

@property (nonatomic, assign) SystemSoundID soundID;

@end

@implementation KDGSoundEffect

- (id)initWithSoundNamed:(NSString *)filename
{
    self = [super init];

    if (self)
    {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:[filename stringByDeletingPathExtension]
                                                 withExtension:[filename pathExtension]];
        if (fileURL != nil)
        {
            SystemSoundID soundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundID);
            if (error == kAudioServicesNoError)
            {
                _soundID = soundID;
            }
        }
        else
        {
            NSLog(@"# error: no audio file at %@", filename);
        }
    }

    return self;
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
}

- (void)play
{
    AudioServicesPlaySystemSound(self.soundID);
}

@end

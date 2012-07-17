//
//  Touch.m
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "Touch.h"

@implementation Touch

@synthesize location = _location;
@synthesize previousLocation = _previousLocation;
@synthesize privateFrame = _privateFrame;
@synthesize privateTouch = _privateTouch;
@synthesize phase = _phase;
@synthesize time = _time;
@synthesize sequenceID = _sequenceID;

- (id)initWithLocation:(NSPoint)location previousLocation:(NSPoint)previousLocation phase:(TouchPhase)phase time:(NSTimeInterval)time sequenceID:(NSInteger)sequenceID
{
    self = [super init];
    if (self) {
        self.location = location;
        self.previousLocation = previousLocation;
        self.privateFrame = NSZeroRect;
        self.privateTouch = NO;
        self.phase = phase;
        self.time = time;
        self.sequenceID = sequenceID;
    }
    return self;
}

- (id)initWithPrivateFrame:(NSRect)privateFrame phase:(TouchPhase)phase time:(NSTimeInterval)time sequenceID:(NSInteger)sequenceID
{
    self = [super init];
    if (self) {
        self.location = NSZeroPoint;
        self.previousLocation = NSZeroPoint;
        self.privateFrame = privateFrame;
        self.privateTouch = YES;
        self.phase = phase;
        self.time = time;
        self.sequenceID = sequenceID;
    }
    return self;
}

@end

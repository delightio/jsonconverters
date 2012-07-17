//
//  Touch.h
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TouchPhaseBegan,             // whenever a finger touches the surface.
    TouchPhaseMoved,             // whenever a finger moves on the surface.
    TouchPhaseStationary,        // whenever a finger is touching the surface but hasn't moved since the previous event.
    TouchPhaseEnded,             // whenever a finger leaves the surface.
    TouchPhaseCancelled          // whenever a touch doesn't end but we need to stop tracking (e.g. putting device to face)
} TouchPhase;

@interface Touch : NSObject

@property (assign, nonatomic) NSPoint location;
@property (assign, nonatomic) NSPoint previousLocation;
@property (assign, nonatomic) NSRect privateFrame;
@property (assign, nonatomic, getter=isPrivateTouch) BOOL privateTouch;
@property (assign, nonatomic) TouchPhase phase;
@property (assign, nonatomic) NSTimeInterval time;
@property (assign, nonatomic) NSInteger sequenceID;

- (id)initWithLocation:(NSPoint)location previousLocation:(NSPoint)previousLocation phase:(TouchPhase)phase time:(NSTimeInterval)time sequenceID:(NSInteger)sequenceID;
- (id)initWithPrivateFrame:(NSRect)privateFrame phase:(TouchPhase)phase time:(NSTimeInterval)time sequenceID:(NSInteger)sequenceID;

@end

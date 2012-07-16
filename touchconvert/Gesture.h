//
//  Gesture.h
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Touch.h"

typedef enum {
    GestureTypeUnknown,
    GestureTypeTap,
    GestureTypeSwipe,
    GestureTypePinch
} GestureType;

@interface Gesture : NSObject

@property (assign, nonatomic) GestureType type;
@property (assign, nonatomic) NSTimeInterval startTime;
@property (assign, nonatomic) NSTimeInterval endTime;
@property (readonly, nonatomic) NSArray *touches;
@property (readonly, nonatomic) NSArray *subgestures;

- (void)addTouch:(Touch *)touch;
- (BOOL)canMergeWithGesture:(Gesture *)gesture;
- (Gesture *)mergedGestureWithGesture:(Gesture *)gesture;
- (CGFloat)distanceToLocation:(NSPoint)location;
- (NSDictionary *)dictionaryRepresentation;

@end

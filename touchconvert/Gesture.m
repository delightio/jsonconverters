//
//  Gesture.m
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "Gesture.h"

#define kSwipeDistanceThreshold 30.0f
#define kPinchDistanceThreshold 40.0f

static CGFloat DistanceBetweenPoints(NSPoint p1, NSPoint p2) 
{
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

static CGFloat DistanceBetweenPointAndRect(NSPoint p, NSRect r)
{
    if (NSPointInRect(p, r)) return 0.0f;
    
    CGFloat dx = (p.x < NSMinX(r) ? NSMinX(r) - p.x : (p.x > NSMaxX(r) ? NSMaxX(r) - p.x : MIN(p.x - NSMinX(r), NSMaxX(r) - p.x)));
    CGFloat dy = (p.y < NSMinY(r) ? NSMinY(r) - p.y : (p.y > NSMaxY(r) ? NSMaxY(r) - p.y : MIN(p.y - NSMinY(r), NSMaxY(r) - p.y)));
    
    return sqrt(dx * dx + dy * dy);
}

static CGFloat DistanceBetweenCenterPointsInRects(NSRect r1, NSRect r2)
{
    return DistanceBetweenPoints(NSMakePoint(NSMidX(r1), NSMidY(r1)), NSMakePoint(NSMidX(r2), NSMidY(r2)));
}

@implementation Gesture {
    NSMutableArray *mutableTouches;
    NSMutableArray *mutableSubgestures;
}

@synthesize type = _type;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;

- (id)init
{
    self = [super init];
    if (self) {
        self.type = GestureTypeUnknown;
        self.startTime = -1.0;
        self.endTime = -1.0;
        mutableTouches = [[NSMutableArray alloc] init];
        mutableSubgestures = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)touches
{
    return mutableTouches;
}

- (NSArray *)subgestures
{
    return mutableSubgestures;
}

- (void)addTouch:(Touch *)touch
{    
    if (touch.time < self.startTime || [mutableTouches count] == 0) {
        self.startTime = touch.time;
    }
    if (touch.time > self.endTime) {
        self.endTime = touch.time;
    }
    
    [mutableTouches addObject:touch];
    
    // Have we exceeded the threshold for a swipe?
    if ([self distanceToLocation:self.startingPoint] > kSwipeDistanceThreshold) {
        self.type = GestureTypeSwipe;
    } else if ((touch.phase == TouchPhaseEnded || touch.phase == TouchPhaseCancelled) && self.type == GestureTypeUnknown) {
        self.type = GestureTypeTap;
    }
}

- (void)addSubgesture:(Gesture *)subgesture
{
    [mutableSubgestures addObject:subgesture];
}

- (NSPoint)locationAfterTime:(NSTimeInterval)time
{
    for (Touch *touch in self.touches) {
        if (touch.time > time) {
            return touch.location;
        }
    }
    
    return NSZeroPoint;
}

- (NSPoint)locationBeforeTime:(NSTimeInterval)time
{
    for (NSInteger i = [self.touches count] - 1; i >= 0; i--) {
        Touch *touch = [self.touches objectAtIndex:i];
        if (touch.time < time) {
            return touch.location;
        }
    }
    
    return NSZeroPoint;
}

- (BOOL)canMergeWithGesture:(Gesture *)gesture
{
    // The gestures must both be swipes and their time intervals must overlap
    if (self.type != GestureTypeSwipe || gesture.type != GestureTypeSwipe) return NO;
    if (self.endTime < gesture.startTime || gesture.endTime < self.startTime) return NO;
    
    return YES;
}

- (Gesture *)mergedGestureWithGesture:(Gesture *)gesture
{
    Gesture *mergedGesture = [[Gesture alloc] init];
    mergedGesture.startTime = MIN(self.startTime, gesture.startTime);
    mergedGesture.endTime = MAX(self.endTime, gesture.endTime);
    [mergedGesture addSubgesture:self];
    [mergedGesture addSubgesture:gesture];
    
    // Figure out if it's a pinch
    // Look at distance between points at start and end
    NSTimeInterval commonStartTime = MAX(self.startTime, gesture.startTime);
    NSTimeInterval commonEndTime = MIN(self.endTime, gesture.endTime);
    NSPoint startPoint1 = [self locationAfterTime:commonStartTime];
    NSPoint startPoint2 = [gesture locationAfterTime:commonStartTime];
    NSPoint endPoint1 = [self locationBeforeTime:commonEndTime];
    NSPoint endPoint2 = [gesture locationBeforeTime:commonEndTime];
    
    if (ABS(DistanceBetweenPoints(startPoint1, startPoint2) - DistanceBetweenPoints(endPoint1, endPoint2)) > kPinchDistanceThreshold) {
        mergedGesture.type = GestureTypePinch;
    } else {
        mergedGesture.type = GestureTypeSwipe;
    }
    
    return mergedGesture;
}

- (NSPoint)startingPoint
{
    if ([mutableTouches count] == 0) {
        return NSZeroPoint;
    }
    
    Touch *startingTouch = [mutableTouches objectAtIndex:0];
    if ([startingTouch isPrivateTouch]) {
        return NSMakePoint(NSMidX(startingTouch.privateFrame), NSMidY(startingTouch.privateFrame));
    } else {
        return startingTouch.location;
    }
}

- (CGFloat)distanceToLocation:(NSPoint)location
{
    if ([mutableTouches count] == 0) {
        return -1.0f;
    }
    
    Touch *lastTouch = [mutableTouches lastObject];
    if ([lastTouch isPrivateTouch]) {
        return DistanceBetweenPointAndRect(location, lastTouch.privateFrame);
    } else {
        return DistanceBetweenPoints(location, lastTouch.location);
    }
}

- (CGFloat)distanceToRect:(NSRect)rect
{
    if ([mutableTouches count] == 0) {
        return -1.0f;
    }
    
    Touch *lastTouch = [mutableTouches lastObject];
    if ([lastTouch isPrivateTouch]) {
        return DistanceBetweenCenterPointsInRects(rect, lastTouch.privateFrame);
    } else {
        return DistanceBetweenPointAndRect(lastTouch.location, rect);
    }
}

- (NSString *)typeString
{
    switch (self.type) {
        case GestureTypeTap:     return @"tap";
        case GestureTypeSwipe:   return @"swipe";
        case GestureTypePinch:   return @"pinch";
        case GestureTypeUnknown: return @"unknown";
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:[self typeString], @"type",
            [NSNumber numberWithDouble:self.startTime], @"startTime",
            [NSNumber numberWithDouble:self.endTime], @"endTime", nil];
}

@end

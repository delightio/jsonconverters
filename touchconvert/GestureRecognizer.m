//
//  GestureRecognizer.m
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "GestureRecognizer.h"

@implementation GestureRecognizer

+ (NSArray *)gesturesForTouches:(NSArray *)touches
{
    NSMutableArray *gesturesInProgress = [[NSMutableArray alloc] init];
    NSMutableArray *gesturesCompleted = [[NSMutableArray alloc] init];

    // Gestures available to link a touch with for a UIEvent
    NSMutableArray *availableGestures = [[NSMutableArray alloc] init];
    NSInteger sequenceId = -1;
    
    for (Touch *touch in touches) {
        // New UIEvent
        if (touch.sequenceID > sequenceId) {
            sequenceId = touch.sequenceID;
            [availableGestures removeAllObjects];
            [availableGestures addObjectsFromArray:gesturesInProgress];
        }
        
        switch (touch.phase) {
            case TouchPhaseBegan: {
                // Start of a new gesture
                Gesture *gesture = [[Gesture alloc] init];
                if (gesture) {
                    [gesture addTouch:touch];
                    [gesturesInProgress addObject:gesture];
                }
                break;
            }
                            
            case TouchPhaseMoved:
            case TouchPhaseStationary: {
                // Continuation of an existing gesture
                Gesture *gesture = [self likeliestGestureForTouch:touch inArray:availableGestures];
                if (gesture) {
                    [gesture addTouch:touch];
                    [availableGestures removeObject:gesture];
                }
                break;
            }
                
            case TouchPhaseEnded:
            case TouchPhaseCancelled: {
                // End of an existing gesture
                Gesture *gesture = [self likeliestGestureForTouch:touch inArray:availableGestures];
                if (gesture) {
                    [gesture addTouch:touch];
                    [availableGestures removeObject:gesture];
                    [gesturesCompleted addObject:gesture];
                    [gesturesInProgress removeObject:gesture];
                }
                break;
            }
        }
    }
    
    [self mergeSwipeGestures:gesturesCompleted];
    return gesturesCompleted;
}

+ (Gesture *)likeliestGestureForTouch:(Touch *)touch inArray:(NSArray *)gestures
{
    if ([gestures count] == 0) return nil;
    if ([gestures count] == 1) return [gestures lastObject];
    
    // Choose the gesture whose last location is closest to the touch's last location
    Gesture *likelyGesture = nil;
    CGFloat minDistance = -1.0f;
    for (Gesture *gesture in gestures) {
        CGFloat distance = [gesture distanceToLocation:touch.previousLocation];
        if (minDistance < 0 || distance < minDistance) {
            likelyGesture = gesture;
            minDistance = distance;
        }
    }
    
    if (!likelyGesture) return [gestures lastObject];
    return likelyGesture;
}

// Look for two-finger swipes and merge them into pinches if necessary
+ (void)mergeSwipeGestures:(NSMutableArray *)gestures
{
    NSMutableArray *mergedGestures = [NSMutableArray array];
    NSMutableArray *mergedSubgestures = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [gestures count]; i++) {
        for (NSInteger j = i + 1; j < [gestures count]; j++) {
            Gesture *gesture1 = [gestures objectAtIndex:i];
            Gesture *gesture2 = [gestures objectAtIndex:j];
            
            if ([gesture1 canMergeWithGesture:gesture2] && 
                ![mergedSubgestures containsObject:gesture1] && 
                ![mergedSubgestures containsObject:gesture2]) {
                
                Gesture *mergedGesture = [gesture1 mergedGestureWithGesture:gesture2];
                [mergedGestures addObject:mergedGesture];
                [mergedSubgestures addObject:gesture1];
                [mergedSubgestures addObject:gesture2];
                break;
            }
        }
    }
    
    [gestures removeObjectsInArray:mergedSubgestures];
    [gestures addObjectsFromArray:mergedGestures];
    [gestures sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES]]];
}

@end

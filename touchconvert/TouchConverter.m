//
//  TouchConverter.m
//  touchconvert
//
//  Created by Chris Haugli on 7/12/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "TouchConverter.h"
#import "GestureRecognizer.h"
#import "JSONKit.h"

@implementation TouchConverter

- (NSDictionary *)processDictionary:(NSDictionary *)inputDictionary
{
    // Convert touch dictionary to Touch objects
    NSArray *touchDicts = [inputDictionary objectForKey:@"touches"];
    NSMutableArray *touches = [NSMutableArray arrayWithCapacity:[touchDicts count]];
    for (NSDictionary *touchDict in touchDicts) {
        Touch *touch = [[Touch alloc] initWithLocation:NSPointFromString([touchDict objectForKey:@"curLoc"]) 
                                      previousLocation:NSPointFromString([touchDict objectForKey:@"prevLoc"]) 
                                                 phase:[[touchDict objectForKey:@"phase"] intValue] 
                                                  time:[[touchDict objectForKey:@"time"] doubleValue]
                                            sequenceID:[[touchDict objectForKey:@"seq"] integerValue]];
        [touches addObject:touch];
    }
    
    // Detect gestures from touches
    NSArray *gestures = [GestureRecognizer gesturesForTouches:touches];
    
    // Convert gestures to dictionary representation
    NSMutableArray *gestureDicts = [NSMutableArray arrayWithCapacity:[gestures count]];
    for (Gesture *gesture in gestures) {
        NSDictionary *gestureDict = [gesture dictionaryRepresentation];
        [gestureDicts addObject:gestureDict];
    }
    
    return [NSDictionary dictionaryWithObject:gestureDicts forKey:@"gestures"];
}

@end

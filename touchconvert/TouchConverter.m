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

@synthesize inputFilePath = _inputFilePath;
@synthesize outputFilePath = _outputFilePath;

- (BOOL)convert
{
    // Read input plist
    NSDictionary *touchesDict = [NSDictionary dictionaryWithContentsOfFile:self.inputFilePath];
    if (!touchesDict) {
        NSLog(@"Unable to read input file: %@", self.inputFilePath);
        return NO; 
    }
    
    // Convert to gestures
    NSArray *touchDicts = [touchesDict objectForKey:@"touches"];
    NSArray *gestures = [self gesturesForTouchDicts:touchDicts];
    
    // Convert to dictionary
    NSMutableArray *gestureDicts = [NSMutableArray arrayWithCapacity:[gestures count]];
    for (Gesture *gesture in gestures) {
        NSDictionary *gestureDict = [gesture dictionaryRepresentation];
        [gestureDicts addObject:gestureDict];
    }
    NSDictionary *gesturesDict = [NSDictionary dictionaryWithObject:gestureDicts forKey:@"gestures"];
    
    // Write output JSON to file or standard output
    if (self.outputFilePath) {
        if (![[gesturesDict JSONData] writeToFile:self.outputFilePath atomically:YES]) {
            NSLog(@"Unable to write to output file: %@", self.outputFilePath);
            return NO; 
        }
    } else {
        printf("%s\n", [[gesturesDict JSONString] UTF8String]);
    }
    
    return YES;
}

- (NSArray *)gesturesForTouchDicts:(NSArray *)touchDicts
{
    NSMutableArray *touches = [NSMutableArray arrayWithCapacity:[touchDicts count]];
    for (NSDictionary *touchDict in touchDicts) {
        Touch *touch = [[Touch alloc] initWithLocation:NSPointFromString([touchDict objectForKey:@"curLoc"]) 
                                      previousLocation:NSPointFromString([touchDict objectForKey:@"prevLoc"]) 
                                                 phase:[[touchDict objectForKey:@"phase"] intValue] 
                                                  time:[[touchDict objectForKey:@"time"] doubleValue]
                                            sequenceID:[[touchDict objectForKey:@"seq"] integerValue]];
        [touches addObject:touch];
    }
    
    return [GestureRecognizer gesturesForTouches:touches];
}

@end

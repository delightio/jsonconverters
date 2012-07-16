//
//  GestureRecognizer.h
//  touchconvert
//
//  Created by Chris Haugli on 7/13/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.h"

@interface GestureRecognizer : NSObject

+ (NSArray *)gesturesForTouches:(NSArray *)touches;

@end

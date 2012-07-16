//
//  main.m
//  eventconvert
//
//  Created by Chris Haugli on 7/16/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConverter.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc == 1) {
            fprintf(stderr, "Usage: eventconvert <input.plist> <output.json>\n");
            return 1;
        }
        
        JSONConverter *eventConverter = [[JSONConverter alloc] init];
        eventConverter.inputFilePath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        eventConverter.outputFilePath = (argc == 2 ? nil : [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding]);
        if (![eventConverter convert]) {
            return 2;
        }
    }
    
    return 0;
}


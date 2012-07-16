//
//  main.m
//  touchconvert
//
//  Created by Chris Haugli on 7/12/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchConverter.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc == 1) {
            fprintf(stderr, "Usage: touchconvert <input.plist> <output.json>\n");
            return 1;
        }
        
        TouchConverter *touchConverter = [[TouchConverter alloc] init];
        touchConverter.inputFilePath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        touchConverter.outputFilePath = (argc == 2 ? nil : [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding]);
        if (![touchConverter convert]) {
            return 2;
        }
    }
    
    return 0;
}


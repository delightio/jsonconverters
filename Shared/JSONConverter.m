//
//  JSONConverter.m
//  JSONConverters
//
//  Created by Chris Haugli on 7/16/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import "JSONConverter.h"
#import "JSONKit.h"

@implementation JSONConverter

@synthesize inputFilePath = _inputFilePath;
@synthesize outputFilePath = _outputFilePath;

- (BOOL)convert
{
    // Read input plist
    NSDictionary *inputDict = [NSDictionary dictionaryWithContentsOfFile:self.inputFilePath];
    if (!inputDict) {
        NSLog(@"Unable to read input file: %@", self.inputFilePath);
        return NO; 
    }
    
    // Process the data
    NSDictionary *outputDict = [self processDictionary:inputDict];
    
    // Write output JSON to file or standard output
    if (self.outputFilePath) {
        if (![[outputDict JSONData] writeToFile:self.outputFilePath atomically:YES]) {
            NSLog(@"Unable to write to output file: %@", self.outputFilePath);
            return NO;
        }
    } else {
        printf("%s\n", [[outputDict JSONString] UTF8String]);
    }
    
    return YES;
}

- (NSDictionary *)processDictionary:(NSDictionary *)inputDictionary
{
    // Default implementation does no processing
    return inputDictionary;
}

@end

//
//  JSONConverter.h
//  JSONConverters
//
//  Created by Chris Haugli on 7/16/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONConverter : NSObject

@property (strong, nonatomic) NSString *inputFilePath;
@property (strong, nonatomic) NSString *outputFilePath;

- (BOOL)convert;
- (NSDictionary *)processDictionary:(NSDictionary *)inputDictionary;

@end

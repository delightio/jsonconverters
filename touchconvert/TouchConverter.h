//
//  TouchConverter.h
//  touchconvert
//
//  Created by Chris Haugli on 7/12/12.
//  Copyright (c) 2012 Pipely Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchConverter : NSObject

@property (strong, nonatomic) NSString *inputFilePath;
@property (strong, nonatomic) NSString *outputFilePath;

- (BOOL)convert;

@end

//
//  Challenge.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/22/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "Challenge.h"

@implementation Challenge

- (Challenge*)initWithDictionaryJsonValues:(NSDictionary*)dictionary
{
    return [self initWithContentOfDictionary:dictionary];
}

#pragma mark - ObjectToDictionary protocol methods
- (id) initWithContentOfDictionary:(NSDictionary*)dict
{
    return nil;
}

@end

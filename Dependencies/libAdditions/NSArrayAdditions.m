//
//  NSArrayAdditions.m
//  ShinobiDevs
//
//  Created by Miki Bergin on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArrayAdditions.h"

@implementation NSArray (Additions)

@end

@implementation NSMutableArray (Additions)
- (void) addInteger:(NSInteger)i
{
    [self addObject:[NSNumber numberWithInt:i]];
}

- (void) addUnsignedInteger:(NSUInteger)i
{
    [self addObject:[NSNumber numberWithUnsignedInt:i]];
}

- (void) addFloat:(Float32)f
{
    [self addObject:[NSNumber numberWithFloat:f]];
}

- (void) addBool:(BOOL)b
{
    [self addObject:[NSNumber numberWithBool:b]];
}

- (void) bringObjectToFront:(id)object
{
    [self removeObject:object];
    [self addObject:object];
}
@end
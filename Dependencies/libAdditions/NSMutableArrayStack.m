//
//  NSMutableArrayStack.m
//  HotVOD
//
//  Created by Guy Shaviv on 12/30/09.
//  Copyright 2009 .. All rights reserved.
//

#import "NSMutableArrayStack.h"


@implementation NSMutableArray (Stack)

- (void) push:(id)object {
    @synchronized (self) {
	[self addObject:object];
    }
}

- (id) pop {
    @synchronized (self) {
    if (self.count == 0) return nil;
	id object = [self lastObject];
	[self removeLastObject];
	return object;
    }
}

@end

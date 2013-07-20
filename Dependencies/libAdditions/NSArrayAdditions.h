//
//  NSArrayAdditions.h
//  Fiverr
//
//  Created by Miki Bergin on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

/*
 - (NSInteger) integerForKey:(id)key;
- (NSInteger) integerForKey:(id)key default:(NSInteger)defaultValue;
- (NSUInteger) unsignedIntegerForKey:(id)key;
- (NSUInteger) unsignedIntegerForKey:(id)key default:(NSUInteger)defaultValue;
- (float) floatForKey:(id)key;
- (BOOL) boolForKey:(id)key;
- (NSNumber*) integerNumberForKey:(id)key;
- (NSNumber*) floatNumberForKey:(id)key;
 */
@end

@interface NSMutableArray (Additions)

- (void) addInteger:(NSInteger)i;
- (void) addUnsignedInteger:(NSUInteger)i;
- (void) addFloat:(Float32)f;
- (void) addBool:(BOOL)b;

// brings object to front (last member of the array), if it doesn't exist it will just be inserted
// at the end
- (void) bringObjectToFront:(id)object;
@end
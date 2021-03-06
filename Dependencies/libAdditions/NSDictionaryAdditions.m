//
//  NSDictionaryAdditions.m
//  houzz
//
//  Created by ShinobiDevs on 25/2/10.
//  Copyright 2010 . All rights reserved.
//

#import "NSDictionaryAdditions.h"

@implementation NSDictionary (Additions)

- (NSInteger) integerForKey:(id)key {
	return [self integerForKey:key default:0];
}

- (NSInteger) integerForKey:(id)key default:(NSInteger)defaultValue {
	id num = [self objectForKey:key];
	if (num) {
		return [num intValue];
	}
	return defaultValue;
}

- (NSUInteger) unsignedIntegerForKey:(id)key default:(NSUInteger)defaultValue {
	id num = [self objectForKey:key];
	if (num) {
		return [num unsignedIntegerValue];
	}
	return defaultValue;
}

- (NSUInteger) unsignedIntegerForKey:(id)key {
	return [self unsignedIntegerForKey:key default:0];
}
- (BOOL) boolForKey:(id)key {
	NSNumber* num = [self objectForKey:key];
	if (num == nil) {
		return NO;
	}
	return [num boolValue];
}
- (float) floatForKey:(id)key  {
	id num = [self objectForKey:key];
	if (num) {
		return [num floatValue];
	}
	return 0;
}

- (NSNumber*) integerNumberForKey:(id)key 
{
	id num = [self objectForKey:key];
	if (num) {
		return [NSNumber numberWithInt:[num intValue]];
	}
	return nil;
}

- (NSNumber*) floatNumberForKey:(id)key 
{
	id num = [self objectForKey:key];
	if (num) {
		return [NSNumber numberWithFloat:[num floatValue]];
	}
	return nil;
}

@end

@implementation NSMutableDictionary (Additions)

- (void) setInteger:(NSInteger)i forKey:(id)key 
{
	[self setObject:[NSNumber numberWithInt:i] forKey:key];
}
- (void) setUnsignedInteger:(NSUInteger)i forKey:(id)key 
{
	[self setObject:[NSNumber numberWithUnsignedInt:i] forKey:key];
}
- (void) setFloat:(Float32)f forKey:(id)key 
{
    [self setObject:[NSNumber numberWithFloat:f] forKey:key];
}
- (void) setBool:(BOOL)b forKey:(id)key 
{
    [self setObject:[NSNumber numberWithBool:b] forKey:key];
}
@end

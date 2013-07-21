//
//  NSDictionary+ObjectToDictionary.h
//  AdditionsLib
//
//  Created by ShinobiDevs on 30/9/11.
//  Copyright (c) 2011 LitePoint Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectToDictionary <NSObject>
- (id) initWithContentOfDictionary:(NSDictionary*)dict;
- (NSDictionary*) contentsTodictionary;
@end

@interface NSDictionary (ObjectToDictionary)
- (id) createObject;
@end

@interface NSMutableArray (ObjectToDictionary) <ObjectToDictionary>

@end

@interface NSArray (ObjectToDictionary) <ObjectToDictionary>

@end
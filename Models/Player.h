//
//  Player.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/29/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, copy) NSNumber* id;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* profilePictureUrlString;
@property (nonatomic) int score;

+ (NSArray*)parsePlayersFromArray:(NSArray*)iPlayersArray;
- (Player*)initWithDictionaryJsonValues:(NSDictionary*)dictionary;
@end

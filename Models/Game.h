//
//  Game.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/27/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Challenge.h"
#import "Player.h"

@interface Game : NSObject

@property (nonatomic, copy) NSNumber* id;
@property (nonatomic) int current_turn;
@property (nonatomic) BOOL waiting_to_challenge;

@property (nonatomic, strong) Player* player1;
@property (nonatomic, strong) Player* player2;

@property (nonatomic, strong) Challenge* nexthCallenge;

+ (NSArray*)parseGamesFromArray:(NSArray*)iGamesArray;
- (Game*)initWithDictionaryJsonValues:(NSDictionary*)dictionary;
@end

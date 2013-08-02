//
//  Game.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/27/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "Game.h"

NSString * const GAME_KEY_ID =                      @"id";
NSString * const GAME_KEY_CURRENT_TURN =            @"current_turn";
NSString * const GAME_KEY_WAITING_TO_CHALLANGE =    @"waiting_to_challange";
NSString * const GAME_KEY_PLAYER1 =                 @"player1";
NSString * const GAME_KEY_PLAYER2 =                 @"player2";
NSString * const GAME_KEY_NEXT_CHALLANGE =          @"next_challange";

@implementation Game
@synthesize id;
@synthesize nexthCallenge;

+ (NSArray*)parseGamesFromArray:(NSArray*)iGamesArray
{    
    NSMutableArray *arrayRetPages = [[NSMutableArray alloc] init];
    
    if (![iGamesArray isKindOfClass:[NSArray class]])
    {
        iGamesArray = [NSArray arrayWithObject:iGamesArray];
    }
    
    for (NSDictionary* dictionary in iGamesArray)
    {
        Game* game = [[Game alloc] initWithDictionaryJsonValues:dictionary];
        if (game)
        {
            [arrayRetPages addObject:game];
        }
    }
    
    return arrayRetPages;
}

- (Game*) initWithDictionaryJsonValues:(NSDictionary *)dictionary
{
    return [self initWithContentOfDictionary:dictionary];
}

#pragma mark - ObjectToDictionary protocol methods
- (id) initWithContentOfDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        // parse the gig data
        if(dict)
        {
            self.id = [dict objectForKey:GAME_KEY_ID];
            self.current_turn = [[dict objectForKey:GAME_KEY_CURRENT_TURN] intValue];
            self.waiting_to_challenge = [[dict objectForKey:GAME_KEY_WAITING_TO_CHALLANGE] boolValue];
            
            self.nexthCallenge = [[Challenge alloc] initWithDictionaryJsonValues:[dict objectForKey:GAME_KEY_NEXT_CHALLANGE]];
            
            self.player1 = [[Player alloc] initWithDictionaryJsonValues:[dict objectForKey:GAME_KEY_PLAYER1]];
            self.player2 = [[Player alloc] initWithDictionaryJsonValues:[dict objectForKey:GAME_KEY_PLAYER2]];
        }
        
        /*
         // validate fields
         if(nil == gig_id)
         {
         // MIKI - throw exception in my opinion
         gig_id = [NSNumber numberWithInt:1];
         }
         
         if (nil == gigDeliveryDays)
         {
         gigDeliveryDays = [NSNumber numberWithInt:0];
         }
         */
    }
    
    return self;
}

@end

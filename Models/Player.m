//
//  Player.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/29/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "Player.h"

NSString * const PLAYER_KEY_ID =                 @"id";
NSString * const PLAYER_KEY_NAME =               @"name";
NSString * const PLAYER_KEY_PROFILE_PICTURE =    @"profile_picture";
NSString * const PLAYER_KEY_SCORE =              @"score";

@implementation Player

+ (NSArray*)parsePlayersFromArray:(NSArray*)iPlayersArray
{
    NSMutableArray *arrayRet = [[NSMutableArray alloc] init];
    
    if (![iPlayersArray isKindOfClass:[NSArray class]])
    {
        iPlayersArray = [NSArray arrayWithObject:iPlayersArray];
    }
    
    for (NSDictionary* dictionary in iPlayersArray)
    {
        Player* player = [[Player alloc] initWithDictionaryJsonValues:dictionary];
        if (player)
        {
            [arrayRet addObject:player];
        }
    }
    
    return arrayRet;
}

- (Player*) initWithDictionaryJsonValues:(NSDictionary *)dictionary
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
            self.id = [dict objectForKey:PLAYER_KEY_ID];
            self.name = [dict objectForKey:PLAYER_KEY_NAME];
            self.profilePictureUrlString = [dict objectForKey:PLAYER_KEY_PROFILE_PICTURE];
            self.score = [[dict objectForKey:PLAYER_KEY_SCORE] intValue];
        }
    
    }
    
    return self;
}

- (NSDictionary*)contentsTodictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    if (self.id)
    {
        [dict setObject:self.id forKey:PLAYER_KEY_ID];
    }
    if (self.name)
    {
        [dict setObject:self.name forKey:PLAYER_KEY_NAME];
    }
    if (self.profilePictureUrlString)
    {
        [dict setObject:self.profilePictureUrlString forKey:PLAYER_KEY_PROFILE_PICTURE];
    }
    
    [dict setObject:[NSNumber numberWithInt:self.score] forKey:PLAYER_KEY_SCORE];
    
    return dict;
}

@end

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

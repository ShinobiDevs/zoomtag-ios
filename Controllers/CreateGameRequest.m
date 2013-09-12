//
//  CreateGameRequest.m
//  ZoomTag
//
//  Created by Miki Bergin on 8/11/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "CreateGameRequest.h"
#import "UserSession.h"

#define kGameUrlString @"games.json" // ? auth_token = "fdsfsdgsdfds"

@implementation CreateGameRequest

@synthesize opponent = _opponent;

- (id) initWithOpponent:(Player*)iOpponent Delegate:(ID_CONFORMS_CREATE_GAME_REQ_DELEGATE)delegate
{
    self = [super initWithDelegate:delegate];
    
    if (self)
    {
        _opponent = iOpponent;
        
        NSString* urlString = [NSString stringWithFormat:@"%@/%@?game[player2_id]=%@&auth_token=%@", [MBGlobalDefaults sharedInstance].serverUrlString, kGameUrlString, self.opponent.id, [UserSession sharedInstance].authToken];
        
        NSDLog(@"create game request for url:%@", urlString);
        
        urlGameServer = [[NSURL alloc] initWithString:urlString];
    }
    
    return self;
}

- (void) main
{
	if ([self isCancelled])
    {
        return;
    }
    
	@autoreleasepool
    {
        Game* game = nil;
        
        if (nil == urlGameServer)
        {
            // possibly throw exception
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlGameServer cachePolicy:0 timeoutInterval:60];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"POST"];
        
        NSHTTPURLResponse *response = nil;
        NSError* error = nil;
        
        //Synchronous call
        NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        [self doneProcessing];
        
        if(error == nil && response && response.statusCode == 200 && result != nil)
        {
            NSDictionary* dictJson = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            if (!dictJson)
            {
                NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                NSDLog(@"error occurred in the json parsing of a gig, this is the invalid json string:%@", responseString);
            }
            else
            {
                game = [[Game alloc] initWithDictionaryJsonValues:dictJson];
                
                result = nil;
                if (game)
                {
                    // Send replies to all delegates
                    for (ID_CONFORMS_CREATE_GAME_REQ_DELEGATE delegate in self.requestDelegateArray)
                    {
                        [delegate createGameRequestFinished:game];
                    }
                    
                    game = nil;
                    return;
                }
            }
        }
        
        // loop and send "error" to delegates
        for (ID_CONFORMS_CREATE_GAME_REQ_DELEGATE delegate in self.requestDelegateArray)
        {
            [delegate createGameRequestError];
        }
	}
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    if ([operation isKindOfClass:[self class]])
    {
        CreateGameRequest* game = (CreateGameRequest*)operation;
        
        if ([self.opponent.id isEqualToNumber:game.opponent.id])
        {
            return true;
        }
    }
    
    return false;
}
@end

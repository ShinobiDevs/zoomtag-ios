//
//  FacebookFriendsRequest.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "FBFriendsRequest.h"
#import "Player.h"

#define kFBFriendsUrlString @"friends.json" // ? auth_token = "fdsfsdgsdfds"

@implementation FBFriendsRequest

- (id) initWithDelegate:(ID_CONFORMS_FB_FRIENDS_REQ_DELEGATE)delegate;
{
    self = [super initWithDelegate:delegate];
    
    if (self)
    {
        NSString* urlString = [NSString stringWithFormat:@"%@/%@?&auth_token=PsttkEtxUmLbVbyGskSr", [MBGlobalDefaults sharedInstance].serverUrlString, kFBFriendsUrlString];
        
        NSDLog(@"facebook friends request for url:%@", urlString);
        
        urlFacebookFriends = [[NSURL alloc] initWithString:urlString];
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
        NSArray *arrayRetFriends = nil;
        
        if (nil == urlFacebookFriends)
        {
            // possibly throw exception
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlFacebookFriends cachePolicy:0 timeoutInterval:60];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        
        NSURLResponse *response = nil;
        NSError* error = nil;
        
        //Synchronous call
        NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        request = nil;
        response = nil;
        error = nil;
        
        [self doneProcessing];
        
        if(result != nil)
        {
            NSArray *arrayJsonPlayers = (NSArray*)[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            if (!arrayJsonPlayers)
            {
                NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                NSDLog(@"error occurred in the json parsing of the players, this is the invalid json string:%@", responseString);
            }
            else
            {
                arrayRetFriends = [Player parsePlayersFromArray:arrayJsonPlayers];
                
                result = nil;
                if (arrayRetFriends)
                {
                    // Send replies to all delegates
                    for (ID_CONFORMS_FB_FRIENDS_REQ_DELEGATE delegate in self.requestDelegateArray)
                    {
                        [delegate FBFriendsRequestFinished:arrayRetFriends];
                    }
                    
                    arrayRetFriends = nil;
                    return;
                }
            }
        }
        
        // loop and send "error" to delegates
        for (ID_CONFORMS_FB_FRIENDS_REQ_DELEGATE delegate in self.requestDelegateArray)
        {
            [delegate FBFriendsRequestError];
        }
	}
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    return true;
}
@end

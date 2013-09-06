//
//  GameRequest.m

#import "GameRequest.h"
#import "Game.h"
#import "UserSession.h"

#define kGameUrlString @"games.json" // ? auth_token = "fdsfsdgsdfds"

@implementation GameRequest

@synthesize pageNum = _pageNum;

- (id) initWithPageNum:(NSNumber*)iPageNum Delegate:(ID_CONFORMS_GAME_REQ_DELEGATE)delegate;
{
    self = [super initWithDelegate:delegate];
    
    if (self)
    {
        _pageNum = iPageNum;
        
        NSString* urlString = [NSString stringWithFormat:@"%@/%@?page=%@&auth_token=%@", [MBGlobalDefaults sharedInstance].serverUrlString, kGameUrlString, self.pageNum, [UserSession sharedInstance].authToken];
        
        NSDLog(@"game request for url:%@", urlString);
        
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
        NSArray *arrayRetPages = nil;
            
        if (nil == urlGameServer)
        {
            // possibly throw exception
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlGameServer cachePolicy:0 timeoutInterval:60];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

        
        NSHTTPURLResponse *response = nil;
        NSError* error = nil;
        
        //Synchronous call
        NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        request = nil;
        response = nil;
        error = nil;
        
        [self doneProcessing];
        
        if(response && response.statusCode == 200 && result != nil)
        {
            NSArray *arrayJsonPages = (NSArray*)[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            if (!arrayJsonPages)
            {
                NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                NSDLog(@"error occurred in the json parsing of a gig, this is the invalid json string:%@", responseString);
            }
            else
            {
                arrayRetPages = [Game parseGamesFromArray:arrayJsonPages];
                
                result = nil;
                if (arrayRetPages)
                {
                    // Send replies to all delegates
                    for (ID_CONFORMS_GAME_REQ_DELEGATE delegate in self.requestDelegateArray)
                    {
                        [delegate gameRequestFinished:arrayRetPages];
                    }
                    
                    arrayRetPages = nil;
                    return;
                }
            }
        }

        // loop and send "error" to delegates
        for (ID_CONFORMS_GAME_REQ_DELEGATE delegate in self.requestDelegateArray)
        {
            [delegate gameRequestError];
        }
	}
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    if ([operation isKindOfClass:[self class]])
    {
        GameRequest* game = (GameRequest*)operation;
        
        if (self.pageNum == game.pageNum)
        {
            return true;
        }
    }
    
    return false;
}
@end

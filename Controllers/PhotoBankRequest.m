//
//  PhotoBankRequest.m
//  ZoomTag
//
//  Created by Miki Bergin on 9/12/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "PhotoBankRequest.h"
#import "UserSession.h"

#define kFBFriendsUrlString @"pictures.json"

@implementation PhotoBankRequest
@synthesize searchTerm;

- (id) initWithSearchTerm:(NSString*)i_searcgTerm Delegate:(ID_CONFORMS_PHOTO_BANK_REQUEST_DELEGATE)delegate
{
    self = [super initWithDelegate:delegate];
    
    if (self)
    {
        searchTerm = i_searcgTerm;
        
        NSString* urlString = [NSString stringWithFormat:@"%@/%@?auth_token=%@&text=%@", [MBGlobalDefaults sharedInstance].serverUrlString, kFBFriendsUrlString, [UserSession sharedInstance].authToken, searchTerm];
        
        NSDLog(@"photo bank request for url:%@", urlString);
        
        url = [[NSURL alloc] initWithString:urlString];
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
        if (nil == url)
        {
            // possibly throw exception
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
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
            NSArray *arrayPhotos = (NSArray*)[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            if (!arrayPhotos)
            {
                NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                NSDLog(@"error occurred in the json photos, this is the invalid json string:%@", responseString);
            }
            else
            {
                // Send replies to all delegates
                for (ID_CONFORMS_PHOTO_BANK_REQUEST_DELEGATE delegate in self.requestDelegateArray)
                {
                    [delegate PhotoBankRequestFinished:arrayPhotos];
                }
                return;
            }
        }
        
        // loop and send "error" to delegates
        for (ID_CONFORMS_PHOTO_BANK_REQUEST_DELEGATE delegate in self.requestDelegateArray)
        {
            [delegate PhotoBankRequestError];
        }
	}
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    if ([operation isKindOfClass:[self class]])
    {
        PhotoBankRequest* request = (PhotoBankRequest*)operation;
        
        if (self.searchTerm == request.searchTerm)
        {
            return true;
        }
    }
    
    return false;
}
@end

//
//  UrlDataRequest.m
//  Fiverr
//
//  Created by Miki Bergin on 1/29/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import "UrlDataRequest.h"
#import "DiskCache.h"

@implementation UrlDataRequest

@synthesize url;

- (id) initWithDelegate:(ID_CONFORMS_URL_REQ_DELEGATE)delegate AndUrl:(NSURL*)urlForData
{
    self = [super initWithDelegate:delegate];
    if (self)
    {
        url = urlForData;
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
        NSData *data = [[DiskCache sharedCache] dataInCacheForURLString:[url absoluteString]];
        NSURL *localCopy = [self.url copy];
        if (!data) 
        {
            NSDLog(@"Starting download %@",url);
            data = [NSData dataWithContentsOfURL:url];
            NSDLog(@"Done %@",url);
            
            if (data) 
            {
                UIImage *image = [UIImage imageWithData:data];
                if (image) 
                {
                    [[DiskCache sharedCache] cacheData:data forUrlString:[localCopy absoluteString]];
                }
                
                image = nil;
            }
        } 
        else 
        {
            //  NSDLog(@"Skipping %@ already in cache",url);
            
        }
        
        [self doneProcessing];
        
        if(data != nil)
        {            
            // Send replies to all delegates
            for (ID_CONFORMS_URL_REQ_DELEGATE delegate in self.requestDelegateArray)
            {
                [delegate dataFinishedLoading:data CustomData:self.customData];
            }
        }
        else
        {
            // MIKI TODO analyze why this happens and add delegation of this event
            NSDLog(@"Failed to fetch image data from network for url:%@", self.url);
        }
        
        self.url = nil;
        data = nil;
        localCopy = nil;
	}
}

#pragma mark - MultiRecipientOperation overrides

- (BOOL) quickProcess
{
    NSData *data = [[DiskCache sharedCache] dataInCacheForURLString:[url absoluteString]];
    if(data)
    {
        // Send replies to all delegates
        for (ID_CONFORMS_URL_REQ_DELEGATE delegate in self.requestDelegateArray)
        {
            [delegate dataFinishedLoading:data CustomData:self.customData];
        }
        
        self.url = nil;
        return true;
    }
    return false;
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    if ([operation isKindOfClass:[self class]])
    {
        UrlDataRequest *requestTemp = (UrlDataRequest*)operation;
        if ([url isEqual:requestTemp.url])
        {
            return true;
        }
    }
    
    return false;
}
@end

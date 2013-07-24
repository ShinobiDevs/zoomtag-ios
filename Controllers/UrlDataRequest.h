//
//  UrlDataRequest.h
//  Fiverr
//
//  Created by Miki Bergin on 1/29/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import "RequestBase.h"

@protocol UrlDataRequestDelegate <RequestBaseDelegate>
@optional
- (void)dataFinishedLoading:(NSData*)urlData CustomData:(id)customData;
@end

typedef id<UrlDataRequestDelegate> ID_CONFORMS_URL_REQ_DELEGATE;

@interface UrlDataRequest : RequestBase
{    
    
}

@property (strong, atomic) NSURL* url;

- (id) initWithDelegate:(ID_CONFORMS_URL_REQ_DELEGATE)delegate AndUrl:(NSURL*)urlForData;
- (BOOL) equals:(MultiRecipientOperation*)operation;
@end

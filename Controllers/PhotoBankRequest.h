//
//  PhotoBankRequest.h
//  ZoomTag
//
//  Created by Miki Bergin on 9/12/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "RequestBase.h"

@protocol PhotoBankRequestDelegate <RequestBaseDelegate>
@optional
- (void)PhotoBankRequestFinished:(NSArray*) photos;
- (void)PhotoBankRequestError;
@end

typedef id<PhotoBankRequestDelegate> ID_CONFORMS_PHOTO_BANK_REQUEST_DELEGATE;

@interface PhotoBankRequest : RequestBase
{
    NSURL* url;
}

// needed as property for comparsion between requests
@property (nonatomic, readonly) NSString* searchTerm;

- (id) initWithSearchTerm:(NSString*)searcgTerm Delegate:(ID_CONFORMS_PHOTO_BANK_REQUEST_DELEGATE)delegate;
@end
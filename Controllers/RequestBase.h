//
//  RequestData.h
//  Fiverr
//
//  Created by Miki Bergin on 1/29/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiRecipientOperation.h"

@protocol RequestBaseDelegate <MultiRecipientOperationDelegate>
@end

typedef id<RequestBaseDelegate> ID_CONFORMS_REQUEST_DELEGATE;

@interface RequestBase : MultiRecipientOperation
{

}

@property (strong, nonatomic) id customData;

- (void)cancel;
- (void)cancelRecipient:(ID_CONFORMS_MULTI_DELEGATE)delegate;
@end

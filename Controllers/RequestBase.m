//
//  RequestData.m
//  Fiverr
//
//  Created by Miki Bergin on 1/29/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import "RequestBase.h"

@implementation RequestBase
@synthesize customData;

- (void) cancel
{
    [super cancel];
}

- (void)cancelRecipient:(ID_CONFORMS_MULTI_DELEGATE)delegate
{
    [super cancelRecipient:delegate];
}
@end

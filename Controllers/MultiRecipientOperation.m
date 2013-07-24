//
//  MultiRecipientOperation.m
//  Fiverr
//
//  Created by Miki Bergin on 1/26/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import "MultiRecipientOperation.h"

@implementation MultiRecipientOperation

@synthesize requestDelegateArray;

- (id) init 
{
    return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(ID_CONFORMS_MULTI_DELEGATE)delegate
{
    self = [super init];
    if (self)
    {
        processed = false;
        requestDelegateArray = [NSMutableArray new];
        [self addRequester:delegate];
    }
    
    return self;
}

- (BOOL) quickProcess
{
    return false;
}

- (void) addRequester:(ID_CONFORMS_MULTI_DELEGATE)delegate;
{
    requestCount++;
    
    // add delegate if it's not duplicate
    if(nil != delegate && ![requestDelegateArray containsObject:delegate])
    {
        [requestDelegateArray addObject:delegate];
    }
}

- (void) cancel
{
    for (ID_CONFORMS_MULTI_DELEGATE delegate in requestDelegateArray)
    {
        [self cancelRecipient:delegate];
    }
}

- (void) cancelRecipient:(ID_CONFORMS_MULTI_DELEGATE)delegate;
{
    if (--requestCount <= 0) 
    {
        [super cancel];
        // NSDLog(@"cancelled 0x%x for %@",(unsigned int)self,[[url absoluteString] lastPathComponent]);
    }
    
    [requestDelegateArray removeObject:delegate];
    [delegate requestRemoved];
}

- (void) doneProcessing
{
    processed = true;
}

- (BOOL) isProcessed
{
    return processed;
}

- (BOOL) equals:(MultiRecipientOperation*)operation
{
    return true;
}

@end

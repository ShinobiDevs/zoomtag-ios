//
//  FiverrAPIManager.m
//  FiverrApp
//
//  Created by Miki Bergin on 1/25/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import "QueuedOperationManager.h"
#import "DiskCache.h"

@implementation QueuedOperationManager

//@synthesize delegate;

- (id) init 
{
	self = [super init];
    if (self) 
    {
        queue = [NSOperationQueue new];
        
        // take optimal count by system
        //[queue setMaxConcurrentOperationCount:4];
        requestNumber = 0;
    }
    
	return self;
}
 
+ (QueuedOperationManager*)sharedInstance
{
    static dispatch_once_t pred;
    static QueuedOperationManager* shared = nil;
    dispatch_once(&pred, ^
    {
        shared = [[QueuedOperationManager alloc] init];
    });
    
    return shared;
}

- (RequestBase*) requestDataForUrlString:(NSString*)urlString CustomData:(id)customData Delegate:(ID_CONFORMS_MANAGER_DELEGATE)iDelegate;
{
    UrlDataRequest * urlRequest = [[UrlDataRequest alloc] initWithDelegate:iDelegate AndUrl:[NSURL URLWithString:urlString]];
    
    urlRequest.customData = customData;
    
    [urlRequest setQueuePriority:NSOperationQueuePriorityHigh];
    [self addOperation:urlRequest];
    
    return urlRequest;
}

- (RequestBase*) requestGamesForPage:(NSNumber*)iPageNum CustomData:(id)customData RequestDelegate:(ID_CONFORMS_MANAGER_DELEGATE)delegate
{
    GameRequest * gameRequest = [[GameRequest alloc] initWithPageNum:iPageNum Delegate:delegate];
    
    gameRequest.customData = customData;
    
    [gameRequest setQueuePriority:NSOperationQueuePriorityHigh];
    [self addOperation:gameRequest];
    
    return gameRequest;
}

- (RequestBase*) requestGameForOpponent:(Player*)iOpponent CustomData:(id)customData RequestDelegate:(ID_CONFORMS_MANAGER_DELEGATE)delegate
{
    CreateGameRequest * gameRequest = [[CreateGameRequest alloc] initWithOpponent:iOpponent Delegate:delegate];
    
    gameRequest.customData = customData;
    
    [gameRequest setQueuePriority:NSOperationQueuePriorityHigh];
    [self addOperation:gameRequest];
    
    return gameRequest;
}

- (RequestBase*) requestFBFriendsForCustomData:(id)customData Delegate:(ID_CONFORMS_MANAGER_DELEGATE)delegate
{
    FBFriendsRequest * request = [[FBFriendsRequest alloc] initWithDelegate:delegate];
    
    request.customData = customData;
    
    [request setQueuePriority:NSOperationQueuePriorityHigh];
    [self addOperation:request];
    
    return request;
}

- (RequestBase*) requestPhotoBankForTerm:(NSString*)searchTerm CustomData:(id)customData Delegate:(ID_CONFORMS_MANAGER_DELEGATE)delegate
{
    PhotoBankRequest * request = [[PhotoBankRequest alloc] initWithSearchTerm:searchTerm Delegate:delegate];
    
    request.customData = customData;
    
    [request setQueuePriority:NSOperationQueuePriorityHigh];
    [self addOperation:request];
    
    return request;
}

- (MultiRecipientOperation*) findOperationInQueue:(MultiRecipientOperation*)operation
{
    // see if there is already a request in the queue for this url
    NSArray *currentOperations = [queue operations];
    
    __block MultiRecipientOperation *operationFound = nil;
    
    [currentOperations enumerateObjectsUsingBlock:^(id op, NSUInteger idx, BOOL *stop)
    {
        if ([op isKindOfClass:[operation class]])
        {
            MultiRecipientOperation *operationTemp = op;
            if (![operationTemp isProcessed] && ![operationTemp isCancelled] && [operationTemp equals:operation])
            {
                operationFound = operationTemp;
                *stop = YES;
            }
        }
    }];
    
    return operationFound;
}
    
- (void) addOperation:(MultiRecipientOperation*)operation;
{
    // first try to quick process the request
    if(operation.quickProcess)
    {
        // quick process was sufficient
        return;
    }
    
    MultiRecipientOperation* operationExisting = [self findOperationInQueue:operation];
    if (!operationExisting) 
    {                
        [queue addOperation:operation];
    } 
    else 
    {
        if ([operation queuePriority] > [operationExisting queuePriority])
        {
            [operationExisting setQueuePriority:[operation queuePriority]];
        }
        
        // operation should have only the "new" delegate 
        // so pass it to existing operation
        if([operation.requestDelegateArray count])
        [operationExisting addRequester:[operation.requestDelegateArray objectAtIndex:0]];
    }
}

- (void) suspend 
{
	[queue setSuspended:YES];
}

- (BOOL) isSuspended 
{
	return [queue isSuspended];
}

- (void) resume 
{
	[queue setSuspended:NO];
}
@end

//
//  FiverrAPIManager.h
//  FiverrApp
//
//  Created by Miki Bergin on 1/25/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlDataRequest.h"

// ****** NOTE ********
// delegate calls will most likely be made not from the main thread
@protocol QueuedOperationManagerDelegate <UrlDataRequestDelegate>
@end

typedef id<QueuedOperationManagerDelegate> ID_CONFORMS_MANAGER_DELEGATE;

@interface QueuedOperationManager : NSObject
{
    NSOperationQueue *queue;
    
	NSUInteger requestNumber;
	//__unsafe_unretained id<ApiManagerDelegate> delegate;
}

//@property (nonatomic,assign) id<ApiManagerDelegate> delegate;

+ (QueuedOperationManager*) sharedInstance;

 
- (RequestBase*) requestDataForUrlString:(NSString*)urlString CustomData:(id)customData Delegate:(ID_CONFORMS_MANAGER_DELEGATE)iDelegate;

- (MultiRecipientOperation*) findOperationInQueue:(MultiRecipientOperation*)operation;
- (void) addOperation:(MultiRecipientOperation*)operation;
- (void) suspend;
- (void) resume;
- (BOOL) isSuspended;
@end
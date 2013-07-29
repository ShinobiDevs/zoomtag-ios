//
//  MultiRecipientOperation.h
//  Fiverr
//
//  Created by Miki Bergin on 1/26/12.
//  Copyright (c) 2012 Fiverr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultiRecipientOperationDelegate <NSObject>
@optional
- (void) requestRemoved;
@end

typedef id<MultiRecipientOperationDelegate> ID_CONFORMS_MULTI_DELEGATE;

@interface MultiRecipientOperation : NSOperation
{
    int requestCount;
    BOOL processed;
}

@property (nonatomic,strong) NSMutableArray* requestDelegateArray;

- (id) init;
- (id) initWithDelegate:(ID_CONFORMS_MULTI_DELEGATE)delegate;
- (BOOL) quickProcess;
- (void) addRequester:(ID_CONFORMS_MULTI_DELEGATE)delegate;
- (void) cancel;
- (void) cancelRecipient:(ID_CONFORMS_MULTI_DELEGATE)delegate;
- (void) doneProcessing;
- (BOOL) isProcessed;
- (BOOL) equals:(MultiRecipientOperation*)operation;
@end

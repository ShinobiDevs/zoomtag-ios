//
//  MBDispatch.m
//  ShinobiDevs
//
//  Created by Miki Bergin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBDispatch.h"

@implementation MBDispatch
+ (void) MBDispatchSyncTo:(dispatch_queue_t)iQueue DispatchBlock:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == iQueue) 
    {
        block();
    } 
    else 
    {
        dispatch_sync(iQueue, block);
    }  
}

+ (void) MBDispatchASyncTo:(dispatch_queue_t)iQueue DispatchBlock:(dispatch_block_t)block
{
    [MBDispatch MBDispatchASyncTo:iQueue ForceNextCycle:NO DispatchBlock:block];
}

+ (void) MBDispatchASyncTo:(dispatch_queue_t)iQueue ForceNextCycle:(BOOL)iForceNextCycle DispatchBlock:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == iQueue && !iForceNextCycle) 
    {
        block();
    } 
    else 
    {
        dispatch_async(iQueue, block);
    }    
}
@end

//
//  MBDispatch.h
//  Fiverr
//
//  Created by Miki Bergin on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBDispatch : NSObject

+ (void) MBDispatchASyncTo:(dispatch_queue_t)iQueue DispatchBlock:(dispatch_block_t)block;
+ (void) MBDispatchASyncTo:(dispatch_queue_t)iQueue ForceNextCycle:(BOOL)iForceNextCycle DispatchBlock:(dispatch_block_t)block;
@end

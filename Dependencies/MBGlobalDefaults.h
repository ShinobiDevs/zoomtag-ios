//
//  MBGlobalDefaults.h
//  Fiverr
//
//  Created by Miki Bergin on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBGlobalDefaults : NSObject


@property (nonatomic, copy) NSString* serverUrlString;
@property (nonatomic, copy, readonly) NSURL* serverUrl;

@property (nonatomic, copy) NSString* serverAuthenticationToken;

+ (MBGlobalDefaults*) sharedInstance;
- (MBGlobalDefaults*) init; 
@end

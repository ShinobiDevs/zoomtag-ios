//
//  MBGlobalDefaults.m
//  ShinobiDevs
//
//  Created by Miki Bergin on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBGlobalDefaults.h"

#define kDefaultServerUrl @"http://localhost:3000"
//#define kDefaultServerUrl @"http://ShinobiDevs:staging@staging.ShinobiDevsstaging.com"
//#define kDefaultServerUrl @"http://ShinobiDevs.com"

#define kServerAuthenticationTokenKey @"serverAuthetincationTokenKey"

#ifdef PRODUCTION
    #define kFBAppID @""
#endif
#ifdef STAGING
    #define kFBAppID @"515511105188973"
#endif
#ifdef DEVELOPMENT
    #define kFBAppID @"515511105188973"
    #define kRootServerUrl @"http://localhost:3000"
#endif


@implementation MBGlobalDefaults

@synthesize serverUrlString;
@synthesize serverAuthenticationToken = _serverAuthenticationToken;

+ (MBGlobalDefaults*) sharedInstance
{
    static dispatch_once_t pred;
    static MBGlobalDefaults *shared = nil;
    dispatch_once(&pred, 
    ^{
        shared = [[MBGlobalDefaults alloc] init];
    });
    
    return shared;    
}

- (MBGlobalDefaults*) init
{
    self = [super init];
    if (self)
    {
        // load dictionary from disk
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults)
        {
            _serverAuthenticationToken = [standardUserDefaults objectForKey:kServerAuthenticationTokenKey];
        }
        
        self.serverUrlString = kDefaultServerUrl;
    }
    return self;
}

- (NSURL*) serverUrl
{
    return [NSURL URLWithString:self.serverUrlString];
}

- (void) setServerAuthenticationToken:(NSString*) token
{
    _serverAuthenticationToken = token;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:_serverAuthenticationToken forKey:kServerAuthenticationTokenKey];
}

- (NSString*) fbAppID
{
    return kFBAppID;
}

- (NSString*) rootServerUrl
{
    return kRootServerUrl;
}
@end

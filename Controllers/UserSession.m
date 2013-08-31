//
//  FiverrUserSession.m
//  Fiverr
//
//  Created by Miki Bergin on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <libxml2/libxml/HTMLparser.h>

#import "UserSession.h"
#import "MBGlobalDefaults.h"

NSString * const USER_SESSION_KEY = @"user_session";

NSString * const SESSION_KEY_PLAYER =     @"player";
NSString * const SESSION_KEY_AUTH_TOKEN = @"auth_token";

@implementation UserSession

@synthesize fbSession;

@synthesize updating;
//@synthesize request;
@synthesize wrapper;
@synthesize deviceToken;
@synthesize userStatus = _userStatus;
//@synthesize facebookInstance = _facebookInstance;
@synthesize deviceReferenceToken = _deviceReferenceToken;
@synthesize delegate = _delegate;
@synthesize player;
@synthesize authToken;

+ (UserSession*) sharedInstance
{
    static dispatch_once_t pred;
    static UserSession *shared = nil;
    dispatch_once(&pred, ^
    {
        shared = [UserSession new];
    });
    
    return shared;    
}

- (BOOL) validateCookies
{   
    /*
    BOOL fiverrSessionCookieExists = NO;
    BOOL credentialsCookieExists = NO;
    
    // determine we have all the cookies for logged in state and that they are still valid
    NSArray* cookiesForFiverrArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[MBGlobalDefaults sharedInstance].serverUrl];
    for (NSHTTPCookie* cookie in cookiesForFiverrArray)
    {
        if ([kFIVERR_SESSION_COOKIE_NAME isEqualToString:cookie.name]) 
        {
            fiverrSessionCookieExists = YES;
        }
        else if ([kFIVERR_CREDENTIALS_COOKIE_NAME isEqualToString:cookie.name]) 
        {
            credentialsCookieExists = YES;
        }
    }
    
    return (fiverrSessionCookieExists && credentialsCookieExists);
    */
    
    // MIKI - fiverr cookies change too much
    // disabling this for the time being
    return YES;
}

- (UserSession*) init
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];	
	if (standardUserDefaults)
    {        
        // fetch from disk the previos userSession
        NSDictionary* dict = [standardUserDefaults objectForKey:USER_SESSION_KEY];
        self = [self initWithContentOfDictionary:dict];

        if (self)
        {

            self.fbSession = [[FBSession alloc] initWithAppID:[MBGlobalDefaults sharedInstance].fbAppID permissions:nil urlSchemeSuffix:nil
                                           tokenCacheStrategy:[[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:@"FBAccessTokenInformationKey"]];
            
            // determine if we are logged in or not
            // currently I will be satisfied if username is set and all the cookies are in place.
            if (self.fbSession.isOpen)
            {
                if([self validateCookies])
                {
                    _userStatus = UserStatusLoggedIn;
                }
                else
                {
                    
                }
            }

            else
            {
                _userStatus = UserStatusNotLoggedIn;
            }
        }
    }
    else
    {
        // MIKI TODO ERROR
    }
    return self;
}

//- (void) loginWithFacebookWithDelegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//    {
//        // send to fiverr the facebook access_token and process the reply
//        MBGlobalDefaults* defaults = [MBGlobalDefaults sharedInstance];
//        NSHTTPURLResponse* response;
//        NSError* error;
//        NSMutableURLRequest* request;
//       
//        NSString* authenticationFullUrl = [NSString stringWithFormat:@"%@/%@", defaults.serverUrlString, kAuthenticationWithFacebookUrlStringFormat];
//        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authenticationFullUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//       
//        NSString *post = [NSString stringWithFormat:@"token=%@&iphone=1", self.facebookInstance.accessToken];
//        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//       
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:postData];
//       
//        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//       
//        FiverrFacebookLoginStatus eFacebookLoginStatus;
//       
//        if (response)
//        {
//            NSDLog(@"response status for fiverr facebook login:%d", response.statusCode);
//            switch (response.statusCode)
//            {
//                case 200:
//                    eFacebookLoginStatus = FiverrFacebookLoginStatusSuccess;
//                    break;
//                   
//                case 202:
//                    eFacebookLoginStatus = FiverrFacebookLoginStatusRegisterRequired; 
//                    break;
//                   
//                case 500:
//                    eFacebookLoginStatus = FiverrFacebookLoginStatusFailure;
//                    break;
//                    
//                default:
//                    eFacebookLoginStatus = FiverrFacebookLoginStatusFailure;
//                    break;
//            }
//        }
//        else
//        {
//            // no reply header at all - failure
//            eFacebookLoginStatus = FiverrFacebookLoginStatusFailure;
//        }
//       
//        if (FiverrFacebookLoginStatusSuccess ==  eFacebookLoginStatus)
//        {
//            if ([self validateCookies])
//            {
//                _userStatus = FiverrUserStatusLoggedIn;
//            }
//            else
//            {
//                eFacebookLoginStatus = FiverrFacebookLoginStatusFailure;
//            }
//        }
//       
//        NSArray* cookiesForFiverrArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[MBGlobalDefaults sharedInstance].serverUrl];
//        
//        for (NSHTTPCookie* cookie in cookiesForFiverrArray)
//        {
//            NSDLog(@"print at loginWithFacebookWithDelegate %@, %@, %d", cookie.name, cookie.expiresDate, cookie.isSessionOnly);
//        }
//        
//        [iDelegate loginWithFacebookReply:eFacebookLoginStatus];
//    });
//}
- (void) persistSessionToDisk
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults)
    {   
        NSDictionary* userSessionDict = [self contentsTodictionary];
        [standardUserDefaults setObject:userSessionDict forKey:USER_SESSION_KEY];
        [standardUserDefaults synchronize];
	}
}

#pragma mark - ObjectToDictionary protocol methods

- (id) initWithContentOfDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if (self && dict)
    {
        self.player = [[Player alloc] initWithContentOfDictionary:[dict objectForKey:SESSION_KEY_PLAYER]];
        self.authToken = [dict objectForKey:SESSION_KEY_AUTH_TOKEN];
    }
    
    return self;
}

- (NSDictionary*) contentsTodictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    if (self.player)
    {
        [dict setObject:[self.player contentsTodictionary] forKey:SESSION_KEY_PLAYER];
    }
    if (self.authToken)
    {
        [dict setObject:self.authToken forKey:SESSION_KEY_AUTH_TOKEN];
    }
    
    return dict;
}

- (void) connectWithFacebook
{
    NSHTTPURLResponse   * response;
    NSError             * error;
    NSMutableURLRequest * request;
    
    NSString* serverUrl = [MBGlobalDefaults sharedInstance].rootServerUrl;
    NSString* authUrl = [NSString stringWithFormat:@"%@%@", serverUrl, @"/players/sign_in"];
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    NSString *post = [NSString stringWithFormat:@"access_token=%@", self.fbSession.accessTokenData.accessToken];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (response)
    {
        switch (response.statusCode)
        {
            case 200:
            {
                _userStatus = UserStatusLoggedIn;
                if(result != nil)
                {
                    NSDictionary *playerDictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                    
                    if (!playerDictionary)
                    {
                        NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                        
                        NSDLog(@"error occurred in the json parsing of a player, this is the invalid json string:%@", responseString);
                    }
                    else
                    {
                        self.player = [[Player alloc] initWithDictionaryJsonValues:playerDictionary];
                        self.authToken = [playerDictionary objectForKey:@"authentication_token"];
                    }
                }
                break;
            }
        }
    }
}
@end


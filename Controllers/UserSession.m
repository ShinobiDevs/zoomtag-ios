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

#define kAuthenticationUrlString @"v1/authentication"
#define kAuthenticationWithFacebookUrlStringFormat @"v1/facebook/authentication"
#define kRegisterWithFacebookUrlStringFormat @"v1/sign_up"

#define kUSER_SESSION_KEY @"userSession"
#define USER_SESSION_USERNAME_KEY @"username"
#define kUSER_SESSION_PASSWORD_KEY @"password"
#define kUSER_SESSION_EMAIL_KEY @"email"

#define kSESSION_COOKIE_NAME @"_fiverr_sessions"
#define kCREDENTIALS_COOKIE_NAME @"fiverr_auth_info"

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
        NSDictionary* dict = [standardUserDefaults objectForKey:kUSER_SESSION_KEY];
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
            
            // init the facebook instance and load previos session if exists
            //_facebookInstance = [[Facebook alloc] initWithAppId:[MBGlobalDefaults sharedInstance].facebookFiverrAppID andDelegate:(id)self];
            
//            if ([standardUserDefaults objectForKey:@"FBAccessTokenKey"] && [standardUserDefaults objectForKey:@"FBExpirationDateKey"])
//            {
//                self.facebookInstance.accessToken = [standardUserDefaults objectForKey:@"FBAccessTokenKey"];
//                self.facebookInstance.expirationDate = [standardUserDefaults objectForKey:@"FBExpirationDateKey"];
//            }
//            
//            if ([self.facebookInstance isSessionValid]) 
//            {
//                [self.facebookInstance extendAccessToken];
//            }
        }
    }
    else
    {
        // MIKI TODO ERROR
    }
    return self;
}

//- (LoginStatus) login
//{
//    MBGlobalDefaults* defaults = [MBGlobalDefaults sharedInstance];
//    
//    NSHTTPURLResponse   * response;
//    NSError             * error;
//    NSMutableURLRequest * request;
//    
//    NSString* authenticationFullUrl = [NSString stringWithFormat:@"%@/%@", defaults.serverUrlString, kAuthenticationUrlString];
//    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authenticationFullUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//    
//    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@", self.username, self.password];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//
//    FiverrLoginStatus eLoginStatus;
//    
//    if (response)
//    {
//        switch (response.statusCode)
//        {
//            case 200:
//                eLoginStatus = FiverrLoginStatusSuccess;
//                break;
//                
//            case 403:
//                eLoginStatus = FiverrLoginStatusMissingData;
//                break;
//                
//            case 401:
//                eLoginStatus = FiverrLoginStatusIncorrectCredentials;
//                break;
//            default:
//                //wtf
//                break;
//        }
//    }
//    else
//    {
//        // we must have failed with an error
//        // currently I cannot foresee an error other than authentication which is 401 in disguise
//        if (NSURLErrorUserCancelledAuthentication == error.code)
//        {
//            eLoginStatus = FiverrLoginStatusIncorrectCredentials;
//        }
//        else
//        {
//            eLoginStatus = FiverrLoginStatusGeneralFailure;
//        }
//    }
//    if (FiverrLoginStatusSuccess ==  eLoginStatus)
//    {
//        if ([self validateCookies])
//        {
//            _userStatus = FiverrUserStatusLoggedIn;
//        }
//        else
//        {
//            eLoginStatus = FiverrLoginStatusGeneralFailure;
//        }
//    }
//    
//    return eLoginStatus;
//}
//
//- (FiverrLoginStatus) loginWithUsername:(NSString*)iUsername password:(NSString*)iPassword
//{
//    self.username = iUsername;
//    self.password = iPassword;
//    
//    return [self login];
//}
//
//- (void) loginAsyncWithUsername:(NSString *)iUsername password:(NSString *)iPassword Delegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//    {
//        FiverrLoginStatus eLoginStatus = [self loginWithUsername:iUsername password:iPassword];
//        
//        [iDelegate loginReply:eLoginStatus];
//    });
//}
//
//- (void) registerWithFacebookForUsername:(NSString*)iUsername email:(NSString*)iUserEmail Delegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate
//{
//    self.username = iUsername;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//   {
//       // send registeration details to fiverr
//       MBGlobalDefaults* defaults = [MBGlobalDefaults sharedInstance];
//       NSHTTPURLResponse* response;
//#ifdef DEBUG
//       NSError* error;
//#endif
//       NSMutableURLRequest* request;
//       
//       NSString* authenticationFullUrl = [NSString stringWithFormat:@"%@/%@", defaults.serverUrlString, kRegisterWithFacebookUrlStringFormat];
//       request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authenticationFullUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
//       
//       NSString *post = [NSString stringWithFormat:@"user[username]=%@&user[email]=%@", iUsername, iUserEmail];
//       NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//       
//       [request setHTTPMethod:@"POST"];
//       [request setHTTPBody:postData];
//#ifdef DEBUG     
//       NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//#endif
//       
//       FiverrFacebookRegisterStatus eFacebookRegisterStatus;
//       
//       if (response)
//       {
//           NSDLog(@"response status for fiverr facebook login:%d", response.statusCode);
//           switch (response.statusCode)
//           {
//               case 200:
//                   eFacebookRegisterStatus = FiverrFacebookRegisterStatusSuccess;
//                   break;
//                   
//               case 417:
//               {
//                   // MIKI TODO parse the error that returns and notify user of the problem
//                   eFacebookRegisterStatus = FiverrFacebookRegisterStatusFailure;
//#ifdef DEBUG
//                   NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//                   NSDLog(@"%@", responseString);
//#endif
//                   break;
//               }
//               default:
//                   eFacebookRegisterStatus = FiverrFacebookRegisterStatusFailure;
//                   break;
//           }
//       }
//       else
//       {
//           // no reply header at all - failure
//           eFacebookRegisterStatus = FiverrFacebookRegisterStatusFailure;
//       }
//    
//       if (FiverrFacebookLoginStatusSuccess ==  eFacebookRegisterStatus && [self validateCookies])
//       {
//           _userStatus = FiverrUserStatusLoggedIn;
//       }
//       
//       NSArray* cookiesForFiverrArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[MBGlobalDefaults sharedInstance].serverUrl];
//       
//       for (NSHTTPCookie* cookie in cookiesForFiverrArray)
//       {
//           NSDLog(@"print at loginWithFacebookWithDelegate %@, %@, %d", cookie.name, cookie.expiresDate, cookie.isSessionOnly);
//       }
//       
//       [iDelegate registerWithFacebookReply:eFacebookRegisterStatus];
//   });
//}
//
//- (void) logout
//{
//    self.username = nil;
//    self.password = nil;
//    
//    // delete the cookies
//    NSArray* cookiesForFiverrArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[MBGlobalDefaults sharedInstance].serverUrl];
//    for (NSHTTPCookie* cookie in cookiesForFiverrArray)
//    {
//        if (kFIVERR_SESSION_COOKIE_NAME == cookie.name || 
//            kFIVERR_CREDENTIALS_COOKIE_NAME == cookie.name) 
//        {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
//    
//    _userStatus = FiverrUserStatusNotLoggedIn;
//}
//
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
//
//- (void) authorizeFacebook
//{
//    // make sure the current session isn't valid
//    if (!self.facebookInstance.isSessionValid)
//    {
//        NSArray* _permissions =  [NSArray arrayWithObjects:@"publish_stream",nil];
//        [self.facebookInstance authorize:_permissions];
//    }
//    else
//    {
//        // technically we can reply on the delegate right now!!
//        [self.delegate facebookAuthorizationReply];
//    }
//}
//
//- (BOOL) needToUpdateRegistration
//{
//    return NO;
//}
//

- (void) persistSessionToDisk
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults)
    {   
        NSDictionary* userSessionDict = [self contentsTodictionary];
        [standardUserDefaults setObject:userSessionDict forKey:kUSER_SESSION_KEY];
        [standardUserDefaults synchronize];
	}
}

//- (void) getAuthToken
//{
//    // do simple get from server
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://fiverr.com"] cachePolicy:0 timeoutInterval:60];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    
//    
//    NSURLResponse *response = nil;
//    NSError* error = nil;
//    
//    //Synchronous call
//    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    request = nil;
//    response = nil;
//    error = nil;
//    
//    NSString* authContainingHTML = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];;
//    
//    
//    authContainingHTML = @"";
//    /*
//    HTMLParser *parser = [[HTMLParser alloc] initWithString:authContainingHTML error:&error];
//    
//    if (error) 
//    {
//        NSDLog(@"Auth token fetch Error: %@", error);
//        return;
//    }
//    
//    HTMLNode *bodyNode = [parser body];
//    
//    NSArray *inputNodes = [bodyNode findChildTags:@"input"];
//    
//    for (HTMLNode *inputNode in inputNodes) 
//    {
//        if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) 
//        {
//            NSDLog(@"%@", [inputNode getAttributeNamed:@"value"]); //Answer to first question
//        }
//    }
//    */
//}
//
//#pragma mark - FBDialogDelegate protocol methods
//
//- (void)fbDidLogin 
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (defaults)
//    {
//        [defaults setObject:[self.facebookInstance accessToken] forKey:@"FBAccessTokenKey"];
//        [defaults setObject:[self.facebookInstance expirationDate] forKey:@"FBExpirationDateKey"];
//        [defaults synchronize];
//    }
//    
//    // notify delgate facebook is connected
//    [self.delegate facebookAuthorizationReply];
//}
//
//- (void)fbDidNotLogin:(BOOL)cancelled
//{
//    NSDLog(@"fbDidNotLogin");
//}
//
//-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (defaults)
//    {
//        [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
//        [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
//        [defaults synchronize];
//    }
//}
//
#pragma mark - ObjectToDictionary protocol methods

- (id) initWithContentOfDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if (self && dict)
    {
        //self.username = [dict objectForKey:kFIVERR_USER_SESSION_USERNAME_KEY];
    }
    
    return self;
}

- (NSDictionary*) contentsTodictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
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


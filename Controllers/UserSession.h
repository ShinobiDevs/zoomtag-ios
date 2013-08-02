//
//  FiverrUserSession.h
//  Fiverr
//
//  Created by Miki Bergin on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectToDictionary.h"
#import "Player.h"

@class KeychainItemWrapper, ASIHTTPRequest;

typedef enum
{
    UserStatusNotLoggedIn,
    UserStatusLoggedIn,
} UserStatus;

typedef enum
{
    LoginStatusSuccess,
    LoginStatusMissingData,
    LoginStatusIncorrectCredentials,
    LoginStatusGeneralFailure
} LoginStatus;

typedef enum
{
    FacebookLoginStatusSuccess,
    FacebookLoginStatusRegisterRequired,
    FacebookLoginStatusFailure // WTF
} FacebookLoginStatus;

typedef enum
{
    FacebookRegisterStatusSuccess,
    FacebookRegisterStatusFailure,
} FacebookRegisterStatus;

@protocol UserSessionOperationsDelegate <NSObject>
@optional
- (void) loginReply:(LoginStatus)iLoginStatus;
- (void) loginWithFacebookReply:(FacebookLoginStatus)iFacebookLoginStatus;
- (void) registerWithFacebookReply:(FacebookRegisterStatus)iFacebookRegisterStatus;
- (void) facebookAuthorizationReply;
@end

typedef id<UserSessionOperationsDelegate> ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE;

@interface UserSession : NSObject <ObjectToDictionary>
{
	NSData *deviceToken;
	KeychainItemWrapper *wrapper;
    
	BOOL updating;
	NSMutableDictionary *registration;
}

@property (strong, nonatomic) FBSession *fbSession;

@property (nonatomic, assign) BOOL updating;
//@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) KeychainItemWrapper *wrapper;
@property (nonatomic, copy) NSData *deviceToken;

@property (assign, nonatomic, readonly) UserStatus userStatus;
//@property (strong, nonatomic, readonly) Facebook* facebookInstance;
@property (strong, nonatomic) NSString* deviceReferenceToken;
@property (strong, nonatomic) ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE delegate;
@property (strong, nonatomic) Player* player;
@property (copy, nonatomic) NSString* authToken;

+ (UserSession*) sharedInstance;

- (UserSession*) init;
//- (LoginStatus) loginWithUsername:(NSString*)iUsername password:(NSString*)iPassword;
//- (void) loginAsyncWithUsername:(NSString*)iUsername password:(NSString*)iPassword Delegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate;
//- (void) registerWithFacebookForUsername:(NSString*)iUsername email:(NSString*)iUserEmail Delegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate;
//- (void) logout;
//- (void) loginWithFacebookWithDelegate:(ID_CONFIRMS_USERSESSION_OPERATIONS_DELEGATE)iDelegate;
//- (void) authorizeFacebook;
//- (void) getAuthToken;

//- (BOOL) needToUpdateRegistration;
- (void) persistSessionToDisk;
- (void) connectWithFacebook;
@end
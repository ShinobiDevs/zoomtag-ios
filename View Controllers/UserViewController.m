//
//  LoginViewController.m
//  picloc
//
//  Created by Miki Bergin on 5/20/13.
//  Copyright (c) 2013 Miki Bergin. All rights reserved.
//

#import "UserViewController.h"
#import "UserSession.h"

@interface UserViewController ()

@end

@implementation UserViewController

#pragma mark - UIViewController overrides & callbacks
- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)facebookConnectPressed:(id)sender
{
    // this button's job is to flip-flop the session from open to closed
    UserSession* userSession = [UserSession sharedInstance];

    [userSession.fbSession closeAndClearTokenInformation];
    
    if (userSession.fbSession.state != FBSessionStateCreated)
    {
        // Create a new, logged out session.
        userSession.fbSession = [[FBSession alloc] initWithAppID:[MBGlobalDefaults sharedInstance].fbAppID permissions:nil urlSchemeSuffix:nil
                                       tokenCacheStrategy:[[FBSessionTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:@"FBAccessTokenInformationKey"]];
    }
//        userSession.fbSession = [[FBSession alloc] init];
    // if the session isn't open, let's open it now and present the login UX to the user

    [userSession.fbSession openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error)
    {
        [[UserSession sharedInstance] connectWithFacebook];
    }];
}
@end

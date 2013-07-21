//
//  LoginViewController.h
//  picloc
//
//  Created by Miki Bergin on 5/20/13.
//  Copyright (c) 2013 Miki Bergin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@protocol UserViewControllerDelegate <NSObject>
@required
- (void) loginSuccessful;
- (void) cancelLogin;
@end

typedef id<UserViewControllerDelegate> ID_CONFIRMS_LOGIN_CONTROLLER_DELEGATE;

@interface UserViewController : UIViewController
{
    MBProgressHUD* hud;
}


@property (weak, nonatomic) ID_CONFIRMS_LOGIN_CONTROLLER_DELEGATE delegate;

- (IBAction)facebookConnectPressed:(id)sender;
@end

//
//  LoginViewController.h
//  picloc
//
//  Created by Miki Bergin on 5/20/13.
//  Copyright (c) 2013 Miki Bergin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@protocol LoginViewControllerDelegate <NSObject>
@required
- (void) loginSuccessful;
- (void) cancelLogin;
@end

typedef id<LoginViewControllerDelegate> ID_CONFIRMS_LOGIN_CONTROLLER_DELEGATE;

@interface LoginViewController : UIViewController <UITableViewDataSource>
{
    NSArray* inputFieldsDataArray;
    MBProgressHUD* hud;
}

@property (weak, nonatomic) ID_CONFIRMS_LOGIN_CONTROLLER_DELEGATE delegate;

@property (weak, nonatomic) IBOutlet UITableView *userDetailsTableView;

- (IBAction)signinPressed:(id)sender;
@end

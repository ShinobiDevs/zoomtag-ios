//
//  ViewController.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewController.h"
#import "GameViewController.h"

@interface ManagerViewController : UIViewController <UserViewControllerDelegate>

@property (strong, nonatomic) UserViewController *userViewController;
@property (strong, nonatomic) GameViewController *gameViewController;

@end

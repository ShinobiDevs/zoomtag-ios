//
//  ViewController.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "ManagerViewController.h"
#import "UIImageViewAdditions.h"
#import "UserViewController.h"
#import "UserSession.h"

@interface ManagerViewController ()

@end

@implementation ManagerViewController

@synthesize userViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    
    // Check if user is logged in, otherwise redirect to login
    if([UserSession sharedInstance].userStatus != UserStatusLoggedIn)
    {
        [self.view addSubview:userViewController.view];
    }
    else
    {
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

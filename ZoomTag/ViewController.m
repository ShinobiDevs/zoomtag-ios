//
//  ViewController.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "ViewController.h"
#import "UIImageViewAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageScrollView;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressed:(id)sender
{
    [imageView fitToParent];
    [imageView zoomByScale:15 animated:false];

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:NO];
}

- (void)timerTicked:(NSTimer*)timer
{
    [imageView zoomByScale:1.0f / 15.0f animated:true];
}

@end

//
//  ViewController.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)pressed:(id)sender;

@end

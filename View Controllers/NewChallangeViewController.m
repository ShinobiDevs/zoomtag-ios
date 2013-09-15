//
//  NewChallangeViewController.m
//  ZoomTag
//
//  Created by Miki Bergin on 9/12/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "NewChallangeViewController.h"

@interface NewChallangeViewController ()

@end

@implementation NewChallangeViewController
@synthesize game;
@synthesize gridView;
@synthesize placeholderImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate protocol methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [[QueuedOperationManager sharedInstance] requestPhotoBankForTerm:searchBar.text CustomData:nil Delegate:self];
}


#pragma mark - PhotoBankRequestDelegate protocol methods

- (void) PhotoBankRequestFinished:(NSArray *)photos
{
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
        self.gridView = [[ImageGridView alloc] initWithFrame:self.placeholderImageView.frame];
        gridView.imageUrlArray = photos;
        [self.view addSubview:gridView];
        gridView.hidden = YES;
        gridView.hidden = NO;
        self.placeholderImageView.hidden = YES;
        
        [gridView setNeedsLayout];
        [gridView becomeActive];
     }];
}

@end

//
//  NewChallangeViewController.h
//  ZoomTag
//
//  Created by Miki Bergin on 9/12/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueuedOperationManager.h"
#import "ImageGridView.h"

@interface NewChallangeViewController : UIViewController <QueuedOperationManagerDelegate, UISearchBarDelegate>
@property (nonatomic, weak) Game* game;
@property (nonatomic, strong) ImageGridView* gridView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@end

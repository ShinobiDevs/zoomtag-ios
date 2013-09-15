//
//  ImageGridView.h
//  ZoomTag
//
//  Created by Miki Bergin on 9/14/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueuedOperationManager.h"

@interface ImageGridView : UIScrollView <QueuedOperationManagerDelegate>
@property (nonatomic, retain) NSArray* imageUrlArray;
- (void) becomeActive;
@end
//
//  FBFriendsTableViewCell.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "FBFriendsTableViewCell.h"

@implementation FBFriendsTableViewCell

@synthesize player;
@synthesize profilePicImageView;
@synthesize nameLabel;

+ (NSString*) identifier
{
    return @"FBFriendsTableViewCell";
}

- (void) awakeFromNib
{
    self.indentationWidth = 0;
}

- (void) configureWithPlayer:(Player*)iPlayer
{
    self.player = iPlayer;
    self.nameLabel.text = self.player.name;
    
    [[QueuedOperationManager sharedInstance] requestDataForUrlString:self.player.profilePictureUrlString CustomData:nil Delegate:self];
}

#pragma mark - QueuedOperationManagerDelegate

- (void)dataFinishedLoading:(NSData*)urlData CustomData:(id)customData
{
    UIImage* urlImage = [UIImage imageWithData:urlData];
    
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         self.profilePicImageView.image = urlImage;
     }];
}

@end

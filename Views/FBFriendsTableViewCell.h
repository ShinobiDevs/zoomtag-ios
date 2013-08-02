//
//  FBFriendsTableViewCell.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueuedOperationManager.h"
#import "Player.h"

@interface FBFriendsTableViewCell : UITableViewCell <QueuedOperationManagerDelegate>

@property (nonatomic, weak) Player* player;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (NSString*) identifier;

- (void) configureWithPlayer:(Player*)player;
@end

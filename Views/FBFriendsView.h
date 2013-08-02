//
//  FBFriendsView.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@protocol FBFriendsViewDelegate
@optional
- (void)FBFriendSelected:(Player*)player;
- (void)FBFriendSelectCanacelled;
@end

typedef id<FBFriendsViewDelegate> ID_FB_FRIENDS_VIEW_DELGATE;

@interface FBFriendsView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    ID_FB_FRIENDS_VIEW_DELGATE delegate;
}

@property (nonatomic, strong) NSArray* FBPlayerFriendsArray;

@property (weak, nonatomic) IBOutlet UITableView *fbFriendsTableView;

- (void) configureForPlayers:(NSArray*)players WithDelegate:(ID_FB_FRIENDS_VIEW_DELGATE)iDelegate;
- (void) refresh;
@end

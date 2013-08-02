//
//  FBFriendsView.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "FBFriendsView.h"
#import "FBFriendsTableViewCell.h"

@implementation FBFriendsView

@synthesize FBPlayerFriendsArray;

- (void) awakeFromNib
{
    self.FBPlayerFriendsArray = [[NSArray alloc] init];
    
    [self.fbFriendsTableView registerNib:[UINib nibWithNibName:@"FBFriendsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[FBFriendsTableViewCell identifier]];
    
    self.fbFriendsTableView.dataSource = self;
}

- (void) configureForPlayers:(NSArray*)players WithDelegate:(ID_FB_FRIENDS_VIEW_DELGATE)iDelegate
{
    delegate = iDelegate;
    self.FBPlayerFriendsArray = players;
}

- (void) refresh
{
    [self.fbFriendsTableView reloadData];
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Only one section, so return the number of items in the list.
    return [self.FBPlayerFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FBFriendsTableViewCell identifier]];
    
    Player* player = [self.FBPlayerFriendsArray objectAtIndex:indexPath.row];
    [cell configureWithPlayer:player];
    
    return cell;
}

#pragma mark - TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBFriendsTableViewCell *cell = (FBFriendsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [delegate FBFriendSelected:cell.player];
}
@end

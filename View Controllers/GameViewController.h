//
//  GameViewController.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/21/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCollection.h"
#import "QueuedOperationManager.h"
#import "FBFriendsView.h"
#import "GameView.h"
#import "NewChallangeViewController.h"
\
@interface GameViewController : UIViewController <GameCollectionDelegate, QueuedOperationManagerDelegate, FBFriendsViewDelegate>
{
    UINib* gameViewNib;
    UINib* fbFriendsViewNib;
    
    GameCollection* gameCollection;
}

@property (nonatomic, strong) NSDictionary* gameViewDict;
@property (nonatomic, strong) NewChallangeViewController* challangeNewViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *gameScrollView;

- (IBAction)showFBFriendsPressed:(id)sender;
- (IBAction)playWithFriendPressed:(id)sender;
@end

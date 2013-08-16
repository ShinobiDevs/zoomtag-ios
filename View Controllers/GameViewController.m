//
//  GameViewController.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/21/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize gameViewDict;

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        gameViewNib = [UINib nibWithNibName:@"GameView" bundle:[NSBundle mainBundle]];
        fbFriendsViewNib = [UINib nibWithNibName:@"FBFriendsView" bundle:[NSBundle mainBundle]];
        
        gameCollection = [[GameCollection alloc] initWithDelegate:self];
        [gameCollection cacheGames:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFBFriendsPressed:(id)sender
{
    // issue the list friends request
    [[QueuedOperationManager sharedInstance] requestFBFriendsForCustomData:nil Delegate:self];
}


#pragma mark - private methods

- (void) refreshGames
{
    for(Game* game in [gameCollection.gameDictionary allValues])
    {
        // check if game already exists
        if (nil == [gameViewDict objectForKey:game.id])
        {
            // create game view
            GameView* gameView = [[gameViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];

            gameView.game = game;
            [gameView refresh];
            
            [self.gameScrollView addSubview:gameView];
        }
        else
        {
            // update existing view
        }
    }
}

#pragma mark - GameCollectionDelegate protocol methods

- (void) newDataAdded
{
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         [self refreshGames];
     }];
}

- (void) dataChanged
{
    
}

#pragma mark - FBFriendsRequestDelegate protocol methods

- (void) FBFriendsRequestFinished:(NSArray *)players
{
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         // start the facebook friends view
         FBFriendsView* friendsView = [[fbFriendsViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
         
         [friendsView configureForPlayers:players WithDelegate:self];
         
         [self.view addSubview:friendsView];
     }];
}

- (void) FBFriendsRequestError
{
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         [[[UIAlertView alloc] initWithTitle:@"Failure" message:@"Failed to get your facebook friends" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }];
}

#pragma mark - FBFriendsViewDelegate protocol methods

- (void) FBFriendSelected:(Player *)player
{
    [[QueuedOperationManager sharedInstance] requestGameForOpponent:player CustomData:nil RequestDelegate:self];
}

- (void) FBFriendSelectCanacelled
{
    
}

#pragma mark - CreateGameRequestDelegate protocol methods

- (void)createGameRequestFinished:(Game*)game
{
    int a = 1;
}

- (void)createGameRequestError
{
    
}

@end

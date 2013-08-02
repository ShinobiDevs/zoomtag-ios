//
//  Game.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/29/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "GameView.h"

typedef enum
{
    kProfilePicture
} urlRequestID;

@implementation GameView

@synthesize game;

- (void) awakeFromNib
{

}

- (void) refresh
{
    // need logic to identify which player is not this user
    Player* opponent = self.game.player1;
    
    self.nameLabel.text = opponent.name;
    
    [[QueuedOperationManager sharedInstance] requestDataForUrlString:opponent.profilePictureUrlString CustomData:[NSNumber numberWithInt:kProfilePicture] Delegate:self];
    
    // hide play button if it's not your turn and display "waiting" label
    if (self.game.current_turn != [opponent.id intValue])
    {
        self.playButton.hidden = YES;
        // diplay waiting label
    }
}

#pragma mark - QueuedOperationManagerDelegate

- (void)dataFinishedLoading:(NSData*)urlData CustomData:(id)customData
{
    if (![customData isKindOfClass:[NSNumber class]])
    {
        return;
    }
    
    UIImage* urlImage = [UIImage imageWithData:urlData];
    
    // perform the data set on the main thread
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         switch ([(NSNumber*)customData longValue])
         {
             case kProfilePicture:
                 self.picImageView.image = urlImage;
                 break;
                 
             default:
                 // MIKI - throw exception
                 break;
         }
     }];
}
@end

//
//  GameView.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/29/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "QueuedOperationManager.h"

@interface GameView : UIView <QueuedOperationManagerDelegate>
{
    
}

@property (nonatomic, weak) Game* game;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void) refresh;
@end

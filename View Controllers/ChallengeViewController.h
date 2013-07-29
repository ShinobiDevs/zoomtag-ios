//
//  ChallengeViewController.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/22/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeGuessView.h"
#import "QueuedOperationManager.h"

@class Challenge;

typedef enum
{
    ChallengeModeNotStarted,
    ChallengeModeInProgress,
    ChallengeModeEnded,
} ChallengeModes;

@interface ChallengeViewController : UIViewController <ChallengeGuessViewDelegate, QueuedOperationManagerDelegate>
{
    ChallengeModes challengeMode;
    
    NSTimer* challengeTimer;
    
    int secondsLeft;
    float zoomOutScale;
    float zoomInScale;
    int zoomOutInterval;
    
    UINib* ChallengeGuessViewNib;
}

@property (weak, nonatomic) IBOutlet UILabel *challengerLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *challengeScrollViewWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *challengeImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameCountDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIView *GuessViewWrapper;

- (IBAction)startNowButtonPressed:(id)sender;

@property (nonatomic, strong) Challenge* challenge;

 - (void) refreshWithChallenge:(Challenge*)i_challenge;

@end

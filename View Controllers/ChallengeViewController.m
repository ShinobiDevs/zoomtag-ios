//
//  ChallengeViewController.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/22/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "ChallengeViewController.h"
#import "Challenge.h"

typedef enum
{
    kMainImage
} urlRequestID;

@interface ChallengeViewController ()

@end

@implementation ChallengeViewController
@synthesize challengerLabel;
@synthesize challengeScrollViewWrapper;
@synthesize challengeImageView;
@synthesize gameCountDownLabel;
@synthesize challenge;
@synthesize startGameButton;
@synthesize gameTimerLabel;
@synthesize GuessViewWrapper;

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        zoomInScale = 25.0f;
        zoomOutInterval = 2;
        
        ChallengeGuessViewNib = [UINib nibWithNibName:@"ChallengeGuessView" bundle:[NSBundle mainBundle]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (void) refreshWithChallenge:(Challenge*)i_challenge
{
    self.challenge = i_challenge;
    
    [[QueuedOperationManager sharedInstance] requestDataForUrlString:self.challenge.imageUrlString CustomData:[NSNumber numberWithInt:kMainImage] Delegate:self];
}

- (IBAction)startNowButtonPressed:(id)sender
{
    [self startGame];
}

#pragma mark - ChallengeGuessViewDelegate

- (void) guessSuccessful
{
    
}

- (void) guessUnsuccessful
{
    
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
             case kMainImage:
                 self.challengeImageView.image = urlImage;
                 [self.challengeImageView fitToParent];
                 
                 // Zoom image to desired start location
                 [self.challengeImageView zoomByScale:zoomInScale animated:FALSE];
                 
                 challengeMode = ChallengeModeNotStarted;
                 
                 [self resetCountdownWithSeconds:10];
                 challengeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(startChallengeTimerTick) userInfo:nil repeats: YES];
                 break;
                 
             default:
                 // MIKI - throw exception
                 break;
         }
     }];
}

#pragma mark - Private methods

- (void) resetCountdownWithSeconds:(int)seconds
{
    secondsLeft = seconds;
    [self updateCountdown];
}

- (void) updateCountdown
{
    int hours, minutes, seconds;
    
    hours = secondsLeft / 3600;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft % 3600) % 60;
    gameCountDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

-(void) startChallengeTimerTick
{    
    secondsLeft--;
   [self updateCountdown];
    
    if (0 == secondsLeft)
    {
        [self startGame];
    }
}

- (void) progressTimerTick
{
    secondsLeft--;
    [self updateCountdown];
    
    if (0 == (secondsLeft % zoomOutInterval))
    {
        [self.challengeImageView zoomByScale:zoomOutScale animated:YES];
    }
    
    if (0 == secondsLeft)
    {
        [self endGame];
    }
}

- (void) startGame
{
    gameTimerLabel.text = @"Time remaining to guess:";
    startGameButton.hidden = YES;
    [self resetCountdownWithSeconds:30];
    zoomOutScale = pow(1/zoomInScale, 1.0 / (secondsLeft / zoomOutInterval));
    
    challengeMode = ChallengeModeInProgress;
    
    [challengeTimer invalidate];
    challengeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(progressTimerTick) userInfo:nil repeats: YES];
    
    // load the guessing view
    ChallengeGuessView* challengeGuessView = [[ChallengeGuessViewNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    [challengeGuessView configureWithDelegate:self];
    challengeGuessView.answer = self.challenge.hardTag;
    //challengeGuessView.hint = self.challenge.hint;
    [GuessViewWrapper addSubview:challengeGuessView];
    GuessViewWrapper.hidden = NO;
    
}

- (void) endGame
{
    challengeMode = ChallengeModeEnded;
    [challengeTimer invalidate];
    challengeTimer = nil;
}
@end

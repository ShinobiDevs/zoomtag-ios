//
//  ChallengeGuessView.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/23/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChallengeGuessViewDelegate <NSObject>
@required
- (void) guessSuccessful;
- (void) guessUnsuccessful;
@end

typedef id<ChallengeGuessViewDelegate> ID_CONFIRMS_CHALLENGE_GUESS_VIEW_DELGATE;

@interface ChallengeGuessView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UINib* GuessLetterViewNib;
    NSString* scrambledAnswer;
    NSString* trimmedAnswer;
    NSString* guess;
    NSInteger nextAnswerLetterIndex;
    
    UIColor* _answerCellEmptyBackgroundColor;
    
    ID_CONFIRMS_CHALLENGE_GUESS_VIEW_DELGATE delegate;
}

@property (weak, nonatomic) IBOutlet UICollectionView *guessOptionsCollectionView;

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *hint;

- (void) configureWithDelegate:(ID_CONFIRMS_CHALLENGE_GUESS_VIEW_DELGATE)iDelegate;
@end

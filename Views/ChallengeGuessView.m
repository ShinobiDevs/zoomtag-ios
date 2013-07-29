//
//  ChallengeGuessView.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/23/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "ChallengeGuessView.h"
#import "GuessLetterViewCell.h"

@implementation ChallengeGuessView

@synthesize answer = _answer;
@synthesize hint;

- (void) configureWithDelegate:(ID_CONFIRMS_CHALLENGE_GUESS_VIEW_DELGATE)iDelegate
{
    delegate = iDelegate;
}

- (void) awakeFromNib
{
    GuessLetterViewNib = [UINib nibWithNibName:@"GuessLetterViewCell" bundle:[NSBundle mainBundle]];
    
   [self.guessOptionsCollectionView registerNib:GuessLetterViewNib forCellWithReuseIdentifier:[GuessLetterViewCell identifier]];
    
    _answerCellEmptyBackgroundColor = [UIColor greenColor];
    
    nextAnswerLetterIndex = 0;
    guess = @"";
}

- (void) setAnswer:(NSString *)i_answer
{
    _answer = i_answer;
    trimmedAnswer = [[i_answer stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    scrambledAnswer = [trimmedAnswer shuffle];
}

- (GuessLetterViewCell*) nextAnswerCell
{
    return (GuessLetterViewCell*)[self.guessOptionsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:nextAnswerLetterIndex inSection:1]];
}

- (void) evaluateAnswer
{
  if ([guess isEqualToString:trimmedAnswer])
  {
      [delegate guessSuccessful];
  }
  else
  {
      guess = @"";
      nextAnswerLetterIndex = 0;
      [self.guessOptionsCollectionView reloadData];
      
      [delegate guessUnsuccessful];
  }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return scrambledAnswer.length;
    }
    else
    {
        return self.answer.length;
    }

}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuessLetterViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:[GuessLetterViewCell identifier] forIndexPath:indexPath];
    
    if (0 == indexPath.section)
    {
        cell.LetterLabel.text = [scrambledAnswer substringWithRange:NSMakeRange(indexPath.row, 1)];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.LetterLabel.text = @"";
        if ([@" " isEqual:[self.answer substringWithRange:NSMakeRange(indexPath.row, 1)]])
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        else
        {
            cell.backgroundColor = _answerCellEmptyBackgroundColor;
        }
    }
    
    return cell;
}

/*
 - (UICollectionReusableView *)collectionView:
(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
return [[UICollectionReusableView alloc] init];
}*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuessLetterViewCell* cellSelected = (GuessLetterViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    GuessLetterViewCell* cellAnswer = [self nextAnswerCell];
    
    // skip empty cells
    if (cellAnswer.backgroundColor == [UIColor clearColor])
    {
        nextAnswerLetterIndex++;
        cellAnswer = [self nextAnswerCell];
    }
    
    cellAnswer.LetterLabel.text = cellSelected.LetterLabel.text;
    cellSelected.hidden = YES;
    
    nextAnswerLetterIndex++;
    
    guess = [guess stringByAppendingString:cellAnswer.LetterLabel.text];
    
    if (trimmedAnswer.length == guess.length)
    {
        [self evaluateAnswer];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
@end

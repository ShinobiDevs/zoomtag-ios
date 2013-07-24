//
//  GuessLetterViewCell.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/23/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessLetterViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *LetterLabel;

+ (NSString*) identifier;
@end

//
//  HeaderWithTextFieldTableViewCell.m
//  ShinobiDevs
//
//  Created by Miki Bergin on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeaderWithTextFieldTableViewCell.h"

@implementation HeaderWithTextFieldTableViewCell

@synthesize headerLabel;
@synthesize textField;

static UINib* _headerWithTextCellNib;

+ (void) initialize
{
    _headerWithTextCellNib = [UINib nibWithNibName:@"HeaderWithTextFieldTableViewCell" bundle:[NSBundle mainBundle]];
}

+ (HeaderWithTextFieldTableViewCell*) createCell
{
    return [[_headerWithTextCellNib instantiateWithOwner:self options:nil] objectAtIndex:0];;
}

+ (NSString*) identifier
{
    return @"HeaderWithTextFieldTableViewCell";
}

- (void) awakeFromNib
{
    self.indentationWidth = 0;
}
@end

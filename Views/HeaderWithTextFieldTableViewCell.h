//
//  HeaderWithTextFieldTableViewCell.h
//  ShinobiDevs
//
//  Created by Miki Bergin on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderWithTextFieldTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;

+ (HeaderWithTextFieldTableViewCell*) createCell;
+ (NSString*) identifier;
@end
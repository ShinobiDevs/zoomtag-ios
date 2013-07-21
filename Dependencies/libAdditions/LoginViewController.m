//
//  LoginViewController.m
//  picloc
//
//  Created by Miki Bergin on 5/20/13.
//  Copyright (c) 2013 Miki Bergin. All rights reserved.
//

#import "LoginViewController.h"
#import "HeaderWithTextFieldTableViewCell.h"

#define LOGIN_INPUT_FIELD_HEADER_KEY @"HeaderKey"
#define LOGIN_INPUT_FIELD_TEXT_PLACEHOLDER_KEY @"TextPlaceholderKey"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userDetailsTableView;

typedef enum
{
    LoginInputFieldUsername,
    LoginInputFieldPassword,
} LoginInputField;

- (IBAction)signinPressed:(id)sender
{
    
}

#pragma mark - UIViewController overrides & callbacks
- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        NSMutableArray* initOptions = [NSMutableArray new];
        
        NSDictionary* optionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Username", LOGIN_INPUT_FIELD_HEADER_KEY,
                                          @"required", LOGIN_INPUT_FIELD_TEXT_PLACEHOLDER_KEY, nil];
        [initOptions insertObject:optionDictionary atIndex:LoginInputFieldUsername];
        
        optionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Password", LOGIN_INPUT_FIELD_HEADER_KEY,
                            @"required", LOGIN_INPUT_FIELD_TEXT_PLACEHOLDER_KEY, nil];
        [initOptions insertObject:optionDictionary atIndex:LoginInputFieldPassword];
        inputFieldsDataArray = initOptions;
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

- (void)viewDidUnload {
    [self setUserDetailsTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Only one section, so return the number of items in the list.
    return [inputFieldsDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue or create a cell of the appropriate type.
	HeaderWithTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HeaderWithTextFieldTableViewCell identifier]];
    
    if (cell == nil)
    {
        cell = [HeaderWithTextFieldTableViewCell createCell];
    }
    
    NSDictionary* fieldDataDict = [inputFieldsDataArray objectAtIndex:indexPath.row];
    cell.headerLabel.text = [fieldDataDict objectForKey:LOGIN_INPUT_FIELD_HEADER_KEY];
    cell.textField.placeholder = [fieldDataDict objectForKey:LOGIN_INPUT_FIELD_TEXT_PLACEHOLDER_KEY];
    //cell.textField.delegate = self;
    cell.textField.returnKeyType = (indexPath.row == 0) ? UIReturnKeyNext : UIReturnKeyGo;
    cell.textField.tag = indexPath.row;
    cell.textField.secureTextEntry = (1 == indexPath.row);
    
    return cell;
}

@end

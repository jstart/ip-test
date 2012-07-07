//
//  IPCreatePageViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPCreatePageViewController.h"
#import <Parse/Parse.h>

@interface IPCreatePageViewController ()

@end

@implementation IPCreatePageViewController
@synthesize pageNameField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * closeButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeView)];
    [closeButtonItem setTitle:@"Close"];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
}

- (void)viewDidUnload
{
    [self setPageNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)closeView{
  [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(id)sender {
  if (self.pageNameField.text.length <= 0) {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Title" message:@"You must add a title to your page." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertView show];
    return;
  }
  [self.pageNameField resignFirstResponder];
  PFObject * newObject = [PFObject objectWithClassName:@"Page"];
  [newObject setObject:[self.pageNameField text] forKey:@"Title"];
  [newObject save];
  PFRelation * pageRelation = [newObject relationforKey:@"Owner"];
  [pageRelation addObject:[PFUser currentUser]];
  PFRelation * ownerRelation = [[PFUser currentUser] relationforKey:@"Pages"];
  [ownerRelation addObject:newObject];
  [newObject saveInBackground];
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

@end

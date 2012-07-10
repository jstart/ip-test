//
//  IPCreatePageViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPCreatePageViewController.h"
#import "IPInviteFriendToPageViewController.h"
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
        self.title = @"Create Page";
        self.root = [[QRootElement alloc] initWithJSONFile:@"ip_form"];
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
    
    UIBarButtonItem * submitButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createPage:)];
    [closeButtonItem setTitle:@"Submit"];
    self.navigationItem.rightBarButtonItem = submitButtonItem;
    
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

- (void)createPage:(QElement *)button {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:dict];
    
//    NSString *msg = @"Values:";
//    for (NSString *aKey in dict){
//        msg = [msg stringByAppendingFormat:@"\n- %@: %@", aKey, [dict valueForKey:aKey]];
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello"
//                                                    message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];

    NSNumber * pickerIndex = [((NSArray*)[dict objectForKey:@"listType"]) objectAtIndex:0];
//  PFObject * newObject = [PFObject objectWithClassName:@"Page"];
//  [newObject setObject:[dict objectForKey:@"pageName"] forKey:@"Title"];
//  [newObject setObject:pickerIndex forKey:@"listType"];
//  [newObject save];
//  PFRelation * pageRelation = [newObject relationforKey:@"Owner"];
//  [pageRelation addObject:[PFUser currentUser]];
//  PFRelation * ownerRelation = [[PFUser currentUser] relationforKey:@"Pages"];
//  [ownerRelation addObject:newObject];
//  [newObject saveInBackground];
    
    switch ([pickerIndex intValue]) {
        case 0:
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
            break;
        case 1:
                {
                    IPInviteFriendToPageViewController * inviteVC = [[IPInviteFriendToPageViewController alloc] initWithNibName:@"IPInviteFriendToPageViewController" bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:inviteVC animated:YES];
                }
            break;
        case 2:
            [self.presentingViewController dismissModalViewControllerAnimated:YES];

            break;
            
        default:
            [self.presentingViewController dismissModalViewControllerAnimated:YES];

            break;
    }
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

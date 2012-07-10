//
//  PAWViewController.m
//  AnyWall
//
//  Created by Christopher Bowns on 1/30/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "IPWelcomeViewController.h"

#import "IPViewController.h"
#import "IPLoginViewController.h"
#import "IPNewUserViewController.h"

@implementation IPWelcomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Transition methods

- (IBAction)loginButtonSelected:(id)sender {
	IPLoginViewController *loginViewController = [[IPLoginViewController alloc] initWithNibName:@"IPLoginViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController presentModalViewController:loginViewController animated:YES];
}

- (IBAction)createButtonSelected:(id)sender {
	IPNewUserViewController *newUserViewController = [[IPNewUserViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController presentViewController:newUserViewController animated:YES completion:^{}];
}

- (IBAction)gotoParse:(id)sender {
	UIApplication *ourApplication = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:@"https://www.parse.com/"];
    [ourApplication openURL:url];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Welcome to InsiderPages";

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  IPCreatePageViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCreatePageViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *pageNameField;
- (IBAction)submitButtonPressed:(id)sender;

@end

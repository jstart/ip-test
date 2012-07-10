//
//  IPCreatePageViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface IPCreatePageViewController : QuickDialogController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *pageNameField;

- (void)createPage:(QElement *)button;
@end

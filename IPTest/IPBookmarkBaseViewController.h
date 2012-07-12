//
//  IPBookmarkBaseViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPBookmarkViewController.h"
#import "IPBookmarkContainerViewController.h"

@interface IPBookmarkBaseViewController : UIViewController <IPBookmarkViewDelegate>

@property (strong, nonatomic) UINavigationController* bookmarkNavigationController;

-(void)hideBookmark;
-(void)showBookmark;
-(void)presentWelcomeViewController;
-(void)presentBookmarkViewController;

@end

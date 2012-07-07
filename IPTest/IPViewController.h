//
//  IPViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FireUIPagedScrollView.h"
#import "IPBookmarkViewController.h"

@interface IPViewController : UIViewController <FireUIPagedScrollViewDelegate, IPBookmarkViewDelegate>
@property (strong, nonatomic) IBOutlet FireUIPagedScrollView *scrollView;
//@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UINavigationController* bookmarkNavigationController;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(void)presentWelcomeViewController;
-(void)presentBookmarkViewController;
-(void)hideBookmark;
-(void)showBookmark;

@end

//
//  IPBookmarkContainerViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPBookmarkViewDelegate <NSObject>

-(void)bookmarkViewWasDismissed:(int)homePageIndex;

@end

@interface IPBookmarkContainerViewController : UIViewController

@property (strong, nonatomic) id <IPBookmarkViewDelegate> delegate;

@end

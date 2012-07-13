//
//  IPSegmentContainerViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FireUIPagedScrollView.h"
#import "IPListViewController.h"
#import "IPGridViewController.h"
#import "IPBookmarkBaseViewController.h"
#import "IPAveragePageRankOperation.h"

@interface IPSegmentContainerViewController : IPBookmarkBaseViewController <IPGridViewDelegate, IPListViewDelegate, IPAveragePageRankDelegate>{
  NSMutableArray * _objects;
}
@property (strong, nonatomic) IBOutlet FireUIPagedScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IPListViewController * listVC;
@property (strong, nonatomic) IPGridViewController * gridVC;
@property (strong, nonatomic) PFObject * pageObject;
@property (strong, nonatomic) NSMutableArray * objects;

-(void)customBackActionNoAnimation:(int)homePageIndex;
-(void)sortObjects:(NSArray *)objects;
-(void)reloadItems;

@end

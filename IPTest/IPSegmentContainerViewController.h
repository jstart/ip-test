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

@interface IPSegmentContainerViewController : UIViewController <IPGridViewDelegate, IPListViewDelegate>{
  NSMutableArray * _objects;
}
@property (strong, nonatomic) IBOutlet FireUIPagedScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IPListViewController * listVC;
@property (strong, nonatomic) IPGridViewController * gridVC;
@property (strong, nonatomic) PFObject * pageObject;
@property (strong, nonatomic) NSMutableArray * objects;

@end

//
//  IPTestView.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPTestView : UIView
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign) BOOL hasBeenAdjusted;

@end

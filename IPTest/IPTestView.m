//
//  IPTestView.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPTestView.h"

@implementation IPTestView

@synthesize tableView;
@synthesize hasBeenAdjusted;
//HAX
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.hasBeenAdjusted = NO;
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
  if (self.hasBeenAdjusted) {
    [super setFrame:CGRectMake(0, 0, 320, 480)];
    [super setNeedsLayout];
    [super setNeedsDisplayInRect:CGRectMake(0, 0, 320, 480)];
    [self.tableView setFrame:CGRectMake(0, 0, 320, 308)];
  }else{
    [super setFrame:CGRectMake(0, 20, 320, 460)];
    [super setNeedsLayout];
    [super setNeedsDisplayInRect:CGRectMake(0, 0, 320, 480)];
    [self.tableView setFrame:CGRectMake(0, 0, 320, 308)];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

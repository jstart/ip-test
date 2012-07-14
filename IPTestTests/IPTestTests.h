//
//  IPTestTests.h
//  IPTestTests
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "IPParseObjectManager.h"

@interface IPTestTests : SenTestCase <IPPageManagerDelegate>

@property (nonatomic, strong) IPPageManager * pageManager;

@end

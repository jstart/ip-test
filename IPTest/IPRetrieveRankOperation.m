//
//  IPRetrieveRankOperation.m
//  IPTest
//
//  Created by Truman, Christopher on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPRetrieveRankOperation.h"

@implementation IPRetrieveRankOperation

@synthesize delegate, itemsArray = _itemsArray, rankingDictionary = _rankingDictionary, isFinished;

-(id)initWithItems:(NSArray*)itemsArray{
    self = [super init];
    if (self) {
        _itemsArray = itemsArray;
        _rankingDictionary = [[NSMutableDictionary alloc] init];
        self.isFinished = NO;
    }
    return self;
}

-(void)start{
    for (PFObject * itemObject in _itemsArray) {
        PFQuery * query = [PFQuery queryWithClassName:@"Ranking"];
        [query whereKey:@"Parent_Item" equalTo:itemObject];
        NSArray * objects = [query findObjects];
            if ([objects count]>=1) {
                [self.rankingDictionary setObject:[objects objectAtIndex:0] forKey:itemObject.objectId];
            }
    }
    [self.delegate retrievedRanks:self.rankingDictionary];
    isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

-(BOOL)isFinished{
    return isFinished;
}

@end

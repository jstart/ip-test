//
//  IPRetrieveRankOperation.m
//  IPTest
//
//  Created by Truman, Christopher on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPRetrieveRankOperation.h"

@implementation IPRetrieveRankOperation

@synthesize delegate, itemsArray = _itemsArray, rankingDictionary = _rankingDictionary, pageObject = _pageObject;

-(id)initWithItems:(NSArray*)itemsArray pageObject:(PFObject*)pageObject{
    self = [super init];
    if (self) {
        _itemsArray = [itemsArray copy];
        _rankingDictionary = [[NSMutableDictionary alloc] init];
        _pageObject = pageObject;
    }
    return self;
}

-(void)start{
    for (PFObject * itemObject in self.itemsArray) {        
        PFQuery * query = [PFQuery queryWithClassName:@"Ranking"];
        [query whereKey:@"Parent_Item" equalTo:itemObject];
        [query whereKey:@"Parent_Page" equalTo:self.pageObject];
        PFQuery * innerQuery = [PFUser query];
        [innerQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
        [query whereKey:@"Parent_User" matchesQuery:innerQuery];
        [query setCachePolicy:kPFCachePolicyNetworkElseCache];
        PFObject * object = [query getFirstObject];
            if (object) {
//                PFRelation * parentUserRelation = [object objectForKey:@"Parent_User"];
//                PFObject * parentUser = [[parentUserRelation query] getFirstObject];
//                NSLog(@"user who owns rank: %@", parentUser);
                [self.rankingDictionary setObject:object forKey:itemObject.objectId];
            }
    }
    [self.delegate retrievedRanks:self.rankingDictionary];
    [self didChangeValueForKey:@"isFinished"];
}

-(BOOL)isFinished{
    return YES;
}

@end

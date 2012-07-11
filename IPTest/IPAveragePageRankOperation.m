//
//  IPRetrieveRankOperation.m
//  IPTest
//
//  Created by Truman, Christopher on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPAveragePageRankOperation.h"

@implementation IPAveragePageRankOperation

@synthesize delegate, pageObject = _pageObject, itemsDictionary = _itemsDictionary, itemsAverageRankingDictionary = _itemsAverageRankingDictionary;

-(id)initWithPage:(PFObject *)pageObject{
    self = [super init];
    if (self) {
        _pageObject = pageObject;
        _itemsDictionary = [[NSMutableDictionary alloc] init];
        _itemsAverageRankingDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)start{
    PFQuery * query = [PFQuery queryWithClassName:@"Ranking"];
    [query whereKey:@"Parent_Page" equalTo:self.pageObject];
    NSArray * objects = [query findObjects];
    NSMutableDictionary * itemIDDictionary = [NSMutableDictionary dictionary];
    for (PFObject * object in objects) {
        PFObject * parentItem = [[((PFRelation*)[object objectForKey:@"Parent_Item"]) query] getFirstObject];
        [itemIDDictionary setObject:parentItem forKey:parentItem.objectId];
        NSMutableArray * array = [self.itemsDictionary objectForKey:parentItem.objectId];
        if (array == nil){
            array = [[NSMutableArray alloc] init];
        }
        [array addObject:object];
        [self.itemsDictionary setObject:array forKey:parentItem.objectId];
    }
    for (NSString * key in [self.itemsDictionary allKeys]) {
        NSArray * rankings = [self.itemsDictionary objectForKey:key];
        int average = 0;
        for (PFObject* rank in rankings) {
            NSNumber * position = [rank objectForKey:@"position"];
            average += [position intValue];
            
        }
//        NSLog(@"Key: %@ total %d average: %d/%d = %d",key, average, average, [rankings count], average/[rankings    count]);
        [self.itemsAverageRankingDictionary setObject:[NSNumber numberWithInt:average] forKey:key];
                PFQuery * query = [PFQuery queryWithClassName:@"GlobalRanking"];
        [query whereKey:@"Parent_Page" equalTo:self.pageObject];
        [query whereKey:@"Parent_Item" equalTo:[itemIDDictionary objectForKey:key]];
        PFObject* globalRankingObject = [query getFirstObject];
        
        if (globalRankingObject == nil) {
            PFObject * newGlobalRanking = [PFObject objectWithClassName:@"GlobalRanking"];
            [newGlobalRanking setValue:[NSNumber numberWithInt:average] forKey:@"position"];
            PFRelation * item_relation = [newGlobalRanking relationforKey:@"Parent_Item"];
            [item_relation addObject:[itemIDDictionary objectForKey:key]];
            PFRelation * page_relation = [newGlobalRanking relationforKey:@"Parent_Page"];
            [page_relation addObject:self.pageObject];
            [newGlobalRanking saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                if (succeeded) {
                    NSLog(@"Created new global ranking object");
                }else{
                    NSLog(@"%@", error);
                }
            }];
        }
        else{
            [globalRankingObject setValue:[NSNumber numberWithInt:average] forKey:@"position"];
            [globalRankingObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
                if (succeeded) {
                    NSLog(@"Updating global ranking object");
                }else{
                    NSLog(@"%@", error);
                }
            }];
        }
    }
    
    [self.delegate didGenerateAverageRanking:(NSMutableDictionary*)self.itemsAverageRankingDictionary];
    [self didChangeValueForKey:@"isFinished"];
}

-(BOOL)isFinished{
    return YES;
}

@end

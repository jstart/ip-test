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
    
    NSArray * objects = [self.pageObject objectForKey:@"Rankings"];
    NSMutableDictionary * itemIDDictionary = [NSMutableDictionary dictionary];
    for (PFObject * object in objects) {
        [object fetchIfNeeded];
        PFObject * parentItem = ((PFObject*)[object objectForKey:@"Parent_Item"]);
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
        NSLog(@"Key: %@ total %d average: %d/%d = %d",key, average, average, [rankings count], average/[rankings count]);
        [self.itemsAverageRankingDictionary setObject:[NSNumber numberWithInt:average] forKey:key];
        PFObject* globalRankingObject = nil;
        for (PFObject * globalRankingObjectIterated in [self.pageObject objectForKey:@"Global_Rankings"]) {
            [globalRankingObjectIterated fetchIfNeeded];
            if ([((PFObject*)[globalRankingObjectIterated objectForKey:@"Parent_Item"]).objectId isEqualToString:key]) {
                globalRankingObject = globalRankingObjectIterated;
            }
        }
        
        if (globalRankingObject == nil) {
            PFObject * newGlobalRanking = [PFObject objectWithClassName:@"GlobalRanking"];
            [newGlobalRanking setObject:[itemIDDictionary objectForKey:key] forKey:@"Parent_Item"];
            [newGlobalRanking setObject:self.pageObject forKey:@"Parent_Page"];
            [newGlobalRanking setValue:[NSNumber numberWithInt:average] forKey:@"position"];
            [newGlobalRanking save];
            [self.pageObject addObject:newGlobalRanking forKey:@"Global_Rankings"];
            [self.pageObject save];
        }
        else{
            [globalRankingObject setValue:[NSNumber numberWithInt:average] forKey:@"position"];
            [globalRankingObject save];
        }
    }
    
    [self.delegate didGenerateAverageRanking:(NSMutableDictionary*)self.itemsAverageRankingDictionary];
    [self didChangeValueForKey:@"isFinished"];
}

-(BOOL)isFinished{
    return YES;
}

@end

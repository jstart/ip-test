//
//  IPRetrieveRankOperation.h
//  IPTest
//
//  Created by Truman, Christopher on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPRetrieveRankDelegate <NSObject>

-(void)retrievedRanks:(NSMutableDictionary *)ranks;

@end

@interface IPRetrieveRankOperation : NSOperation

@property (nonatomic, strong) id<IPRetrieveRankDelegate> delegate;
@property (nonatomic, strong) NSArray * itemsArray;
@property (nonatomic, strong) NSMutableDictionary * rankingDictionary;
@property (nonatomic, strong) PFObject * pageObject;

-(id)initWithItems:(NSArray*)itemsArray pageObject:(PFObject*)pageObject;

@end

//
//  IPAveragePageRankOperation.h
//  IPTest
//
//  Created by Truman, Christopher on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPAveragePageRankDelegate <NSObject>

-(void)didGenerateAverageRanking:(NSMutableDictionary*)averageRankingDictionary;

@end

@interface IPAveragePageRankOperation : NSOperation

@property (nonatomic, strong) id<IPAveragePageRankDelegate> delegate;
@property (nonatomic, strong) PFObject * pageObject;
@property (nonatomic, strong) NSMutableDictionary * itemsDictionary;
@property (nonatomic, strong) NSMutableDictionary * itemsAverageRankingDictionary;

-(id)initWithPage:(PFObject*)pageObject;

@end

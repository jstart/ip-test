//
//  IPParseObjectManager.h
//  IPTest
//
//  Created by Truman, Christopher on 7/14/12.
//
//

#import <Foundation/Foundation.h>

#import "IPPageManager.h"
@interface IPParseObjectManager : NSObject

@property (nonatomic, strong) NSMutableDictionary * pageManagerDictionary;

+(IPParseObjectManager *)sharedInstance;
-(IPPageManager*)pageManagerForObject:(PFObject*)pageObject;

@end

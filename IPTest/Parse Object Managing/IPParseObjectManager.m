//
//  IPParseObjectManager.m
//  IPTest
//
//  Created by Truman, Christopher on 7/14/12.
//
//

#import "IPParseObjectManager.h"

@implementation IPParseObjectManager

@synthesize pageManagerDictionary = _pageManagerDictionary;

+(IPParseObjectManager *)sharedInstance {
    static dispatch_once_t pred;
    static IPParseObjectManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[IPParseObjectManager alloc] init];
    });
    return shared;
}

-(id)init{
    if (self = [super init]) {
        self.pageManagerDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(IPPageManager*)pageManagerForObject:(PFObject*)pageObject{
    IPPageManager * pageManager = nil;
    if ([self.pageManagerDictionary objectForKey:pageObject.objectId]) {
        pageManager =  [self.pageManagerDictionary objectForKey:pageObject.objectId];
    }else{
        pageManager = [IPPageManager pageManagerForPageObject:pageObject];
        [self.pageManagerDictionary setObject:pageManager forKey:pageObject.objectId];
    }
    return pageManager;
}

@end

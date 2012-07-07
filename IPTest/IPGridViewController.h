//
//  IPGridViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol IPGridViewDelegate <NSObject>

-(void)didSelectRowAtIndex:(NSInteger)index;

@end

@interface IPGridViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) NSMutableArray * objects;
@property (strong, nonatomic) id <IPGridViewDelegate> delegate;

-(void)updatedResultObjects:(NSMutableArray*)newObjects;

@end

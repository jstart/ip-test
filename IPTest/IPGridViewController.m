//
//  IPGridViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPGridViewController.h"

@interface IPGridViewController ()

@end

@implementation IPGridViewController
@synthesize carousel, objects, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.objects = [[NSMutableArray alloc] init];
    carousel.type = iCarouselTypeTimeMachine;
    carousel.bounces = NO;
    [carousel setVertical:YES];
    [carousel setIgnorePerpendicularSwipes:YES];
}

- (void)viewDidUnload
{
    [self setCarousel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updatedResultObjects:(NSMutableArray*)newObjects{
  self.objects = newObjects;
  [self.carousel reloadData];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
  //return the total number of items in the carousel
  return [self.objects count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImageView *mainImageView = nil;
    UILabel *nameLabel = nil;
    UIImageView *rankImageView = nil;
    UIButton *phoneNumberButton = nil;
    UILabel *addressLabel = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        NSArray * viewArray = [[NSBundle mainBundle] loadNibNamed:@"IPGridViewTemplate" owner:self options:nil];

        view = [viewArray objectAtIndex:0];
    }

    //get a reference to the label in the recycled view
    mainImageView = (UIImageView *)[view viewWithTag:1];
    nameLabel = (UILabel *)[view viewWithTag:2];
    rankImageView = (UIImageView *)[view viewWithTag:3];
    phoneNumberButton = (UIButton *)[view viewWithTag:4];
    addressLabel = (UILabel *)[view viewWithTag:5];

    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    nameLabel.text = [[self.objects objectAtIndex:index] objectForKey:@"Title"];

    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (delegate != nil) {
        [self.delegate didSelectRowAtIndex:index];
    }else{
        NSLog(@"No Delegate for List View");
    }
}

@end

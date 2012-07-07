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
@synthesize carousel, objects;

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
    carousel.type = iCarouselTypeCoverFlow2;
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
  UILabel *label = nil;
  
  //create new view if no view is available for recycling
  if (view == nil)
  {
    //don't do anything specific to the index within
    //this `if (view == nil) {...}` statement because the view will be
    //recycled and used with other index values later
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
    ((UIImageView *)view).image = [UIImage imageNamed:@"bookmark.png"];
    view.contentMode = UIViewContentModeCenter;
    
    label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    label.tag = 1;
    [view addSubview:label];
  }
  else
  {
    //get a reference to the label in the recycled view
    label = (UILabel *)[view viewWithTag:1];
  }
  
  //set item label
  //remember to always set any properties of your carousel item
  //views outside of the `if (view == nil) {...}` check otherwise
  //you'll get weird issues with carousel item content appearing
  //in the wrong place in the carousel
  label.text = [[self.objects objectAtIndex:index] objectForKey:@"Title"];
  view.backgroundColor = [UIColor whiteColor];
  return view;
}


@end

//
//  IPAppDelegate.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPAppDelegate.h"
#import "IPWelcomeViewController.h"
#import "DCIntrospect.h"
#import <CityGrid/CityGrid.h>

@implementation IPAppDelegate

@synthesize window = _window, iv;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"Launch Options: %@", launchOptions);
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif

  [Parse setApplicationId:@"Sw86jP5zMknD2Gp52hXMUH6cLoBq5YpzIR5SYWlW"
                clientKey:@"XaM7srV5NdkbOEWXjXzFvFjXLD7w2YzAimdo0m27"];
  [CityGrid setPublisher:@"test"];
	[CityGrid setPlacement:@"ios-example"];
	[CityGrid setDebug:YES];
    [[PFUser currentUser] refresh];
  // always call after makeKeyAndDisplay.
#if TARGET_IPHONE_SIMULATOR
  [[DCIntrospect sharedIntrospector] start];
#else
    [TestFlight takeOff:@"30d92a896df4ab4b4873886ea58f8b06_NzE0NzIyMDEyLTAzLTE0IDEzOjQ0OjU4Ljk3MDAxOQ"];
#endif

    [self displaySplash];
    [_window makeKeyAndVisible];  

    return YES;
}

-(void)displaySplash{
    iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [self.window addSubview:iv];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self]; 
    [UIView setAnimationDuration:1.0];
    iv.alpha = 0.0;
    [UIView setAnimationDidStopSelector:@selector(removeSplash)];
    [UIView commitAnimations]; 
}

-(void)removeSplash{
    [iv removeFromSuperview];
}

- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    NSError * error = nil;
    [PFPush subscribeToChannel:@"" error:&error];
    if (error) {
        NSLog(@"subscribe error %@", error);
    }
    [[PFUser currentUser] refresh];
    NSString * channelName = [NSString stringWithFormat:@"UserChannel_%@", [PFUser currentUser].objectId];
    error = nil;
    [PFPush subscribeToChannel:channelName error:&error];
    if (error) {
        NSLog(@"subscribe error %@", error);
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {

//    [PFPush handlePush:userInfo];
    if ([[userInfo objectForKey:@"Type"] isEqualToString:@"Invite"]) {
        [PFPush handlePush:userInfo];
        PFObject * object = [PFQuery getObjectOfClass:@"Page"
                                           objectId:[userInfo objectForKey:@"pageObjectId"]];
        [[PFUser currentUser] addObject:object forKey:@"following"];
        [[PFUser currentUser] save];
        PFRelation * followersRelation = [object relationforKey:@"Followers"];
        [followersRelation addObject:[PFUser currentUser]];
        [object save];
    }
    if ([[userInfo objectForKey:@"Type"] isEqualToString:@"Ranking"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RankingPush" object:nil];
    }
    if ([[userInfo objectForKey:@"Type"] isEqualToString:@"AddItem"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RankingPush" object:nil];
    }
    NSMutableArray * notificationsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"IPNotifications"];
    if (notificationsArray !=nil) {
        [notificationsArray addObject:userInfo];
    }else{
        notificationsArray = [[NSMutableArray alloc] init];
    }
    [[NSUserDefaults standardUserDefaults] setObject:notificationsArray forKey:@"IPNotifications"];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

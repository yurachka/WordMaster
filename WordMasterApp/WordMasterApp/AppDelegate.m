//
//  AppDelegate.m
//  WordMasterApp
//
//  Created by Ludwig on 15/12/12.
//  Copyright © 2015年 Ludwig. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        self.wordList = [[NSMutableArray alloc] init];
        self.listByDate = [[NSMutableArray alloc] init];
        
        NSDate *GMTDate = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:GMTDate];
        NSDate *date = [GMTDate dateByAddingTimeInterval:interval];
        NSTimeInterval interv = [date timeIntervalSince1970];
        int daySeconds = 24 * 60 * 60;
        NSInteger allDays = interv / daySeconds;
        self.previousDate = [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
        
        self.reviewList = [[NSMutableArray alloc] init];
    } else {
     //   [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStart"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.wordList = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"CustomWordList"]];
        self.listByDate = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"ListByDate"]];
        self.previousDate = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"PreviousDate"]];
        self.reviewList = [NSKeyedUnarchiver unarchiveObjectWithFile:[path stringByAppendingPathComponent:@"ReviewList"]];
    }
    
    self.dbManager = [[SYXDBManager alloc] init];
    [self.dbManager open];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [NSKeyedArchiver archiveRootObject:self.wordList toFile:[path stringByAppendingPathComponent:@"CustomWordList"]];
    [NSKeyedArchiver archiveRootObject:self.listByDate toFile:[path stringByAppendingPathComponent:@"ListByDate"]];
    [NSKeyedArchiver archiveRootObject:self.previousDate toFile:[path stringByAppendingPathComponent:@"PreviousDate"]];
    [NSKeyedArchiver archiveRootObject:self.reviewList toFile:[path stringByAppendingPathComponent:@"ReviewList"]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [NSKeyedArchiver archiveRootObject:self.wordList toFile:[path stringByAppendingPathComponent:@"CustomWordList"]];
    [NSKeyedArchiver archiveRootObject:self.listByDate toFile:[path stringByAppendingPathComponent:@"ListByDate"]];
    [NSKeyedArchiver archiveRootObject:self.previousDate toFile:[path stringByAppendingPathComponent:@"PreviousDate"]];
    [NSKeyedArchiver archiveRootObject:self.reviewList toFile:[path stringByAppendingPathComponent:@"ReviewList"]];
    [self.dbManager close];
}

@end

//
//  AppDelegate.m
//  Simple
//
//  Created by ehsy on 16/4/22.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "AppDelegate.h"
#import "SIMNavigationController.h"
#import "SIMMainViewController.h"
#import <JPEngine.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [JPEngine startEngine];
    NSString *jsSourcePath = [[NSBundle mainBundle] pathForResource:@"jspatch" ofType:@"js"];
    NSString *jsString = [NSString stringWithContentsOfFile:jsSourcePath encoding:NSUTF8StringEncoding error:nil];
    
    jsString = @"defineClass(\"JSPatchViewController\",{\
                tableView_didSelectRowAtIndexPath: function(tableView,indexPath){\
                    var row = indexPath.row();\
                    if (self.dataSource().length > row){\
                        var ctrl = CGViewController.alloc().init();\
                        self.navigationController().pushViewController(ctrl);\
                    }\
                  }\
               })";
    [JPEngine evaluateScript:jsString];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    SIMNavigationController *nav = [[SIMNavigationController alloc]initWithRootViewController:[[SIMMainViewController alloc]init]];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

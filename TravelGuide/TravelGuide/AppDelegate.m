//
//  AppDelegate.m
//  TravelGuide
//
//  Created by Milena Dimovska on 6/1/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentViewController.h"
#import "MenuViewController.h"
#import "OSBlurSlideMenu.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

    ContentViewController *contentScreen = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContentScreen"];
    ContentViewController *menuScreen = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MenuScreen"];
    OSBlurSlideMenuController *slideController = [[OSBlurSlideMenuController alloc] initWithMenuViewController:menuScreen andContentViewController:contentScreen];
    
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:slideController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     // navigationController.navigationBar.topItem.title = @"Travel guide";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //black status bar
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,800, 20)];
    view.backgroundColor=[UIColor blackColor];
    [navigationController.view addSubview:view];
    
    application.applicationSupportsShakeToEdit = YES;
    // Override point for customization after application launch.
    return YES;
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

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateActive) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:notification.alertBody
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // Request to reload table view data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
@end

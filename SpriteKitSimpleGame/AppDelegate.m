//
//  AppDelegate.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <Chartboost/Chartboost.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <RevMobAds/RevMobAds.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [RageIAPHelper sharedInstance];
    [[GameCenterManager sharedManager] setupManager];

    [Chartboost startWithAppId:ChartboostAppId appSignature:ChartboostAppSignature delegate:self];//charles IDS
    [Chartboost cacheRewardedVideo:CBLocationHomeScreen];
    
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"horror" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    return YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    interstitial_ = [[GADInterstitial alloc]init];
    interstitial_.adUnitID =InterstitialID;
    [interstitial_ loadRequest:[GADRequest request]];
}

-(void)ShowAdmobinterstitial{
    //[interstitial_ presentFromRootViewController:self];
}

-(void)showChartboostVideoInterstitial{
    [Chartboost showRewardedVideo:CBLocationGameOver];
}

-(void)showStaticChartboostInterstitial{
    [Chartboost showInterstitial:CBLocationGameOver];
}




#pragma mark RewardVideo Methods
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    return YES;
}
- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"Video available to show");
}
- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"didDisplayRewardedVideo");
    [self.backgroundMusicPlayer pause];
}
- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"didDismissRewardedVideo");
    [self.backgroundMusicPlayer play];
}
- (void)didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error{
    NSLog(@"didFailToLoadRewardedVideo error = %d",error);
}
#pragma mark Interstitial
- (void)didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Did display interstitial");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
        [self.backgroundMusicPlayer pause];
    }
}
- (BOOL)shouldDisplayInterstitial:(CBLocation)location{
    return YES;
}
- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    [self.backgroundMusicPlayer play];
}
- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
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
    
    
    NSDate *alertTime = [[NSDate date]dateByAddingTimeInterval:20000];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    if (notification) {
        
        notification.fireDate = alertTime;
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.alertBody = @"come back and play Shark Prey";
        notification.alertLaunchImage  = @"icon-60.png";
        
        [app scheduleLocalNotification:notification];
    }

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *Oldnotification = [ app scheduledLocalNotifications];
    
    if (Oldnotification >0) {
        [app cancelAllLocalNotifications];
    }

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

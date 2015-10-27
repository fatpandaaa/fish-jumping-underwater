//
//  ViewController.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "ViewController.h"
#import "mainMenu.h"
#import "SplashPage.h"
#import <Chartboost/Chartboost.h>

@import AVFoundation;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
 

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        
        
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
        bannerView_.adUnitID = AdmobBanner;
        bannerView_.rootViewController = self;
        bannerView_.center = CGPointMake(skView.bounds.size.width / 2, skView.bounds.size.height - (bannerView_.frame.size.height / 2));
        
        //[self.view addSubview:bannerView_];
        //[bannerView_ loadRequest:[GADRequest request]];

        /*
        cb = [Chartboost sharedChartboost];
        cb.appId = ChartboostAppID;
        cb.appSignature = ChartboostAppSignature;
        cb.delegate = self;
        [cb startSession];
        [cb cacheInterstitial];
        [cb cacheMoreApps];
        */
        
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
      
    SKScene * scene = [SplashPage sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
      

    [skView presentScene:scene];
    }
}

-(void)BannerHide{
    
    bannerView_.hidden=YES;
}




- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[RevMobAds startSessionWithAppID:RevmobAppId andDelegate:self];
    
    /*
    [Chartboost startWithAppId:ChartboostAppId appSignature:ChartboostAppSignature delegate:self];
    [Chartboost showInterstitial:CBLocationHomeScreen];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void)didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Did display interstitial");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
    }
}
- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
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

@end

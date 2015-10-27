//
//  AppDelegate.h
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RageIAPHelper.h"
#import "GameCenterManager.h"
#import <SpriteKit/SpriteKit.h>
#import "GADInterstitial.h"
#import "GADBannerView.h"
#import <RevMobAds/RevMobAds.h>
#import <Chartboost/Chartboost.h>

#import "appID.h"

@import AVFoundation;
@interface AppDelegate : UIResponder <UIApplicationDelegate,ChartboostDelegate,GADInterstitialDelegate,GADBannerViewDelegate,RevMobAdsDelegate>{
    GADInterstitial *interstitial_;
    GADBannerView *bannerView_;
    Chartboost *cb;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;


-(void)showStaticChartboostInterstitial;
-(void)showChartboostVideoInterstitial;
-(void)ShowAdmobinterstitial;

@end

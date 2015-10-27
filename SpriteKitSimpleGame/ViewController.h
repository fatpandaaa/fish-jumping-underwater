//
//  ViewController.h
//  SpriteKitSimpleGame
//

//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GADBannerView.h"
#import "appID.h"
#import <Chartboost/Chartboost.h>
#import <RevMobAds/RevMobAds.h>

@interface ViewController : UIViewController<GADBannerViewDelegate,ChartboostDelegate,RevMobAdsDelegate>{
    GADBannerView *bannerView_;
    //Chartboost *cb;
}
-(void)BannerHide;

@end

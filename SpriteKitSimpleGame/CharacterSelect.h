//
//  CharacterSelect.h
//  Shark prey
//
//  Created by Nur Farazi on 4/18/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GamePlay.h"
#import "mainMenu.h"
#import "RageIAPHelper.h"

@interface CharacterSelect : SKScene

{
    NSArray *_products2;
    NSNumberFormatter * _priceFormatter;
    
    NSString *ProductDescription;
    NSString *ProductTitle;
    
    BOOL ProductFound;
}

@end

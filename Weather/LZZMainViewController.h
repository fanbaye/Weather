//
//  LZZMainViewController.h
//  Weather
//
//  Created by lucas on 5/16/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZZCityView.h"

enum CityType {
    LocalCity = 0,
    OtherCity
    };

@interface LZZMainViewController : UIViewController <UIScrollViewDelegate, LZZCityViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@end

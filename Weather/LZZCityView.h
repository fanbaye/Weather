//
//  LZZCityView.h
//  Weather
//
//  Created by lucas on 5/16/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@protocol LZZCityViewDelegate <NSObject>

- (void)addNewsCity;

@end

@interface LZZCityView : UIView <ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

{
    id<LZZCityViewDelegate> _delegate;
}

@property (nonatomic, assign) id<LZZCityViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Type:(BOOL)type CityCode:(NSString *)cityCode Delegate:(id<LZZCityViewDelegate>)delegate;

@end

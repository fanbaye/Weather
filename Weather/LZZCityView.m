//
//  LZZCityView.m
//  Weather
//
//  Created by lucas on 5/16/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZCityView.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "LZZUniversal.h"

@interface LZZCityView ()

@property (nonatomic, copy) NSString *cityCode;

@end

@implementation LZZCityView

{
    UILabel *_cityNameLabel;
    UILabel *_timeLabel;
    UIScrollView *_scrollView;
    
    EGORefreshTableHeaderView *_refreshHeadView;
    BOOL _isLoading;
    
    UILabel *_weatherLabel;
    UILabel *_maxTempLabel;
    UILabel *_minTempLabel;
    UILabel *_currentTempLabel;
    UIImageView *_predictView;
    
}

@synthesize delegate = _delegate;
@synthesize cityCode = _cityCode;

- (void)dealloc
{
    self.cityCode = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame Type:(BOOL)type CityCode:(NSString *)cityCode Delegate:(id<LZZCityViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _isLoading = NO;
        self.cityCode = cityCode;
        
        self.clipsToBounds = YES;
        self.delegate = delegate;
        self.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:38.0/255.0 blue:39.0/255.0 alpha:1];;
        
        // 城市背景图
        UIImageView *localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [localImageView setImage:[UIImage imageNamed:@"city"]];
        [self addSubview:localImageView];
        [localImageView release];
        
        // 装载天气信息的底层
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(320, 700);
        [self addSubview:_scrollView];
        [_scrollView release];
        
        _refreshHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -416, 320, 416)];
        _refreshHeadView.delegate = self;
        [_refreshHeadView refreshLastUpdatedDate];
        [_scrollView addSubview:_refreshHeadView];
        [_refreshHeadView release];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        topView.backgroundColor = [UIColor clearColor];
        [self addSubview:topView];
        [topView release];
        
        // 上方添加按钮
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage imageNamed:@"addButtom"] forState:UIControlStateNormal];
        addButton.frame = CGRectMake(291, 13, 18, 18);
        [addButton addTarget:self action:@selector(addOneCity:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:addButton];
        // 上方设置按钮
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setImage:[UIImage imageNamed:@"settingButtom"] forState:UIControlStateNormal];
        settingButton.frame = CGRectMake(12, 13, 18, 18);
        [settingButton addTarget:self action:@selector(showSettingPanel:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:settingButton];
        
        // 城市名称标签
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 60, 18)];
        //文字阴影
        _cityNameLabel.shadowColor = [UIColor grayColor];
        _cityNameLabel.shadowOffset = CGSizeMake(1, 1);
        
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.backgroundColor = [UIColor clearColor];
        _cityNameLabel.textColor = [UIColor whiteColor];
        [topView addSubview:_cityNameLabel];
        [_cityNameLabel release];
        
        // 时间标签
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 60, 9)];
        _timeLabel.shadowColor = [UIColor grayColor];
        [self changeTime];
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.shadowOffset = CGSizeMake(1, 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        [topView addSubview:_timeLabel];
        [_timeLabel release];

        [self requestWeatherInfo];
        
        [self makeViews];
    }
    return self;
}

// 请求接口
- (void)requestWeatherInfo
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", _cityCode]]];
    request.tag = 3;
    request.delegate = self;
    [request startAsynchronous];
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html", _cityCode]]];
    request.tag = 1;
    request.delegate = self;
    [request startAsynchronous];
}


- (void)makeViews
{
    _weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 273, 100, 18)];
    _weatherLabel.backgroundColor = [UIColor clearColor];
    _weatherLabel.font = [UIFont boldSystemFontOfSize:17];
    _weatherLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_weatherLabel];
    [_weatherLabel release];
    
    _maxTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 298, 27, 14)];
    _maxTempLabel.font = [UIFont systemFontOfSize:12];
    _maxTempLabel.backgroundColor = [UIColor clearColor];
    _maxTempLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_maxTempLabel];
    [_maxTempLabel release];
    
    _minTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 298, 27, 14)];
    _minTempLabel.font = [UIFont systemFontOfSize:12];
    _minTempLabel.backgroundColor = [UIColor clearColor];
    _minTempLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_minTempLabel];
    [_minTempLabel release];
    
    _currentTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 320, 160, 85)];
    _currentTempLabel.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:21] size:100];
    _currentTempLabel.backgroundColor = [UIColor clearColor];
    _currentTempLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_currentTempLabel];
    [_currentTempLabel release];
    
    _predictView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 416, 308, 280)];
    _predictView.image = [UIImage imageNamed:@"opacity"];
    _predictView.layer.cornerRadius = 4;
    _predictView.layer.masksToBounds = YES;
    [_scrollView addSubview:_predictView];
    [_predictView release];

}

- (void)changeTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm"];
    NSString *str = [df stringFromDate:[NSDate date]];
    _timeLabel.text = str;
}

#pragma mark - ASIHTTPRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [request.responseData objectFromJSONData];
    NSDictionary *weatherInfoDic = [dic objectForKey:@"weatherinfo"];
    if (request.tag == 1) {
        _currentTempLabel.text = [NSString stringWithFormat:@"%@°", [weatherInfoDic objectForKey:@"temp"]];
    }else if (request.tag == 3){
        _cityNameLabel.text = [weatherInfoDic objectForKey:@"city"];
        _weatherLabel.text = [weatherInfoDic objectForKey:@"weather1"];
        NSString *temp = [weatherInfoDic objectForKey:@"temp1"];
        NSArray *array = [temp componentsSeparatedByString:@"~"];
        _maxTempLabel.text = [array objectAtIndex:1];
        _minTempLabel.text = [array objectAtIndex:0];
        
        NSArray *weekdays = [LZZUniversal weekdaysFormatter:[weatherInfoDic objectForKey:@"week"]];
        for (int i = 1; i < 7; i++) {
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 44+(i-1)*40, 80, 16)];
            dayLabel.text = [weekdays objectAtIndex:i-1];
            dayLabel.backgroundColor = [UIColor clearColor];
            dayLabel.textColor = [UIColor whiteColor];
            [_predictView addSubview:dayLabel];
            [dayLabel release];
            
            NSString *tmp = [NSString stringWithFormat:@"temp%d", i];
            NSString *temp = [weatherInfoDic objectForKey:tmp];
            NSArray *array = [temp componentsSeparatedByString:@"~"];
            
            UIImageView *tempImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warm"]];
            tempImageView.frame = CGRectMake(136, 37+(i-1)*40, 35, 25);
            [_predictView addSubview:tempImageView];
            [tempImageView release];
            
            UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(206, 44+(i-1)*40, 50, 13)];
            maxLabel.text = [array objectAtIndex:1];
            maxLabel.backgroundColor = [UIColor clearColor];
            maxLabel.textColor = [UIColor whiteColor];
            [_predictView addSubview:maxLabel];
            [maxLabel release];
            
            UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(257, 44+(i-1)*40, 50, 13)];
            minLabel.textColor = [UIColor colorWithRed:140.0/255.0 green:197.0/255.0 blue:255.0/255.0 alpha:1];
            minLabel.text = [array objectAtIndex:0];
            minLabel.backgroundColor = [UIColor clearColor];
            [_predictView addSubview:minLabel];
            [minLabel release];
        }
    }
    [_refreshHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    _isLoading = NO;
    NSLog(@"下载成功");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
    [_refreshHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    _isLoading = NO;
}

#pragma mark - Refresh Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeadView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeadView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isLoading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{

    return [NSDate date];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _isLoading = YES;
    [self requestWeatherInfo];
}

- (void)showSettingPanel:(UIButton *)sender
{
    
    UIViewController *viewController = (UIViewController *)_delegate;
    double x = viewController.view.frame.origin.x;
    [UIView animateWithDuration:0.5 animations:^{
        if (x == 280) {
            viewController.view.frame = CGRectMake(0, 0, 320, 460);
        }else{
            viewController.view.frame = CGRectMake(280, 0, 320, 460);
        }
    }];
    
}

- (void)addOneCity:(UIButton *)sender
{
    [_delegate addNewsCity];
}

@end

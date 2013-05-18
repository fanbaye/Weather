//
//  LZZCityView.m
//  Weather
//
//  Created by lucas on 5/16/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZCityView.h"
#import "JSONKit.h"

@interface LZZCityView ()

@end

@implementation LZZCityView

{
    BOOL _isHide;
    UILabel *_cityNameLabel;
}

@synthesize delegate = _delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame Type:(BOOL)type CityCode:(NSString *)cityCode Delegate:(id<LZZCityViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isHide = NO;
        
        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
        self.delegate = delegate;
        
        // 城市背景图
        UIImageView *localImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [localImageView setImage:[UIImage imageNamed:@"view"]];
        [self addSubview:localImageView];
        [localImageView release];
        
        // 装载天气信息的底层
        UIScrollView *detail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [self addSubview:detail];
        [detail release];
        
        // 上方添加按钮
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage imageNamed:@"addButtom"] forState:UIControlStateNormal];
        addButton.frame = CGRectMake(291, 13, 18, 18);
        [addButton addTarget:self action:@selector(addOneCity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        // 上方设置按钮
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setImage:[UIImage imageNamed:@"settingButtom"] forState:UIControlStateNormal];
        settingButton.frame = CGRectMake(12, 13, 18, 18);
        [settingButton addTarget:self action:@selector(showSettingPanel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:settingButton];
        
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 60, 18)];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.backgroundColor = [UIColor clearColor];
        _cityNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_cityNameLabel];
        [_cityNameLabel release];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", cityCode]]];
        request.delegate = self;
        [request startAsynchronous];
    
    }
    return self;
}

#pragma mark - ASIHTTPRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"%@",[request.responseData objectFromJSONData]);
    NSDictionary *dic = [request.responseData objectFromJSONData];
    NSDictionary *weatherInfoDic = [dic objectForKey:@"weatherinfo"];
    _cityNameLabel.text = [weatherInfoDic objectForKey:@"city"];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
}

- (void)showSettingPanel:(UIButton *)sender
{
    
    UIViewController *viewController = (UIViewController *)_delegate;
    [UIView animateWithDuration:0.5 animations:^{
        if (_isHide) {
            viewController.view.frame = CGRectMake(0, 0, 320, 460);
        }else{
            viewController.view.frame = CGRectMake(280, 0, 320, 460);
        }
        
    } completion:^(BOOL finished) {
        _isHide = !_isHide;
    }];
    
}

- (void)addOneCity:(UIButton *)sender
{
    [_delegate addNewsCity];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

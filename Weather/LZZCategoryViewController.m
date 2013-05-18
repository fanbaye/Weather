//
//  LZZCategoryViewController.m
//  Weather
//
//  Created by lucas on 5/17/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZCategoryViewController.h"
#import "LZZMainViewController.h"
#import "LZZCategoryCell.h"
#import "LZZManagerCityViewController.h"
#import "LZZUniversal.h"

@interface LZZCategoryViewController ()

@property (nonatomic, retain) NSArray *dataArray;

@end

@implementation LZZCategoryViewController

{
    UITableView *_tableView;
    LZZMainViewController *_mvc;
    UINavigationController *_nvc;
    NSMutableDictionary *_city;
    
    NSUserDefaults *_ud;
}

@synthesize dataArray = _dataArray;

- (void)dealloc
{
    self.dataArray = nil;
    [_city release];
    [_nvc release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LZZManagerCityViewController *mcvc = [[LZZManagerCityViewController alloc] init];
    _nvc = [[UINavigationController alloc] initWithRootViewController:mcvc];
    _ud = [NSUserDefaults standardUserDefaults];
    [mcvc release];
    
    // 解释好的字典
    _city = [[NSMutableDictionary alloc] initWithDictionary:[LZZUniversal codeAsKeyAndNameAsValue]];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:38.0/255.0 blue:39.0/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _mvc = [[LZZMainViewController alloc] init];
    _mvc.view.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_mvc.view];
    [self addChildViewController:_mvc];
    [_mvc release];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mvc.view.frame = CGRectMake(0, 0, 320, 460);
    
    [self getLocalCity];
    
    NSMutableArray *arrayFirstSection = [[NSMutableArray alloc] init];
    [arrayFirstSection addObject:@"编辑地点"];
    [arrayFirstSection addObject:[_ud objectForKey:@"localCity"]];
    for (NSString *str in [_ud objectForKey:@"city"]) {
        [arrayFirstSection addObject:str];
    }
    
    NSArray *arraySecondSection = [NSArray arrayWithObjects:@"设置", @"建议", @"关于", nil];
    
    self.dataArray = [NSArray arrayWithObjects:arrayFirstSection, arraySecondSection, nil];
    [_tableView reloadData];
}


- (void)getLocalCity
{
    NSString *str = [_ud objectForKey:@"localCity"];
    if (!str) {
        [_ud setObject:@"101010100" forKey:@"localCity"];
        [_ud synchronize];
    }
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    LZZCategoryCell *cell = (LZZCategoryCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[LZZCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
    }
    
    NSString *cityCode = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.label.text = cityCode;
        }else if (indexPath.row == 1){
            cell.label.text = @"目前位置";
        }else{
            cell.label.text = [_city objectForKey:cityCode];
        }
    }else{
        cell.label.text = cityCode;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionHead"]] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 32.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self presentViewController:_nvc animated:YES completion:^{
                
            }];
        }else{
            _mvc.scrollView.contentOffset = CGPointMake((indexPath.row - 1) * 320, 0);
            [UIView animateWithDuration:0.5 animations:^{
                    _mvc.view.frame = CGRectMake(0, 0, 320, 460);
            }];
        }
    }
}

@end

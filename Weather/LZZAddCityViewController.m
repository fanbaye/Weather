//
//  LZZAddCityViewController.m
//  Weather
//
//  Created by lucas on 5/17/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZAddCityViewController.h"
#import "LZZUniversal.h"

@interface LZZAddCityViewController ()

@end

@implementation LZZAddCityViewController

{
    NSMutableDictionary *_city;
    NSMutableArray *_resultArray;
    CGPoint _beginPoint;
    
    UITableView *_tableView;
    UISearchBar *_searchBar;
}

- (void)dealloc
{
    [_city release];
    [_resultArray release];
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
    
    _city = [[NSMutableDictionary alloc] initWithDictionary:[LZZUniversal nameAsKeyAndCodeAsValue]];
    _resultArray = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, 320, 460 - 30 - 45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    // 上部标题栏
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topLabel.userInteractionEnabled = YES;
    topLabel.text = @"输入城市名";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor lightGrayColor];
    topLabel.font = [UIFont systemFontOfSize:15];
    topLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topLine"]];
    [self.view addSubview:topLabel];
    [topLabel release];
    
    // 搜索栏
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 45)];
    searchView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:searchView];
    [searchView release];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 265, 45)];
    _searchBar.backgroundColor=[UIColor blackColor];
    for (UIView *subview in _searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [searchView addSubview:_searchBar];
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    [_searchBar release];
    
    // 返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(271, 8, 45, 30);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_resultArray removeAllObjects];
    for (NSString *string in [_city allKeys]) {
        if ([string rangeOfString:_searchBar.text].length) {
            [_resultArray addObject:string];
        }
    }
    [_tableView reloadData];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - TableView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
    }
    
    cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"city"]];
    [array addObject:[_city objectForKey:[_resultArray objectAtIndex:indexPath.row]]];
    [ud setObject:array forKey:@"city"];
    [array release];
    [ud synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

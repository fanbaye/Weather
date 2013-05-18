//
//  LZZManagerCityViewController.m
//  Weather
//
//  Created by lucas on 5/18/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZManagerCityViewController.h"
#import "LZZAddCityViewController.h"
#import "LZZUniversal.h"

@interface LZZManagerCityViewController ()

@property (nonatomic, retain) NSArray *dataArray;

@end

@implementation LZZManagerCityViewController

{
    UITableView *_tableView;
    LZZAddCityViewController *_cvc;
    NSMutableDictionary *_city;
}

@synthesize dataArray = _dataArray;

- (void)dealloc
{
    self.dataArray = nil;
    [_city release];
    [_cvc release];
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
    _cvc = [[LZZAddCityViewController alloc] init];
    _city = [[NSMutableDictionary alloc] initWithDictionary:[LZZUniversal codeAsKeyAndNameAsValue]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	// Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editCity:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    [rightBBI release];
    
    UIBarButtonItem *leftBBI= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    [leftBBI release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *arrayFirstSection = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"], nil];
    NSMutableArray *arraySecondSection = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]];
    
    self.dataArray = [NSArray arrayWithObjects:arrayFirstSection, arraySecondSection, nil];
    [arrayFirstSection release];
    [arraySecondSection release];
    [_tableView reloadData];
    _tableView.editing = YES;
}

// 上方的两个按钮
- (void)addCity:(UIBarButtonItem *)sender
{
    [self presentViewController:_cvc animated:YES completion:^{
        
    }];
}

- (void)editCity:(UIBarButtonItem *)sender
{
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    if (!_tableView.isEditing) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    NSString *cityCode = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [_city objectForKey:cityCode];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

// 设置编辑的属性
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
}

// 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[_dataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[_dataArray objectAtIndex:indexPath.section] forKey:@"city"];
    [ud synchronize];
}

// 移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *cityName = [[[_dataArray objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row] retain];
    [[_dataArray objectAtIndex:sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    [[_dataArray objectAtIndex:destinationIndexPath.section] insertObject:cityName atIndex:destinationIndexPath.row];
    [cityName release];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[_dataArray objectAtIndex:sourceIndexPath.section] forKey:@"city"];
    [ud synchronize];
}
@end

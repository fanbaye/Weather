//
//  LZZUniversal.m
//  Weather
//
//  Created by lucas on 5/18/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZUniversal.h"
#import "JSONKit.h"

@implementation LZZUniversal

+ (NSMutableDictionary *)codeAsKeyAndNameAsValue
{
    NSMutableDictionary *city = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityCode" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [string objectFromJSONString];
    NSArray *array = [dic objectForKey:@"城市代码"];
    for (NSDictionary *cityDic in array) {
        NSArray *cityArray = [cityDic objectForKey:@"市"];
        for (NSDictionary *subCityDic in cityArray) {
            [city setObject:[subCityDic objectForKey:@"市名"] forKey:[subCityDic objectForKey:@"编码"]];
        }
    }
    return city;
}

+ (NSMutableDictionary *)nameAsKeyAndCodeAsValue
{
    NSMutableDictionary *city = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityCode" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [string objectFromJSONString];
    NSArray *array = [dic objectForKey:@"城市代码"];
    for (NSDictionary *cityDic in array) {
        NSArray *cityArray = [cityDic objectForKey:@"市"];
        for (NSDictionary *subCityDic in cityArray) {
            [city setObject:[subCityDic objectForKey:@"编码"] forKey:[subCityDic objectForKey:@"市名"]];
        }
    }
    return city;
}

+ (NSMutableArray *)allCityInNSUserDefault
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [array addObject:[ud objectForKey:@"localCity"]];
    NSArray *city = [ud objectForKey:@"city"];
    if ([city count]) {
        for (NSString *string in city) {
            [array addObject:string];
        }
    }
    return array;
}

+ (NSMutableArray *)weekdaysFormatter:(NSString *)weekday
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"星期一", @"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五", nil];
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 7; i++) {
        if ([weekday isEqualToString:[array objectAtIndex:i]]) {
            [result addObject:weekday];
            [result addObject:[array objectAtIndex:i+1]];
            [result addObject:[array objectAtIndex:i+2]];
            [result addObject:[array objectAtIndex:i+3]];
            [result addObject:[array objectAtIndex:i+4]];
            [result addObject:[array objectAtIndex:i+5]];
            break;
        }
    }
    [array release];
    return result;
}

@end

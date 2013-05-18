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

@end

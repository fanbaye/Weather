//
//  LZZUniversal.h
//  Weather
//
//  Created by lucas on 5/18/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZZUniversal : NSObject

+ (NSMutableDictionary *)codeAsKeyAndNameAsValue;
+ (NSMutableDictionary *)nameAsKeyAndCodeAsValue;
+ (NSMutableArray *)allCityInNSUserDefault;
+ (NSMutableArray *)weekdaysFormatter:(NSString *)weekday;
@end

//
//  DBModel.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/23.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "DBModel.h"

@implementation WrongInfoModel

@end

@implementation DBModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"wrong_info" : [WrongInfoModel class] };
}

@end

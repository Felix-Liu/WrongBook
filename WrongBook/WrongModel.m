//
//  WrongModel.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "WrongModel.h"

@implementation WrongModel

@end

@implementation WrongListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"wrong_list" : [WrongModel class] };
}

@end

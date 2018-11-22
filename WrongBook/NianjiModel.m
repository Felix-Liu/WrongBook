//
//  NianjiModel.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "NianjiModel.h"

@implementation NianjiModel

@end

@implementation NianjiListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"nianji_list" : [NianjiModel class] };
}

@end

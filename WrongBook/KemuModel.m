//
//  KemuModel.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "KemuModel.h"

@implementation KemuModel

@end

@implementation KemuListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"kemu_list" : [KemuModel class] };
}

@end

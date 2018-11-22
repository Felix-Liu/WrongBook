//
//  Utility.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "Utility.h"

@implementation Utility

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end

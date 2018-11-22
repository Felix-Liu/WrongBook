//
//  Utility.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name;

@end

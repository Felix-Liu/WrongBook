//
//  DBModel.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/23.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WrongInfoModel : NSObject

@property (nonatomic, strong) NSString *image_name;
@property (nonatomic, strong) NSString *wrong_desc;

@end

@interface DBModel : NSObject

@property (nonatomic, strong) NSString *kemu_id;
@property (nonatomic, strong) NSString *kemu_name;
@property (nonatomic, strong) NSMutableArray<WrongInfoModel *> *wrong_info;

@end

//
//  KemuModel.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KemuModel : NSObject

@property (nonatomic, strong) NSString *kemu_id;
@property (nonatomic, strong) NSString *kemu_name;
@property (nonatomic, assign) BOOL checked;

@end

@interface KemuListModel : NSObject

@property (nonatomic, strong) NSArray<KemuModel *> *kemu_list;

@end

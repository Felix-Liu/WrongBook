//
//  WrongModel.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WrongModel : NSObject

@property (nonatomic, strong) NSString *wrong_id;
@property (nonatomic, strong) NSString *wrong_name;

@end

@interface WrongListModel : NSObject

@property (nonatomic, strong) NSArray<WrongModel *> *wrong_list;

@end

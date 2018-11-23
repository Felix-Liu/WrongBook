//
//  NianjiModel.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NianjiModel : NSObject

@property (nonatomic, strong) NSString *nianji_id;
@property (nonatomic, strong) NSString *nianji_name;
@property (nonatomic, assign) BOOL checked;

@end

@interface NianjiListModel : NSObject

@property (nonatomic, strong) NSArray<NianjiModel *> *nianji_list;

@end

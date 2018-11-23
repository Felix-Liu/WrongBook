//
//  CategoryViewController.h
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KemuModel.h"
#import "NianjiModel.h"
#import "WrongModel.h"

@protocol CategoryViewControllerDelegate <NSObject>

- (void)doneWithKemu:(KemuModel *)kemu nianji:(NianjiModel *)nianji wrong:(WrongModel *)wrong;

@end

@interface CategoryViewController : UIViewController

@property (nonatomic, assign) id<CategoryViewControllerDelegate> delegate;

@end

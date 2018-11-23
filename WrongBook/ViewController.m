//
//  ViewController.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "ViewController.h"
#import "Utility.h"
#import "YYModel.h"
#import "KemuModel.h"

@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) KemuListModel *kemuListModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"错题库";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.segmentedControl];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        NSMutableArray *kemuArray = [NSMutableArray new];
        [self.kemuListModel.kemu_list enumerateObjectsUsingBlock:^(KemuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [kemuArray addObject:obj.kemu_name];
        }];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:kemuArray];
        _segmentedControl.frame = CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 40);
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (KemuListModel *)kemuListModel {
    if (!_kemuListModel) {
        _kemuListModel = [KemuListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"KemuData"]];
    }
    return _kemuListModel;
}

@end

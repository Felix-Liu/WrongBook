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
#import "DBModel.h"
#import "WrongInfoCell.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define TAB_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83.0f : 49.0f)
#define STATUS_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) KemuListModel *kemuListModel;
@property (nonatomic, strong) UITableView *wrongBookTV;
@property (nonatomic, strong) NSMutableArray *dbModelArray;
@property (nonatomic, strong) NSMutableArray *wrongInfoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"错题库";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.wrongBookTV];
    [self.wrongBookTV reloadData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"SuccessNotification" object:nil];
}

- (void)refreshData {
    [self.dbModelArray removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"db.plist"];
    NSMutableArray *dbArray = [[NSMutableArray alloc] initWithContentsOfFile:dbPath];
    [dbArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dbModelArray addObject:[DBModel yy_modelWithJSON:obj]];
    }];
    __block DBModel *dbModel = nil;
    [self.dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.kemu_id integerValue] == self.segmentedControl.selectedSegmentIndex + 1) {
            dbModel = obj;
        }
    }];
    self.wrongInfoArray = dbModel.wrong_info;
    [self.wrongBookTV reloadData];
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
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)segmentValueChanged:(id)sender {
    __block DBModel *dbModel = nil;
    [self.dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.kemu_id integerValue] == self.segmentedControl.selectedSegmentIndex + 1) {
            dbModel = obj;
        }
    }];
    self.wrongInfoArray = dbModel.wrong_info;
    [self.wrongBookTV reloadData];
}

- (KemuListModel *)kemuListModel {
    if (!_kemuListModel) {
        _kemuListModel = [KemuListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"KemuData"]];
    }
    return _kemuListModel;
}

- (UITableView *)wrongBookTV {
    if (!_wrongBookTV) {
        _wrongBookTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - 70 - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _wrongBookTV.dataSource = self;
        _wrongBookTV.delegate = self;
        [_wrongBookTV registerClass:[WrongInfoCell class] forCellReuseIdentifier:@"CellIdentifier"];
    }
    return _wrongBookTV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wrongInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WrongInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    __block DBModel *dbModel = nil;
    [self.dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.kemu_id integerValue] == self.segmentedControl.selectedSegmentIndex + 1) {
            dbModel = obj;
        }
    }];
    [cell updateCellWithData:self.wrongInfoArray[indexPath.row] kemu:dbModel.kemu_name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)dbModelArray {
    if (!_dbModelArray) {
        _dbModelArray = [NSMutableArray new];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"db.plist"];
        NSMutableArray *dbArray = [[NSMutableArray alloc] initWithContentsOfFile:dbPath];
        [dbArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dbModelArray addObject:[DBModel yy_modelWithJSON:obj]];
        }];
    }
    return _dbModelArray;
}

- (NSMutableArray *)wrongInfoArray {
    if (!_wrongInfoArray) {
        __block DBModel *dbModel = nil;
        [self.dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.kemu_id integerValue] == self.segmentedControl.selectedSegmentIndex + 1) {
                dbModel = obj;
            }
        }];
        _wrongInfoArray = dbModel.wrong_info;
    }
    return _wrongInfoArray;
}

@end

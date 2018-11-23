//
//  CategoryViewController.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "CategoryViewController.h"
#import "YYModel.h"
#import "Utility.h"
#import "KemuModel.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define TAB_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83.0f : 49.0f)
#define STATUS_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *categoryTV;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) KemuModel *kemu;
@property (nonatomic, strong) NianjiModel *nianji;
@property (nonatomic, strong) WrongModel *wrong;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) KemuListModel *kemuListModel;
@property (nonatomic, strong) NianjiListModel *nianjiListModel;
@property (nonatomic, strong) NianjiItemModel *nianjiItemModel;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择分类";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.categoryTV];
    [self.categoryTV reloadData];
    
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    [self.navigationItem setLeftBarButtonItem:closeButtonItem];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
}

- (void)done {
    NSString *msg = @"";
    if (!self.kemu) {
        msg = @"请选择科目";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!self.nianji) {
        msg = @"请选择题型、内容";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!self.wrong) {
        msg = @"请选择错误类型";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if (self.delegate) {
        [self.delegate doneWithKemu:self.kemu nianji:self.nianji wrong:self.wrong];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
        {
            NianjiItemModel *nianjiItemModel = self.categoryArray[section];
            numberOfRows = nianjiItemModel.kemu_neirong.count;
            break;
        }
        case 1:
        {
            WrongListModel *wrongListModel = self.categoryArray[section];
            numberOfRows = wrongListModel.wrong_list.count;
            break;
        }
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            NianjiItemModel *nianjiItemModel = self.categoryArray[indexPath.section];
            NianjiModel *nianjiModel = nianjiItemModel.kemu_neirong[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
            cell.textLabel.text = nianjiModel.nianji_name;
            if (nianjiModel.checked) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
        case 1:
        {
            WrongListModel *wrongListModel = self.categoryArray[indexPath.section];
            WrongModel *wrongModel = wrongListModel.wrong_list[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
            cell.textLabel.text = wrongModel.wrong_name;
            if (wrongModel.checked) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)];
    switch (section) {
        case 0:
            titleLbl.text = @"题型、内容";
            break;
        case 1:
            titleLbl.text = @"错误类型";
            break;
        default:
            break;
    }
    [headerView addSubview:titleLbl];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NianjiItemModel *nianjiItemModel = self.categoryArray[indexPath.section];
            NianjiModel *nianjiModel = nianjiItemModel.kemu_neirong[indexPath.row];
            [nianjiItemModel.kemu_neirong enumerateObjectsUsingBlock:^(NianjiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.checked = NO;
            }];
            nianjiModel.checked = YES;
            self.nianji = nianjiModel;
            break;
        }
        case 1:
        {
            WrongListModel *wrongListModel = self.categoryArray[indexPath.section];
            [wrongListModel.wrong_list enumerateObjectsUsingBlock:^(WrongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.checked = NO;
            }];
            WrongModel *wrongModel = wrongListModel.wrong_list[indexPath.row];
            wrongModel.checked = YES;
            self.wrong = wrongModel;
            break;
        }
        default:
            break;
    }
    [self.categoryTV reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)categoryTV {
    if (!_categoryTV) {
        _categoryTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - 70) style:UITableViewStylePlain];
        _categoryTV.dataSource = self;
        _categoryTV.delegate = self;
        [_categoryTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    }
    return _categoryTV;
}

- (NSMutableArray *)categoryArray {
    if (!_categoryArray) {
        self.nianjiListModel = [NianjiListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"NianjiData"]];
        self.nianjiItemModel = self.nianjiListModel.nianji_list[self.segmentedControl.selectedSegmentIndex];
        WrongListModel *wrongListModel = [WrongListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"WrongData"]];
        _categoryArray = [@[self.nianjiItemModel, wrongListModel] mutableCopy];
    }
    return _categoryArray;
}

- (KemuListModel *)kemuListModel {
    if (!_kemuListModel) {
        _kemuListModel = [KemuListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"KemuData"]];
    }
    return _kemuListModel;
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
        self.kemu = self.kemuListModel.kemu_list[_segmentedControl.selectedSegmentIndex];
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)segmentValueChanged:(id)sender {
    self.kemu = self.kemuListModel.kemu_list[_segmentedControl.selectedSegmentIndex];
    [self.categoryArray removeAllObjects];
    self.nianjiItemModel = self.nianjiListModel.nianji_list[self.segmentedControl.selectedSegmentIndex];
    WrongListModel *wrongListModel = [WrongListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"WrongData"]];
    self.categoryArray = [@[self.nianjiItemModel, wrongListModel] mutableCopy];
    [self.categoryTV reloadData];
}

@end

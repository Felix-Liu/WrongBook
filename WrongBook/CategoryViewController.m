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

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define TAB_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83.0f : 49.0f)
#define STATUS_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *categoryTV;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) KemuModel *kemu;
@property (nonatomic, strong) NianjiModel *nianji;
@property (nonatomic, strong) WrongModel *wrong;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择分类";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
        msg = @"请选择年级";
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
            KemuListModel *kemuListModel = self.categoryArray[0];
            numberOfRows = kemuListModel.kemu_list.count;
            break;
        }
        case 1:
        {
            NianjiListModel *nianjiListModel = self.categoryArray[1];
            numberOfRows = nianjiListModel.nianji_list.count;
            break;
        }
        case 2:
        {
            WrongListModel *wrongListModel = self.categoryArray[2];
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
            KemuListModel *kemuListModel = self.categoryArray[0];
            KemuModel *kemuModel = kemuListModel.kemu_list[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
            cell.textLabel.text = kemuModel.kemu_name;
            if (kemuModel.checked) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
        case 1:
        {
            NianjiListModel *nianjiListModel = self.categoryArray[1];
            NianjiModel *nianjiModel = nianjiListModel.nianji_list[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
            cell.textLabel.text = nianjiModel.nianji_name;
            if (nianjiModel.checked) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
        case 2:
        {
            WrongListModel *wrongListModel = self.categoryArray[2];
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
            titleLbl.text = @"科目";
            break;
        case 1:
            titleLbl.text = @"年级";
            break;
        case 2:
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
            KemuListModel *kemuListModel = self.categoryArray[0];
            [kemuListModel.kemu_list enumerateObjectsUsingBlock:^(KemuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.checked = NO;
            }];
            KemuModel *kemuModel = kemuListModel.kemu_list[indexPath.row];
            kemuModel.checked = YES;
            self.kemu = kemuModel;
            break;
        }
        case 1:
        {
            NianjiListModel *nianjiListModel = self.categoryArray[1];
            NianjiModel *nianjiModel = nianjiListModel.nianji_list[indexPath.row];
            [nianjiListModel.nianji_list enumerateObjectsUsingBlock:^(NianjiModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.checked = NO;
            }];
            nianjiModel.checked = YES;
            self.nianji = nianjiModel;
            break;
        }
        case 2:
        {
            WrongListModel *wrongListModel = self.categoryArray[2];
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
        _categoryTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
        _categoryTV.dataSource = self;
        _categoryTV.delegate = self;
        [_categoryTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    }
    return _categoryTV;
}

- (NSArray *)categoryArray {
    if (!_categoryArray) {
        KemuListModel *kemuListModel = [KemuListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"KemuData"]];
        NianjiListModel *nianjiListModel = [NianjiListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"NianjiData"]];
        WrongListModel *wrongListModel = [WrongListModel yy_modelWithJSON:[Utility readLocalFileWithName:@"WrongData"]];
        _categoryArray = @[kemuListModel, nianjiListModel, wrongListModel];
    }
    return _categoryArray;
}

@end

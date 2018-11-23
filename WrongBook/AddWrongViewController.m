//
//  AddWrongViewController.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "AddWrongViewController.h"
#import "CategoryViewController.h"
#import "DBModel.h"
#import "YYModel.h"
#import "UIImage+SubImage.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define TAB_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83.0f : 49.0f)
#define STATUS_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

@interface AddWrongViewController () <UIActionSheetDelegate, CategoryViewControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addCategoryBtn;
@property (nonatomic, strong) UIButton *addPicBtn;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIImageView *wrongIV;
@property (nonatomic, strong) UITextView *descTV;

@property (nonatomic, strong) KemuModel *kemuModel;
@property (nonatomic, strong) NianjiModel *nianjiModel;
@property (nonatomic, strong) WrongModel *wrongModel;

@end

@implementation AddWrongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addCategoryBtn];
    [self.scrollView addSubview:self.addPicBtn];
    [self.scrollView addSubview:self.wrongIV];
    [self.scrollView addSubview:self.descLbl];
    [self.scrollView addSubview:self.descTV];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done {
    if (!self.kemuModel || !self.nianjiModel || !self.wrongModel) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请添加分类" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!self.wrongIV.image) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请添加图片" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!self.descTV.text || [self.descTV.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请添加描述" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self createDir:self.kemuModel.kemu_name];
    [self saveImage:self.wrongIV.image];
    [self writeToPlist];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessNotification" object:nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)writeToPlist {
    //获取路径对象
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePath = [path stringByAppendingPathComponent:@"db.plist"];
    //    NSLog(@"------filepath---%@",filePatch);
    /**
     下面是我的plist路径,在桌面空白处点击一下，前往－按住option-资源库-Developer-CoreSimulator-Devices......就按照下面路径找到plist所在的位置
     /Users/baiteng01/Library/Developer/CoreSimulator/Devices/92444384-5241-4934-B078-1A7241F1B687/data/Containers/Data/Application/73005382-D1FB-4BC2-BB4E-1FBC64284141/Documents/xiaoxi.plist
     */
    //写入数据到plist文件
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小小虎",@"name",@"5",@"age",@"boy",@"sex",nil];
//    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小小兮",@"name",@"6",@"age",@"girl",@"sex",nil];
//    //将上面2个小字典保存到大字典里面
//    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];    [dataDic setObject:dic1 forKey:@"一年级"];
//    [dataDic setObject:dic2 forKey:@"二年级"];    //写入plist里面
//    [dataDic writeToFile:filePath atomically:YES];        //读取plist文件的内容
//    NSMutableArray *dbArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//    NSLog(@"---plist一开始保存时候的内容---%@",dbArray);
    
    NSMutableArray *mKemuArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (!mKemuArray) {
        mKemuArray = [NSMutableArray new];
        NSDictionary *kemuDict = @{ @"kemu_id": self.kemuModel.kemu_id, @"kemu_name": self.kemuModel.kemu_name, @"wrong_info": [@[@{ @"image_name": [NSString stringWithFormat:@"%@-%@-%@-%@", self.kemuModel.kemu_id, self.nianjiModel.nianji_id, self.wrongModel.wrong_id, @"1"], @"wrong_desc": self.descTV.text }] mutableCopy] };
        [mKemuArray addObject:kemuDict];
        BOOL result = [mKemuArray writeToFile:filePath atomically:YES];
        if (result == YES) {
            NSLog(@"保存成功");
        }
    } else {
        __block BOOL isContainKemu = NO;
        [mKemuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"kemu_id"] isEqualToString:self.kemuModel.kemu_id]) {
                isContainKemu = YES;
            }
        }];
        if (!isContainKemu) {
            NSDictionary *kemuDict = @{ @"kemu_id": self.kemuModel.kemu_id, @"kemu_name": self.kemuModel.kemu_name, @"wrong_info": [@[@{ @"image_name": [NSString stringWithFormat:@"%@-%@-%@-%@", self.kemuModel.kemu_id, self.nianjiModel.nianji_id, self.wrongModel.wrong_id, @"1"], @"wrong_desc": self.descTV.text }] mutableCopy] };
            [mKemuArray addObject:kemuDict];
            BOOL result = [mKemuArray writeToFile:filePath atomically:YES];
            if (result == YES) {
                NSLog(@"保存成功");
            }
        } else {
            //        NSMutableArray *dbModelArray = [NSMutableArray new];
            //        [mKemuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            [dbModelArray addObject:[DBModel yy_modelWithJSON:obj]];
            //        }];
            //        [dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull dbModel, NSUInteger idx, BOOL * _Nonnull stop) {
            //            if ([dbModel.kemu_id isEqualToString:self.kemuModel.kemu_id]) {
            //                NSInteger image_no = dbModel.wrong_info.count;
            //                [dbModel.wrong_info addObject:[@[@{ @"image_name": [NSString stringWithFormat:@"%@-%@-%@-%@", self.kemuModel.kemu_id, self.nianjiModel.nianji_id, self.wrongModel.wrong_id, @(image_no++)], @"wrong_desc": self.descLbl.text }] mutableCopy]];
            //            }
            //        }];
            
            [mKemuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"kemu_id"] isEqualToString:self.kemuModel.kemu_id]) {
                    NSMutableArray *wrong_info = obj[@"wrong_info"];
                    NSInteger image_no = wrong_info.count;
                    [wrong_info addObject:@{ @"image_name": [NSString stringWithFormat:@"%@-%@-%@-%@", self.kemuModel.kemu_id, self.nianjiModel.nianji_id, self.wrongModel.wrong_id, @(++image_no)], @"wrong_desc": self.descTV.text }];
                }
            }];
            BOOL result = [mKemuArray writeToFile:filePath atomically:YES];
            if (result == YES) {
                NSLog(@"保存成功");
            }
        }
    }
}

- (void)createDir:(NSString *)dirName {
    // NSDocumentDirectory 沙盒 Documents 目录
    // NSLibraryDirectory  沙盒 Library   目录
    // NSCachesDirectory   沙盒 Library/Caches   目录
    // 使用NSSearchPathForDirectoriesInDomains只能定位Caches、Library、Documents目录,tmp目录，不能按照此方法获得
    if (!dirName || [dirName isEqualToString:@""]) {
        return;
    }
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:dirName]; // 在指定目录下创建 "head" 文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        // 在 Document 目录下创建一个 head 目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"db.plist"];
    __block NSInteger image_no = 0;
    NSMutableArray *dbArray = [[NSMutableArray alloc] initWithContentsOfFile:dbPath];
    NSMutableArray *dbModelArray = [NSMutableArray new];
    if (!dbArray) {
        image_no = 1;
    } else {
        [dbArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dbModelArray addObject:[DBModel yy_modelWithJSON:obj]];
        }];
        [dbModelArray enumerateObjectsUsingBlock:^(DBModel * _Nonnull dbModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([dbModel.kemu_id isEqualToString:self.kemuModel.kemu_id]) {
                image_no = dbModel.wrong_info.count;
            }
        }];
        image_no++;
    }
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@-%@-%@-%@.jpeg", self.kemuModel.kemu_name, self.kemuModel.kemu_id, self.nianjiModel.nianji_id, self.wrongModel.wrong_id, @(image_no)]];  // 保存文件的名称
    BOOL result =[UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
}


- (void)addCategoryBtnPressed:(id)sender {
    CategoryViewController *categoryVC = [CategoryViewController new];
    categoryVC.delegate = self;
    UINavigationController *categoryNC = [[UINavigationController alloc] initWithRootViewController:categoryVC];
    categoryNC.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController presentViewController:categoryNC animated:YES completion:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addPicBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}

//-(void)keyboardWillShow:(NSNotification*)notification{
//    NSDictionary*info=[notification userInfo];
//    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
//    NSLog(@"keyboard changed, keyboard width = %f, height = %f",
//          kbSize.width,kbSize.height);
//    //在这里调整UI位置
//
//}
//
//- (void)keyboardWillHide {
//    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height + 500);
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openPhotoAlbum];
            break;
        default:
            break;
    }
}

- (void)openCamera {
    // 判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalPresentationPopover;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
        }];
    } else {
        // 如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"你的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)openPhotoAlbum {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    //设置选择后的图片可被编辑
    pickerController.allowsEditing = NO;
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.wrongIV.image = [image rescaleImageToSize:CGSizeMake(500, 500)];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CategoryViewControllerDelegate

- (void)doneWithKemu:(KemuModel *)kemu nianji:(NianjiModel *)nianji wrong:(WrongModel *)wrong {
    self.kemuModel = kemu;
    self.nianjiModel = nianji;
    self.wrongModel = wrong;
    [self.addCategoryBtn setTitle:[NSString stringWithFormat:@"%@/%@/%@", kemu.kemu_name, nianji.nianji_name, wrong.wrong_name] forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIButton *)addCategoryBtn {
    if (!_addCategoryBtn) {
        _addCategoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addCategoryBtn.frame = CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 40);
        [_addCategoryBtn setTitle:@"添加分类" forState:UIControlStateNormal];
        [_addCategoryBtn addTarget:self action:@selector(addCategoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCategoryBtn;
}

- (UIButton *)addPicBtn {
    if (!_addPicBtn) {
        _addPicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addPicBtn.frame = CGRectMake(15, 70, [UIScreen mainScreen].bounds.size.width - 30, 40);
        [_addPicBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addPicBtn addTarget:self action:@selector(addPicBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPicBtn;
}

- (UILabel *)descLbl {
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.frame = CGRectMake(15, 340, [UIScreen mainScreen].bounds.size.width - 30, 40);
        _descLbl.text = @"添加描述";
        _descLbl.textColor = [UIColor blackColor];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.font = [UIFont systemFontOfSize:15];
    }
    return _descLbl;
}

- (UIImageView *)wrongIV {
    if (!_wrongIV) {
        _wrongIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 125, [UIScreen mainScreen].bounds.size.width - 30, 200)];
        _wrongIV.contentMode = UIViewContentModeScaleAspectFit;
        _wrongIV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _wrongIV;
}

- (UITextView *)descTV {
    if (!_descTV) {
        _descTV = [[UITextView alloc] initWithFrame:CGRectMake(15, 395, [UIScreen mainScreen].bounds.size.width - 30, 50)];
        _descTV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _descTV.layer.borderWidth = 1.0f;
        _descTV.layer.cornerRadius = 5.0f;
        _descTV.returnKeyType = UIReturnKeyDone;
        _descTV.delegate = self;
    }
    return _descTV;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height - 250);
    [self.scrollView setContentOffset:CGPointMake(0, 250) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height + 250);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT);
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT + 50);
    }
    return _scrollView;
}

@end

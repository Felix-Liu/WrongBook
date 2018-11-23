//
//  WrongInfoCell.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/23.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "WrongInfoCell.h"
#import "DBModel.h"

@interface WrongInfoCell ()

@property (nonatomic, strong) UIImageView *wrongIV;
@property (nonatomic, strong) UILabel *descLbl;

@end

@implementation WrongInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.wrongIV];
    [self.contentView addSubview:self.descLbl];
}

- (void)updateCellWithData:(WrongInfoModel *)data kemu:(NSString *)kemu_name {
    self.descLbl.text = data.wrong_desc;
    self.wrongIV.image = [self getImageWithName:data.image_name kemu:kemu_name];
}

- (UIImage *)getImageWithName:(NSString *)imageName kemu:(NSString *)kemu_name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.jpeg", kemu_name, imageName]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSLog(@"=== %@", img);
    return img;
}

- (UILabel *)descLbl {
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.frame = CGRectMake(15, 230, [UIScreen mainScreen].bounds.size.width - 30, 55);
        _descLbl.textColor = [UIColor blackColor];
        _descLbl.font = [UIFont systemFontOfSize:15];
    }
    return _descLbl;
}

- (UIImageView *)wrongIV {
    if (!_wrongIV) {
        _wrongIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 200)];
        _wrongIV.contentMode = UIViewContentModeScaleAspectFit;
        _wrongIV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _wrongIV;
}

@end

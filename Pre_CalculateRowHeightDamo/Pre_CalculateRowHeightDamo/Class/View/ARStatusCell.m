//
//  ARStatusCell.m
//  Pre_CalculateRowHeightDamo
//
//  Created by Ari on 2017/3/29.
//  Copyright © 2017年 xiaohaizi. All rights reserved.
//

#import "ARStatusCell.h"
#import "Status.h"
#import "User.h"
#import "Picture.h"
static const CGFloat margin = 15;
@interface ARStatusCell ()
/**头像*/
@property(nonatomic,weak) UIImageView *iconView;
/**昵称*/
@property(nonatomic,weak) UILabel *nameLabel;
/**来自*/
@property(nonatomic,weak) UILabel *sourceLabel;
/**发布时间*/
@property(nonatomic,weak) UILabel *createdLabel;
/**状态内容*/
@property(nonatomic,weak) UILabel *contentLabel;
@end
@implementation ARStatusCell

- (CGFloat)getMaxY {
    
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(self.contentLabel.frame) + margin;
}

- (void)setModel:(Status *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    self.nameLabel.text = model.user.name;
    self.sourceLabel.text = model.source;
    self.createdLabel.text = model.created_at;
    self.contentLabel.text = model.text;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *iconView = [UIImageView new];
    iconView.layer.cornerRadius = 22.5;
    iconView.layer.masksToBounds = true;
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.numberOfLines = 1;
    nameLabel.text = @"xx";
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UILabel *sourceLabel = [UILabel new];
    sourceLabel.textColor = [UIColor orangeColor];
    sourceLabel.text = @"来自火星";
    sourceLabel.numberOfLines = 1;
    self.sourceLabel = sourceLabel;
    [self.contentView addSubview:sourceLabel];
    
    
    UILabel *createdLabel = [UILabel new];
    createdLabel.textColor = [UIColor orangeColor];
    createdLabel.text = @"刚刚";
    createdLabel.numberOfLines = 1;
    self.createdLabel = createdLabel;
    [self.contentView addSubview:createdLabel];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = @"刚刚";
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:contentLabel];
    
    
    //布局
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(margin);
        make.height.width.offset(45);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.right).offset(margin);
        make.top.equalTo(iconView);
    }];
    
    [createdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.right).offset(margin);
        make.bottom.equalTo(iconView);
    }];

    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(createdLabel.right).offset(0);
        make.centerY.equalTo(createdLabel);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView);
        make.right.offset(-margin);
        make.top.equalTo(iconView.bottom).offset(margin);
    }];
}

@end

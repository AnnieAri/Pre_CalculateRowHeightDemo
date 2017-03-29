//
//  ARStatusCell.h
//  Pre_CalculateRowHeightDamo
//
//  Created by Ari on 2017/3/29.
//  Copyright © 2017年 xiaohaizi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@interface ARStatusCell : UITableViewCell
@property(nonatomic,strong) Status *model;

- (CGFloat)getMaxY;
@end

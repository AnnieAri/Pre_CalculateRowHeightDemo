//
//  ARHomeViewController.m
//  Pre_CalculateRowHeightDamo
//
//  Created by Ari on 2017/3/29.
//  Copyright © 2017年 xiaohaizi. All rights reserved.
//

#import "ARHomeViewController.h"
#import "ARStatusCell.h"
#import "Status.h"
static NSString *const cellID = @"cellID";
@interface ARHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSArray <Status *>*datas;
@end

@implementation ARHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    [self loadData];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[ARStatusCell class] forCellReuseIdentifier:cellID];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *datas = dict[@"statuses"];
    self.datas = [NSArray yy_modelArrayWithClass:[Status class] json:datas];
    
    for (Status *model in self.datas) {
        
        ARStatusCell *cell = [[ARStatusCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        NSLog(@"cell's frame = %@",NSStringFromCGRect(cell.frame));
        cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1000);
        cell.model = model;
        model.rowHeight = [cell getMaxY];
    }
    
    [self.tableView reloadData];
}
#pragma mark -  delegate & dataSource 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.datas[indexPath.row].rowHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ARStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    return cell;
}
/**========================================================================================================================*/


@end

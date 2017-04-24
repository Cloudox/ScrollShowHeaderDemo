//
//  ViewController.m
//  ScrollShowHeaderDemo
//
//  Created by csdc-iMac on 2017/4/20.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "ViewController.h"
#import "OXScrollHeaderView.h"

// 设备的宽高
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;// 列表
@property (nonatomic, strong) NSArray *dataArray;// 列表数据
@property (nonatomic, strong) OXScrollHeaderView *scrollHeader;// 顶部视图

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"天地玄黄", @"宇宙洪荒", @"日月盈昃", @"辰宿列张", @"寒来暑往", @"秋收冬藏", @"闰余成岁", @"律吕调阳", @"云腾致雨", @"露结为霜", @"金生丽水", @"玉出昆冈", @"剑号巨阙", @"珠称夜光", @"果珍李柰", @"菜重芥姜", @"海咸河淡", @"鳞潜羽翔", @"龙师火帝", @"鸟官人皇", @"始制文字", @"乃服衣裳", @"推位让国", @"有虞陶唐", nil];
    
    [self initTableView];// 初始化列表
}

// 初始化列表
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];// 去除多余的列表线条
    [self.view addSubview:self.tableView];
    [self.tableView setContentOffset:CGPointMake(0, -200)];
    
    self.scrollHeader = [[OXScrollHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    self.scrollHeader.headerScrollView = self.tableView;
    [self.tableView addObserver:self.scrollHeader forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.view addSubview:self.scrollHeader];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *SimpleCell = @"SimpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleCell];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 选中后取消选中的颜色
    
}

- (void)dealloc {
    [self.tableView removeObserver:self.scrollHeader forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

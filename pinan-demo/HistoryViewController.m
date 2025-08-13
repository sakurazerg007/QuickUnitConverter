//
//  HistoryViewController.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryManager.h"
#import "ConversionRecord.h"
#import "UnitConversionManager.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyStateView;
@property (nonatomic, strong) UILabel *emptyStateLabel;
@property (nonatomic, strong) NSArray<ConversionRecord *> *records;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNotifications];
    [self loadHistoryRecords];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadHistoryRecords];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"历史记录";
    
    // 设置导航栏右侧清空按钮
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(clearHistoryAction)];
    self.navigationItem.rightBarButtonItem = clearButton;
    
    [self setupTableView];
    [self setupEmptyStateView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    // 注册自定义cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
    
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)setupEmptyStateView {
    self.emptyStateView = [[UIView alloc] init];
    self.emptyStateView.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyStateView.backgroundColor = [UIColor systemBackgroundColor];
    self.emptyStateView.hidden = YES;
    [self.view addSubview:self.emptyStateView];
    
    // 空状态图标
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.translatesAutoresizingMaskIntoConstraints = NO;
    emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    emptyImageView.tintColor = [UIColor systemGrayColor];
    
    // 使用系统图标
    if (@available(iOS 13.0, *)) {
        emptyImageView.image = [UIImage systemImageNamed:@"clock.arrow.circlepath"];
    } else {
        // iOS 12 fallback
        emptyImageView.image = nil;
    }
    
    [self.emptyStateView addSubview:emptyImageView];
    
    // 空状态文本
    self.emptyStateLabel = [[UILabel alloc] init];
    self.emptyStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyStateLabel.text = @"暂无历史记录\n开始使用单位换算器吧！";
    self.emptyStateLabel.textColor = [UIColor secondaryLabelColor];
    self.emptyStateLabel.font = [UIFont systemFontOfSize:16.0];
    self.emptyStateLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyStateLabel.numberOfLines = 0;
    [self.emptyStateView addSubview:self.emptyStateLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.emptyStateView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.emptyStateView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.emptyStateView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.emptyStateView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        [emptyImageView.centerXAnchor constraintEqualToAnchor:self.emptyStateView.centerXAnchor],
        [emptyImageView.centerYAnchor constraintEqualToAnchor:self.emptyStateView.centerYAnchor constant:-30],
        [emptyImageView.widthAnchor constraintEqualToConstant:60],
        [emptyImageView.heightAnchor constraintEqualToConstant:60],
        
        [self.emptyStateLabel.topAnchor constraintEqualToAnchor:emptyImageView.bottomAnchor constant:20],
        [self.emptyStateLabel.leadingAnchor constraintEqualToAnchor:self.emptyStateView.leadingAnchor constant:40],
        [self.emptyStateLabel.trailingAnchor constraintEqualToAnchor:self.emptyStateView.trailingAnchor constant:-40]
    ]];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(historyDidUpdate:)
                                                 name:HistoryManagerDidUpdateNotification
                                               object:nil];
}

#pragma mark - Data Loading

- (void)loadHistoryRecords {
    self.records = [HistoryManager getAllRecords];
    [self updateUI];
}

- (void)updateUI {
    BOOL hasRecords = self.records.count > 0;
    
    self.tableView.hidden = !hasRecords;
    self.emptyStateView.hidden = hasRecords;
    self.navigationItem.rightBarButtonItem.enabled = hasRecords;
    
    if (hasRecords) {
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

- (void)clearHistoryAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清空历史记录"
                                                                   message:@"确定要清空所有历史记录吗？此操作不可撤销。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [HistoryManager clearAllRecords];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Notifications

- (void)historyDidUpdate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadHistoryRecords];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    ConversionRecord *record = self.records[indexPath.row];
    
    // 配置cell内容
    [self configureCell:cell withRecord:record];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withRecord:(ConversionRecord *)record {
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 创建主标题标签（换算内容）
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = [record formattedDisplayText];
    titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    // 创建副标题标签（时间和单位类型）
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *unitTypeName = [UnitConversionManager displayNameForUnitType:record.unitType];
    subtitleLabel.text = [NSString stringWithFormat:@"%@ • %@", unitTypeName, [record formattedTimeText]];
    subtitleLabel.font = [UIFont systemFontOfSize:14.0];
    subtitleLabel.textColor = [UIColor secondaryLabelColor];
    [cell.contentView addSubview:subtitleLabel];
    
    // 创建单位类型图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.tintColor = [UIColor systemBlueColor];
    
    // 设置图标
    if (@available(iOS 13.0, *)) {
        NSString *iconName = [UnitConversionManager iconNameForUnitType:record.unitType];
        iconImageView.image = [UIImage systemImageNamed:iconName];
    } else {
        // iOS 12 fallback
        iconImageView.image = nil;
    }
    
    [cell.contentView addSubview:iconImageView];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        // 图标约束
        [iconImageView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [iconImageView.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
        [iconImageView.widthAnchor constraintEqualToConstant:24],
        [iconImageView.heightAnchor constraintEqualToConstant:24],
        
        // 主标题约束
        [titleLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:12],
        [titleLabel.leadingAnchor constraintEqualToAnchor:iconImageView.trailingAnchor constant:12],
        [titleLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        
        // 副标题约束
        [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [subtitleLabel.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
        [subtitleLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-12]
    ]];
    
    // 设置cell样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor systemBackgroundColor];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConversionRecord *record = self.records[indexPath.row];
    
    // 显示详细信息
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"换算详情"
                                                                   message:[record formattedDisplayText]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 注意：当前HistoryManager不支持删除单条记录，这里只是预留接口
        // 如果需要支持单条删除，需要在HistoryManager中添加相应方法
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"当前版本不支持删除单条记录，请使用清空功能删除所有记录。"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
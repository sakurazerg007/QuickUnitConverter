//
//  MainViewController.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "MainViewController.h"
#import "UnitConversionManager.h"
#import "HistoryManager.h"
#import "ConversionViewController.h"
#import "HistoryViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *copyrightLabel;
@property (nonatomic, strong) NSArray<NSNumber *> *unitTypes;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self setupNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 刷新表格，更新历史记录按钮显示状态
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI Setup

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"单位转换器";
    
    // 设置导航栏样式
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor systemBackgroundColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
    
    [self setupTableView];
    [self setupCopyrightLabel];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 60.0;
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UnitTypeCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HistoryCell"];
    
    [self.view addSubview:self.tableView];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-60]
    ]];
}

- (void)setupCopyrightLabel {
    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.copyrightLabel.text = @"©2024 完全免费使用";
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    self.copyrightLabel.font = [UIFont systemFontOfSize:14.0];
    self.copyrightLabel.textColor = [UIColor secondaryLabelColor];
    
    [self.view addSubview:self.copyrightLabel];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.copyrightLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.copyrightLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.copyrightLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20],
        [self.copyrightLabel.heightAnchor constraintEqualToConstant:20]
    ]];
}

- (void)setupData {
    self.unitTypes = @[
        @(UnitTypeLength),
        @(UnitTypeWeight),
        @(UnitTypeTemperature),
        @(UnitTypeArea),
        @(UnitTypeVolume)
    ];
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(historyRecordsUpdated:)
                                                 name:@"HistoryRecordsUpdated"
                                               object:nil];
}

#pragma mark - Notification Handlers

- (void)historyRecordsUpdated:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // 单位分类 + 历史记录
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.unitTypes.count;
    } else {
        return [HistoryManager hasRecords] ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 单位分类cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitTypeCell" forIndexPath:indexPath];
        
        UnitType unitType = [self.unitTypes[indexPath.row] integerValue];
        NSString *iconName = [UnitConversionManager iconNameForUnitType:unitType];
        NSString *displayName = [UnitConversionManager displayNameForUnitType:unitType];
        
        // 设置图标
        if (@available(iOS 13.0, *)) {
            UIImage *icon = [UIImage systemImageNamed:iconName];
            cell.imageView.image = icon;
            cell.imageView.tintColor = [UIColor systemBlueColor];
        }
        
        cell.textLabel.text = displayName;
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor systemBackgroundColor];
        
        return cell;
    } else {
        // 历史记录cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
        
        // 设置图标
        if (@available(iOS 13.0, *)) {
            UIImage *icon = [UIImage systemImageNamed:@"clock.arrow.circlepath"];
            cell.imageView.image = icon;
            cell.imageView.tintColor = [UIColor systemOrangeColor];
        }
        
        NSInteger recordCount = [HistoryManager recordCount];
        cell.textLabel.text = [NSString stringWithFormat:@"历史记录 (%ld条)", (long)recordCount];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor systemBackgroundColor];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"选择单位类型";
    } else {
        return [HistoryManager hasRecords] ? @"" : nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 选择单位类型，进入换算页面
        UnitType unitType = [self.unitTypes[indexPath.row] integerValue];
        [self navigateToConversionPageWithUnitType:unitType];
    } else {
        // 进入历史记录页面
        [self navigateToHistoryPage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    } else {
        return [HistoryManager hasRecords] ? 20.0 : 0.0;
    }
}

#pragma mark - Navigation

- (void)navigateToConversionPageWithUnitType:(UnitType)unitType {
    ConversionViewController *conversionVC = [[ConversionViewController alloc] init];
    conversionVC.unitType = unitType;
    [self.navigationController pushViewController:conversionVC animated:YES];
}

- (void)navigateToHistoryPage {
    HistoryViewController *historyVC = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

@end
//
//  ConversionViewController.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "ConversionViewController.h"
#import "InputValidator.h"
#import "HistoryManager.h"
#import "ConversionRecord.h"

@interface ConversionViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

// UI Components
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *inputCardView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UILabel *inputUnitLabel;
@property (nonatomic, strong) UIView *resultCardView;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UILabel *resultUnitLabel;
@property (nonatomic, strong) UIPickerView *unitPickerView;

// Data
@property (nonatomic, strong) NSArray<NSString *> *availableUnits;
@property (nonatomic, assign) NSInteger selectedFromUnitIndex;
@property (nonatomic, assign) NSInteger selectedToUnitIndex;

// Timer for debouncing
@property (nonatomic, strong) NSTimer *debounceTimer;

@end

@implementation ConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupInitialValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateDebounceTimer];
}

- (void)dealloc {
    [self invalidateDebounceTimer];
}

#pragma mark - Setup

- (void)setupData {
    self.availableUnits = [UnitConversionManager unitsForType:self.unitType];
    self.selectedFromUnitIndex = 0;
    self.selectedToUnitIndex = self.availableUnits.count > 1 ? 1 : 0;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = [UnitConversionManager displayNameForUnitType:self.unitType];
    
    [self setupScrollView];
    [self setupInputCard];
    [self setupResultCard];
    [self setupUnitPicker];
    [self setupConstraints];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.backgroundColor = [UIColor systemBackgroundColor];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
}

- (void)setupInputCard {
    // 输入卡片容器
    self.inputCardView = [[UIView alloc] init];
    self.inputCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputCardView.backgroundColor = [UIColor systemBackgroundColor];
    self.inputCardView.layer.cornerRadius = 8.0;
    self.inputCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.inputCardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.inputCardView.layer.shadowOpacity = 0.1;
    self.inputCardView.layer.shadowRadius = 4.0;
    [self.contentView addSubview:self.inputCardView];
    
    // 输入框
    self.inputTextField = [[UITextField alloc] init];
    self.inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputTextField.placeholder = @"请输入数值";
    self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.inputTextField.font = [UIFont systemFontOfSize:17.0];
    self.inputTextField.textAlignment = NSTextAlignmentLeft;
    self.inputTextField.delegate = self;
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 添加长按手势支持剪贴板粘贴
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.inputTextField addGestureRecognizer:longPress];
    
    [self.inputCardView addSubview:self.inputTextField];
    
    // 输入单位标签
    self.inputUnitLabel = [[UILabel alloc] init];
    self.inputUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputUnitLabel.font = [UIFont systemFontOfSize:17.0];
    self.inputUnitLabel.textColor = [UIColor secondaryLabelColor];
    self.inputUnitLabel.textAlignment = NSTextAlignmentRight;
    [self.inputCardView addSubview:self.inputUnitLabel];
}

- (void)setupResultCard {
    // 结果卡片容器
    self.resultCardView = [[UIView alloc] init];
    self.resultCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultCardView.backgroundColor = [UIColor systemBlueColor];
    if (@available(iOS 13.0, *)) {
        self.resultCardView.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.1];
    }
    self.resultCardView.layer.cornerRadius = 8.0;
    [self.contentView addSubview:self.resultCardView];
    
    // 结果标签
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    self.resultLabel.textColor = [UIColor labelColor];
    self.resultLabel.textAlignment = NSTextAlignmentLeft;
    self.resultLabel.text = @"0";
    [self.resultCardView addSubview:self.resultLabel];
    
    // 结果单位标签
    self.resultUnitLabel = [[UILabel alloc] init];
    self.resultUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultUnitLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    self.resultUnitLabel.textColor = [UIColor secondaryLabelColor];
    self.resultUnitLabel.textAlignment = NSTextAlignmentRight;
    [self.resultCardView addSubview:self.resultUnitLabel];
}

- (void)setupUnitPicker {
    self.unitPickerView = [[UIPickerView alloc] init];
    self.unitPickerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.unitPickerView.dataSource = self;
    self.unitPickerView.delegate = self;
    [self.contentView addSubview:self.unitPickerView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // ScrollView
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        // ContentView
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
        
        // Input Card
        [self.inputCardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [self.inputCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.inputCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.inputCardView.heightAnchor constraintEqualToConstant:60],
        
        // Input TextField
        [self.inputTextField.leadingAnchor constraintEqualToAnchor:self.inputCardView.leadingAnchor constant:16],
        [self.inputTextField.centerYAnchor constraintEqualToAnchor:self.inputCardView.centerYAnchor],
        [self.inputTextField.trailingAnchor constraintEqualToAnchor:self.inputUnitLabel.leadingAnchor constant:-8],
        
        // Input Unit Label
        [self.inputUnitLabel.trailingAnchor constraintEqualToAnchor:self.inputCardView.trailingAnchor constant:-16],
        [self.inputUnitLabel.centerYAnchor constraintEqualToAnchor:self.inputCardView.centerYAnchor],
        [self.inputUnitLabel.widthAnchor constraintEqualToConstant:80],
        
        // Result Card
        [self.resultCardView.topAnchor constraintEqualToAnchor:self.inputCardView.bottomAnchor constant:20],
        [self.resultCardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.resultCardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.resultCardView.heightAnchor constraintEqualToConstant:60],
        
        // Result Label
        [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.resultCardView.leadingAnchor constant:16],
        [self.resultLabel.centerYAnchor constraintEqualToAnchor:self.resultCardView.centerYAnchor],
        [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.resultUnitLabel.leadingAnchor constant:-8],
        
        // Result Unit Label
        [self.resultUnitLabel.trailingAnchor constraintEqualToAnchor:self.resultCardView.trailingAnchor constant:-16],
        [self.resultUnitLabel.centerYAnchor constraintEqualToAnchor:self.resultCardView.centerYAnchor],
        [self.resultUnitLabel.widthAnchor constraintEqualToConstant:120],
        
        // Unit Picker
        [self.unitPickerView.topAnchor constraintEqualToAnchor:self.resultCardView.bottomAnchor constant:20],
        [self.unitPickerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.unitPickerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.unitPickerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20],
        [self.unitPickerView.heightAnchor constraintEqualToConstant:200]
    ]];
}

- (void)setupInitialValues {
    [self updateUnitLabels];
    [self.unitPickerView selectRow:self.selectedFromUnitIndex inComponent:0 animated:NO];
    [self.unitPickerView selectRow:self.selectedToUnitIndex inComponent:1 animated:NO];
}

#pragma mark - Actions

- (void)textFieldDidChange:(UITextField *)textField {
    [self scheduleConversion];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteboard.string && [InputValidator isValidNumber:pasteboard.string]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"粘贴剪贴板内容"
                                                                           message:[NSString stringWithFormat:@"是否粘贴: %@", pasteboard.string]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *pasteAction = [UIAlertAction actionWithTitle:@"粘贴" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.inputTextField.text = pasteboard.string;
                [self scheduleConversion];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:pasteAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Conversion Logic

- (void)scheduleConversion {
    [self invalidateDebounceTimer];
    
    // 0.5秒防抖处理
    self.debounceTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(performConversion)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)performConversion {
    NSString *inputText = self.inputTextField.text;
    
    if (!inputText || inputText.length == 0) {
        self.resultLabel.text = @"0";
        return;
    }
    
    if (![InputValidator isValidNumber:inputText]) {
        self.resultLabel.text = @"输入无效";
        return;
    }
    
    double inputValue = [InputValidator doubleValueFromString:inputText];
    NSString *fromUnit = self.availableUnits[self.selectedFromUnitIndex];
    NSString *toUnit = self.availableUnits[self.selectedToUnitIndex];
    
    double result = [UnitConversionManager convertValue:inputValue
                                               fromUnit:fromUnit
                                                 toUnit:toUnit
                                               unitType:self.unitType];
    
    self.resultLabel.text = [InputValidator formatNumber:result];
    
    // 保存到历史记录
    [self saveConversionRecord:inputValue result:result fromUnit:fromUnit toUnit:toUnit];
}

- (void)saveConversionRecord:(double)inputValue result:(double)result fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    ConversionRecord *record = [ConversionRecord recordWithUnitType:self.unitType
                                                           fromUnit:fromUnit
                                                             toUnit:toUnit
                                                         inputValue:inputValue
                                                        outputValue:result];
    [HistoryManager saveRecord:record];
}

- (void)updateUnitLabels {
    NSString *fromUnit = self.availableUnits[self.selectedFromUnitIndex];
    NSString *toUnit = self.availableUnits[self.selectedToUnitIndex];
    
    self.inputUnitLabel.text = [UnitConversionManager displayNameForUnit:fromUnit];
    self.resultUnitLabel.text = [UnitConversionManager displayNameForUnit:toUnit];
}

- (void)invalidateDebounceTimer {
    if (self.debounceTimer) {
        [self.debounceTimer invalidate];
        self.debounceTimer = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 限制输入长度为15字符
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![InputValidator isValidLength:newText maxLength:15]) {
        return NO;
    }
    
    // 验证字符有效性
    for (NSInteger i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (![InputValidator isValidNumberCharacter:character]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2; // 输入单位 + 输出单位
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.availableUnits.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *unit = self.availableUnits[row];
    NSString *prefix = component == 0 ? @"从: " : @"到: ";
    return [NSString stringWithFormat:@"%@%@", prefix, [UnitConversionManager displayNameForUnit:unit]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedFromUnitIndex = row;
    } else {
        self.selectedToUnitIndex = row;
    }
    
    [self updateUnitLabels];
    [self scheduleConversion];
}

@end
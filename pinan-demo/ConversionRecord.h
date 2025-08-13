//
//  ConversionRecord.h
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitConversionManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 换算记录数据模型
 */
@interface ConversionRecord : NSObject

@property (nonatomic, assign) UnitType unitType;        // 单位类型
@property (nonatomic, strong) NSString *fromUnit;      // 源单位
@property (nonatomic, strong) NSString *toUnit;        // 目标单位
@property (nonatomic, assign) double inputValue;       // 输入数值
@property (nonatomic, assign) double outputValue;      // 输出数值
@property (nonatomic, strong) NSDate *timestamp;       // 时间戳

/**
 * 便利构造器
 */
+ (instancetype)recordWithUnitType:(UnitType)unitType
                          fromUnit:(NSString *)fromUnit
                            toUnit:(NSString *)toUnit
                        inputValue:(double)inputValue
                       outputValue:(double)outputValue;

/**
 * 从字典创建记录
 */
+ (instancetype)recordFromDictionary:(NSDictionary *)dictionary;

/**
 * 转换为字典
 */
- (NSDictionary *)toDictionary;

/**
 * 获取格式化的显示文本
 */
- (NSString *)formattedDisplayText;

/**
 * 获取格式化的时间文本
 */
- (NSString *)formattedTimeText;

@end

NS_ASSUME_NONNULL_END
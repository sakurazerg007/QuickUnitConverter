//
//  UnitConversionManager.h
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 单位类型枚举
typedef NS_ENUM(NSInteger, UnitType) {
    UnitTypeLength = 0,     // 长度
    UnitTypeWeight,         // 重量
    UnitTypeTemperature,    // 温度
    UnitTypeArea,           // 面积
    UnitTypeVolume          // 体积
};

@interface UnitConversionManager : NSObject

/**
 * 单位换算方法
 * @param value 输入数值
 * @param fromUnit 源单位
 * @param toUnit 目标单位
 * @param type 单位类型
 * @return 换算结果
 */
+ (double)convertValue:(double)value
              fromUnit:(NSString *)fromUnit
                toUnit:(NSString *)toUnit
              unitType:(UnitType)type;

/**
 * 获取指定类型的所有单位列表
 * @param type 单位类型
 * @return 单位数组
 */
+ (NSArray<NSString *> *)unitsForType:(UnitType)type;

/**
 * 获取单位的显示名称
 * @param unit 单位代码
 * @return 显示名称
 */
+ (NSString *)displayNameForUnit:(NSString *)unit;

/**
 * 获取单位类型的显示名称
 * @param type 单位类型
 * @return 类型显示名称
 */
+ (NSString *)displayNameForUnitType:(UnitType)type;

/**
 * 获取单位类型的SF Symbol图标名称
 * @param type 单位类型
 * @return 图标名称
 */
+ (NSString *)iconNameForUnitType:(UnitType)type;

@end

NS_ASSUME_NONNULL_END
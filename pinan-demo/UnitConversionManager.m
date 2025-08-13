//
//  UnitConversionManager.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "UnitConversionManager.h"

@implementation UnitConversionManager

#pragma mark - 单位换算系数定义

// 长度换算 (以米为基准)
+ (NSDictionary *)lengthUnits {
    static NSDictionary *units = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        units = @{
            @"m": @1.0,
            @"km": @1000.0,
            @"ft": @0.3048,
            @"in": @0.0254,
            @"mile": @1609.34
        };
    });
    return units;
}

// 重量换算 (以克为基准)
+ (NSDictionary *)weightUnits {
    static NSDictionary *units = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        units = @{
            @"g": @1.0,
            @"kg": @1000.0,
            @"lb": @453.592,
            @"oz": @28.3495
        };
    });
    return units;
}

// 面积换算 (以平方米为基准)
+ (NSDictionary *)areaUnits {
    static NSDictionary *units = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        units = @{
            @"m²": @1.0,
            @"km²": @1000000.0,
            @"ft²": @0.092903,
            @"ha": @10000.0
        };
    });
    return units;
}

// 体积换算 (以升为基准)
+ (NSDictionary *)volumeUnits {
    static NSDictionary *units = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        units = @{
            @"L": @1.0,
            @"ml": @0.001,
            @"gal": @3.78541,
            @"ft³": @28.3168
        };
    });
    return units;
}

// 单位显示名称映射
+ (NSDictionary *)unitDisplayNames {
    static NSDictionary *names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @{
            // 长度
            @"m": @"米(m)",
            @"km": @"千米(km)",
            @"ft": @"英尺(ft)",
            @"in": @"英寸(in)",
            @"mile": @"英里(mile)",
            // 重量
            @"g": @"克(g)",
            @"kg": @"千克(kg)",
            @"lb": @"磅(lb)",
            @"oz": @"盎司(oz)",
            // 温度
            @"℃": @"摄氏度(℃)",
            @"℉": @"华氏度(℉)",
            @"K": @"开尔文(K)",
            // 面积
            @"m²": @"平方米(m²)",
            @"km²": @"平方千米(km²)",
            @"ft²": @"平方英尺(ft²)",
            @"ha": @"公顷(ha)",
            // 体积
            @"L": @"升(L)",
            @"ml": @"毫升(ml)",
            @"gal": @"加仑(gal)",
            @"ft³": @"立方英尺(ft³)"
        };
    });
    return names;
}

#pragma mark - 公共方法

+ (double)convertValue:(double)value
              fromUnit:(NSString *)fromUnit
                toUnit:(NSString *)toUnit
              unitType:(UnitType)type {
    
    if ([fromUnit isEqualToString:toUnit]) {
        return value;
    }
    
    switch (type) {
        case UnitTypeLength:
            return [self convertLengthValue:value fromUnit:fromUnit toUnit:toUnit];
        case UnitTypeWeight:
            return [self convertWeightValue:value fromUnit:fromUnit toUnit:toUnit];
        case UnitTypeTemperature:
            return [self convertTemperatureValue:value fromUnit:fromUnit toUnit:toUnit];
        case UnitTypeArea:
            return [self convertAreaValue:value fromUnit:fromUnit toUnit:toUnit];
        case UnitTypeVolume:
            return [self convertVolumeValue:value fromUnit:fromUnit toUnit:toUnit];
        default:
            return 0.0;
    }
}

+ (NSArray<NSString *> *)unitsForType:(UnitType)type {
    switch (type) {
        case UnitTypeLength:
            return @[@"m", @"km", @"ft", @"in", @"mile"];
        case UnitTypeWeight:
            return @[@"g", @"kg", @"lb", @"oz"];
        case UnitTypeTemperature:
            return @[@"℃", @"℉", @"K"];
        case UnitTypeArea:
            return @[@"m²", @"km²", @"ft²", @"ha"];
        case UnitTypeVolume:
            return @[@"L", @"ml", @"gal", @"ft³"];
        default:
            return @[];
    }
}

+ (NSString *)displayNameForUnit:(NSString *)unit {
    NSDictionary *names = [self unitDisplayNames];
    return names[unit] ?: unit;
}

+ (NSString *)displayNameForUnitType:(UnitType)type {
    switch (type) {
        case UnitTypeLength:
            return @"长度";
        case UnitTypeWeight:
            return @"重量";
        case UnitTypeTemperature:
            return @"温度";
        case UnitTypeArea:
            return @"面积";
        case UnitTypeVolume:
            return @"体积";
        default:
            return @"未知";
    }
}

+ (NSString *)iconNameForUnitType:(UnitType)type {
    switch (type) {
        case UnitTypeLength:
            return @"ruler";
        case UnitTypeWeight:
            return @"scalemass";
        case UnitTypeTemperature:
            return @"thermometer";
        case UnitTypeArea:
            return @"square.grid.3x3";
        case UnitTypeVolume:
            return @"cube";
        default:
            return @"questionmark";
    }
}

#pragma mark - 私有换算方法

+ (double)convertLengthValue:(double)value fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    NSDictionary *units = [self lengthUnits];
    NSNumber *fromFactor = units[fromUnit];
    NSNumber *toFactor = units[toUnit];
    
    if (!fromFactor || !toFactor) {
        return 0.0;
    }
    
    // 先转换为基准单位(米)，再转换为目标单位
    double baseValue = value * [fromFactor doubleValue];
    return baseValue / [toFactor doubleValue];
}

+ (double)convertWeightValue:(double)value fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    NSDictionary *units = [self weightUnits];
    NSNumber *fromFactor = units[fromUnit];
    NSNumber *toFactor = units[toUnit];
    
    if (!fromFactor || !toFactor) {
        return 0.0;
    }
    
    // 先转换为基准单位(克)，再转换为目标单位
    double baseValue = value * [fromFactor doubleValue];
    return baseValue / [toFactor doubleValue];
}

+ (double)convertTemperatureValue:(double)value fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    // 温度换算需要特殊处理，不能简单使用系数
    
    // 先转换为摄氏度
    double celsius = value;
    if ([fromUnit isEqualToString:@"℉"]) {
        celsius = (value - 32.0) * 5.0 / 9.0;
    } else if ([fromUnit isEqualToString:@"K"]) {
        celsius = value - 273.15;
    }
    
    // 再从摄氏度转换为目标单位
    if ([toUnit isEqualToString:@"℃"]) {
        return celsius;
    } else if ([toUnit isEqualToString:@"℉"]) {
        return celsius * 9.0 / 5.0 + 32.0;
    } else if ([toUnit isEqualToString:@"K"]) {
        return celsius + 273.15;
    }
    
    return 0.0;
}

+ (double)convertAreaValue:(double)value fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    NSDictionary *units = [self areaUnits];
    NSNumber *fromFactor = units[fromUnit];
    NSNumber *toFactor = units[toUnit];
    
    if (!fromFactor || !toFactor) {
        return 0.0;
    }
    
    // 先转换为基准单位(平方米)，再转换为目标单位
    double baseValue = value * [fromFactor doubleValue];
    return baseValue / [toFactor doubleValue];
}

+ (double)convertVolumeValue:(double)value fromUnit:(NSString *)fromUnit toUnit:(NSString *)toUnit {
    NSDictionary *units = [self volumeUnits];
    NSNumber *fromFactor = units[fromUnit];
    NSNumber *toFactor = units[toUnit];
    
    if (!fromFactor || !toFactor) {
        return 0.0;
    }
    
    // 先转换为基准单位(升)，再转换为目标单位
    double baseValue = value * [fromFactor doubleValue];
    return baseValue / [toFactor doubleValue];
}

@end
//
//  ConversionRecord.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "ConversionRecord.h"

@implementation ConversionRecord

+ (instancetype)recordWithUnitType:(UnitType)unitType
                          fromUnit:(NSString *)fromUnit
                            toUnit:(NSString *)toUnit
                        inputValue:(double)inputValue
                       outputValue:(double)outputValue {
    ConversionRecord *record = [[ConversionRecord alloc] init];
    record.unitType = unitType;
    record.fromUnit = fromUnit;
    record.toUnit = toUnit;
    record.inputValue = inputValue;
    record.outputValue = outputValue;
    record.timestamp = [NSDate date];
    return record;
}

+ (instancetype)recordFromDictionary:(NSDictionary *)dictionary {
    ConversionRecord *record = [[ConversionRecord alloc] init];
    record.unitType = [dictionary[@"unitType"] integerValue];
    record.fromUnit = dictionary[@"fromUnit"];
    record.toUnit = dictionary[@"toUnit"];
    record.inputValue = [dictionary[@"inputValue"] doubleValue];
    record.outputValue = [dictionary[@"outputValue"] doubleValue];
    
    // 处理时间戳
    id timestampObj = dictionary[@"timestamp"];
    if ([timestampObj isKindOfClass:[NSString class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        record.timestamp = [formatter dateFromString:timestampObj];
    } else if ([timestampObj isKindOfClass:[NSDate class]]) {
        record.timestamp = timestampObj;
    } else {
        record.timestamp = [NSDate date];
    }
    
    return record;
}

- (NSDictionary *)toDictionary {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    return @{
        @"unitType": @(self.unitType),
        @"fromUnit": self.fromUnit ?: @"",
        @"toUnit": self.toUnit ?: @"",
        @"inputValue": @(self.inputValue),
        @"outputValue": @(self.outputValue),
        @"timestamp": [formatter stringFromDate:self.timestamp]
    };
}

- (NSString *)formattedDisplayText {
    NSString *unitTypeName = [UnitConversionManager displayNameForUnitType:self.unitType];
    NSString *fromUnitName = [UnitConversionManager displayNameForUnit:self.fromUnit];
    NSString *toUnitName = [UnitConversionManager displayNameForUnit:self.toUnit];
    
    // 格式化数值，去除不必要的小数点
    NSString *inputStr = [self formatNumber:self.inputValue];
    NSString *outputStr = [self formatNumber:self.outputValue];
    
    return [NSString stringWithFormat:@"%@ %@ = %@ %@", inputStr, fromUnitName, outputStr, toUnitName];
}

- (NSString *)formattedTimeText {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    return [formatter stringFromDate:self.timestamp];
}

#pragma mark - 私有方法

- (NSString *)formatNumber:(double)number {
    // 如果是整数，不显示小数点
    if (number == (long)number) {
        return [NSString stringWithFormat:@"%.0f", number];
    }
    
    // 最多显示6位小数，去除末尾的0
    NSString *formatted = [NSString stringWithFormat:@"%.6f", number];
    
    // 去除末尾的0
    while ([formatted hasSuffix:@"0"] && [formatted containsString:@"."]) {
        formatted = [formatted substringToIndex:formatted.length - 1];
    }
    
    // 如果末尾是小数点，也去除
    if ([formatted hasSuffix:@"."]) {
        formatted = [formatted substringToIndex:formatted.length - 1];
    }
    
    return formatted;
}

@end
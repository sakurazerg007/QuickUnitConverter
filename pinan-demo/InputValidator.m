//
//  InputValidator.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "InputValidator.h"

@implementation InputValidator

+ (BOOL)isValidNumber:(NSString *)input {
    if (!input || input.length == 0) {
        return NO;
    }
    
    // 清理输入
    NSString *cleanedInput = [self cleanInput:input];
    
    if (cleanedInput.length == 0) {
        return NO;
    }
    
    // 使用NSScanner验证
    NSScanner *scanner = [NSScanner scannerWithString:cleanedInput];
    double value;
    
    // 扫描整个字符串，确保没有剩余字符
    return [scanner scanDouble:&value] && [scanner isAtEnd];
}

+ (double)doubleValueFromString:(NSString *)input {
    if (![self isValidNumber:input]) {
        return 0.0;
    }
    
    NSString *cleanedInput = [self cleanInput:input];
    return [cleanedInput doubleValue];
}

+ (NSString *)formatNumber:(double)number {
    // 处理特殊值
    if (isnan(number)) {
        return @"错误";
    }
    
    if (isinf(number)) {
        return number > 0 ? @"∞" : @"-∞";
    }
    
    // 如果数字过大或过小，使用科学计数法
    if (fabs(number) >= 1e12 || (fabs(number) <= 1e-6 && number != 0)) {
        return [self formatNumberWithScientificNotation:number];
    }
    
    // 如果是整数，不显示小数点
    if (number == (long long)number && fabs(number) < 1e15) {
        return [NSString stringWithFormat:@"%.0f", number];
    }
    
    // 格式化小数，最多显示8位有效数字
    NSString *formatted;
    if (fabs(number) >= 1) {
        // 大于等于1的数字，控制小数位数
        formatted = [NSString stringWithFormat:@"%.8f", number];
    } else {
        // 小于1的数字，使用更多小数位
        formatted = [NSString stringWithFormat:@"%.12f", number];
    }
    
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

+ (BOOL)isValidLength:(NSString *)input maxLength:(NSInteger)maxLength {
    return input.length <= maxLength;
}

+ (NSString *)cleanInput:(NSString *)input {
    if (!input) {
        return @"";
    }
    
    NSMutableString *cleaned = [NSMutableString string];
    BOOL hasDecimalPoint = NO;
    BOOL hasSign = NO;
    
    for (NSInteger i = 0; i < input.length; i++) {
        unichar character = [input characterAtIndex:i];
        
        // 允许数字
        if (character >= '0' && character <= '9') {
            [cleaned appendFormat:@"%C", character];
        }
        // 允许一个小数点
        else if (character == '.' && !hasDecimalPoint) {
            hasDecimalPoint = YES;
            [cleaned appendFormat:@"%C", character];
        }
        // 允许开头的正负号
        else if ((character == '+' || character == '-') && !hasSign && cleaned.length == 0) {
            hasSign = YES;
            [cleaned appendFormat:@"%C", character];
        }
    }
    
    return [cleaned copy];
}

+ (BOOL)isValidNumberCharacter:(unichar)character {
    // 数字字符
    if (character >= '0' && character <= '9') {
        return YES;
    }
    
    // 小数点
    if (character == '.') {
        return YES;
    }
    
    // 正负号
    if (character == '+' || character == '-') {
        return YES;
    }
    
    // 删除键（退格）
    if (character == 8) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)formatNumberWithScientificNotation:(double)number {
    // 使用科学计数法格式化
    NSString *scientific = [NSString stringWithFormat:@"%.3e", number];
    
    // 美化科学计数法显示
    NSArray *components = [scientific componentsSeparatedByString:@"e"];
    if (components.count == 2) {
        NSString *mantissa = components[0];
        NSString *exponent = components[1];
        
        // 去除尾数末尾的0
        while ([mantissa hasSuffix:@"0"] && [mantissa containsString:@"."]) {
            mantissa = [mantissa substringToIndex:mantissa.length - 1];
        }
        if ([mantissa hasSuffix:@"."]) {
            mantissa = [mantissa substringToIndex:mantissa.length - 1];
        }
        
        // 格式化指数
        NSInteger exp = [exponent integerValue];
        return [NSString stringWithFormat:@"%@×10^%ld", mantissa, (long)exp];
    }
    
    return scientific;
}

@end
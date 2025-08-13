//
//  InputValidator.h
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 输入数据验证器
 * 负责验证用户输入的数值有效性和格式化
 */
@interface InputValidator : NSObject

/**
 * 验证输入字符串是否为有效数字
 * @param input 输入字符串
 * @return YES表示有效，NO表示无效
 */
+ (BOOL)isValidNumber:(NSString *)input;

/**
 * 从字符串中提取数值
 * @param input 输入字符串
 * @return 数值，如果无效返回0.0
 */
+ (double)doubleValueFromString:(NSString *)input;

/**
 * 格式化数字为显示字符串
 * @param number 数字
 * @return 格式化后的字符串
 */
+ (NSString *)formatNumber:(double)number;

/**
 * 验证输入字符串长度是否在限制范围内
 * @param input 输入字符串
 * @param maxLength 最大长度
 * @return YES表示在范围内，NO表示超出范围
 */
+ (BOOL)isValidLength:(NSString *)input maxLength:(NSInteger)maxLength;

/**
 * 清理输入字符串，移除无效字符
 * @param input 原始输入
 * @return 清理后的字符串
 */
+ (NSString *)cleanInput:(NSString *)input;

/**
 * 验证是否为有效的数字字符
 * @param character 字符
 * @return YES表示有效，NO表示无效
 */
+ (BOOL)isValidNumberCharacter:(unichar)character;

/**
 * 格式化数字为科学计数法（当数字过大或过小时）
 * @param number 数字
 * @return 格式化后的字符串
 */
+ (NSString *)formatNumberWithScientificNotation:(double)number;

@end

NS_ASSUME_NONNULL_END
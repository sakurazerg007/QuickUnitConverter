//
//  HistoryManager.h
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversionRecord.h"

NS_ASSUME_NONNULL_BEGIN

// 通知常量
extern NSString * const HistoryManagerDidUpdateNotification;

/**
 * 历史记录管理器
 * 负责管理换算历史记录的存储和检索
 * 最多保存10条记录，采用先进先出策略
 */
@interface HistoryManager : NSObject

/**
 * 保存换算记录
 * @param record 换算记录
 */
+ (void)saveRecord:(ConversionRecord *)record;

/**
 * 获取最近的换算记录
 * @return 记录数组，按时间倒序排列
 */
+ (NSArray<ConversionRecord *> *)getRecentRecords;

/**
 * 获取所有记录
 * @return 记录数组，按时间倒序排列
 */
+ (NSArray<ConversionRecord *> *)getAllRecords;

/**
 * 清除所有记录
 */
+ (void)clearAllRecords;

/**
 * 检查是否有记录
 * @return YES表示有记录，NO表示无记录
 */
+ (BOOL)hasRecords;

/**
 * 获取记录数量
 * @return 当前记录数量
 */
+ (NSInteger)recordCount;

@end

NS_ASSUME_NONNULL_END
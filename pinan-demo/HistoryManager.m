//
//  HistoryManager.m
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import "HistoryManager.h"

// 通知常量定义
NSString * const HistoryManagerDidUpdateNotification = @"HistoryManagerDidUpdateNotification";

@implementation HistoryManager

// 存储键
static NSString *const kHistoryRecordsKey = @"ConversionHistory";
// 最大记录数量
static const NSInteger kMaxRecordCount = 10;

#pragma mark - 公共方法

+ (void)saveRecord:(ConversionRecord *)record {
    if (!record) {
        return;
    }
    
    // 异步保存，避免阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *records = [[self loadRecordsFromStorage] mutableCopy];
        
        // 添加新记录到数组开头
        [records insertObject:record atIndex:0];
        
        // 如果超过最大数量，移除最旧的记录（先进先出）
        while (records.count > kMaxRecordCount) {
            [records removeLastObject];
        }
        
        // 保存到本地存储
        [self saveRecordsToStorage:records];
        
        // 在主线程发送通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:HistoryManagerDidUpdateNotification object:nil];
        });
    });
}

+ (NSArray<ConversionRecord *> *)getRecentRecords {
    return [self loadRecordsFromStorage];
}

+ (NSArray<ConversionRecord *> *)getAllRecords {
    return [self loadRecordsFromStorage];
}

+ (void)clearAllRecords {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHistoryRecordsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HistoryManagerDidUpdateNotification object:nil];
}

+ (BOOL)hasRecords {
    return [self recordCount] > 0;
}

+ (NSInteger)recordCount {
    NSArray *records = [self loadRecordsFromStorage];
    return records.count;
}

#pragma mark - 私有方法

+ (NSArray<ConversionRecord *> *)loadRecordsFromStorage {
    NSArray *recordDictionaries = [[NSUserDefaults standardUserDefaults] arrayForKey:kHistoryRecordsKey];
    
    if (!recordDictionaries || recordDictionaries.count == 0) {
        return @[];
    }
    
    NSMutableArray *records = [NSMutableArray array];
    
    for (NSDictionary *dict in recordDictionaries) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            ConversionRecord *record = [ConversionRecord recordFromDictionary:dict];
            if (record) {
                [records addObject:record];
            }
        }
    }
    
    // 按时间倒序排列（最新的在前面）
    [records sortUsingComparator:^NSComparisonResult(ConversionRecord *obj1, ConversionRecord *obj2) {
        return [obj2.timestamp compare:obj1.timestamp];
    }];
    
    return [records copy];
}

+ (void)saveRecordsToStorage:(NSArray<ConversionRecord *> *)records {
    NSMutableArray *recordDictionaries = [NSMutableArray array];
    
    for (ConversionRecord *record in records) {
        NSDictionary *dict = [record toDictionary];
        if (dict) {
            [recordDictionaries addObject:dict];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:recordDictionaries forKey:kHistoryRecordsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
//
//  ConversionViewController.h
//  pinan-demo
//
//  Created by QuickUnitConverter on 2024/12/14.
//  Copyright © 2024 QuickUnitConverter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitConversionManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 换算操作页视图控制器
 * 支持实时单位换算、防抖处理、单位选择
 */
@interface ConversionViewController : UIViewController

@property (nonatomic, assign) UnitType unitType;

@end

NS_ASSUME_NONNULL_END
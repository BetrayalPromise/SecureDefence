//
//  NSObject+Aspect.h
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

@property (nonatomic, assign, readonly) BOOL isSafeKeyValue;

///  防御 KeyValue入参数异常崩溃
- (void)safeKeyValue;

/// 防御 发送到未知的选择子到实例
+ (void)safeGuardUnrecognizedSelector;

@end

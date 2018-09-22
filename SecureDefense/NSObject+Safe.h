//
//  NSObject+Aspect.h
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeKeyValue)

///  防御 KVC KVO 崩溃
@property (nonatomic, weak, readonly) id _Nullable safe;

/// 防御 发送到未知的选择子到实例
+ (void)safeGuardUnrecognizedSelector;

@end

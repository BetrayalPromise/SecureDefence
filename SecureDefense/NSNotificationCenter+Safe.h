//
//  NSNotificationCenter+SafeGuardRemove.h
//  SecureDefense_Example
//
//  Created by 李阳 on 20/9/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (SafeGuardRemove)

/// 可以不用 iOS9以后系统会自动移除
@property (nonatomic, weak, readonly) NSNotificationCenter * safe;

@end

NS_ASSUME_NONNULL_END

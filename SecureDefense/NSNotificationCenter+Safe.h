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

@property (nonatomic, assign, readonly) BOOL isSafeContainer;
/// ios9之后会自动移除可以不使用
- (void)safeContainer;

@end

NS_ASSUME_NONNULL_END

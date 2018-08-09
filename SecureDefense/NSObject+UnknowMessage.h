//
//  NSObject+Message.h
//  A
//
//  Created by LiChunYang on 4/6/2018.
//  Copyright © 2018 com.qmtv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UnknowMessage)

/// 防御 发送到未知的选择子到实例
+ (void)safeGuardUnrecognizedSelector;

@end

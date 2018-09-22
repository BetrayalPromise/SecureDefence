//
//  NSUserDefaults+Safe.m
//  Demo
//
//  Created by LiChunYang on 13/8/2018.
//  Copyright © 2018 com.qmtv. All rights reserved.
//

#import "NSUserDefaults+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSUserDefaults (Safe)

- (NSUserDefaults *)safe {
    if ([NSStringFromClass([self class]) hasPrefix:@"Safe"]) {
        return self;
    }
    NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
    Class kClass = objc_getClass([className UTF8String]);
    if (!kClass) {
        kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    }
    object_setClass(self, kClass);

    class_addMethod(kClass, @selector(objectForKey:), (IMP) safeObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectForKey:))));

    objc_registerClassPair(kClass);

    return self;
}

static inline id safeObjectForKey(id self, SEL _cmd, NSString * defaultName) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    id (*objc_msgSendToSuper)(const void *, SEL, NSString *) = (void *) objc_msgSendSuper;
    if (!defaultName) {
        NSLog(@"\"%@\"-value:(%@) can not be nil", NSStringFromSelector(_cmd), defaultName);
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, defaultName);
}

@end


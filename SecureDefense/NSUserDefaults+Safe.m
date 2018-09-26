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

- (void)setIsSafeUserDefaults:(BOOL)isSafeUserDefaults {
    objc_setAssociatedObject(self, @selector(isSafeUserDefaults), @(isSafeUserDefaults), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSafeUserDefaults {
    return objc_getAssociatedObject(self, _cmd) != nil ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)safeUserDefaults {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (!self.isSafeUserDefaults) {
        NSString *className = [NSString stringWithFormat:@"SafeUserDefaults__%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        class_addMethod(kClass, @selector(objectForKey:), (IMP) safeObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectForKey:))));
        class_addMethod(kClass, @selector(setObject:forKey:), (IMP) safeSetObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setObject:forKey:))));
        objc_registerClassPair(kClass);
        
        self.isSafeUserDefaults = YES;
    }
    dispatch_semaphore_signal(semaphore);
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

static inline void safeSetObjectForKey(id self, SEL _cmd, id value, NSString * defaultName) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, id, NSString *) = (void *) objc_msgSendSuper;
    if (!defaultName) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), defaultName);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, value, defaultName);
}

@end


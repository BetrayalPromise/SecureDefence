//
//  NSDictionary+Safe.m
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageCenter.h"
#import "NSDictionary+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMutableDictionary (Safe)

- (void)setIsSafeContainer:(BOOL)isSafeContainer {
    objc_setAssociatedObject(self, @selector(isSafeContainer), @(isSafeContainer), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSafeContainer {
    return objc_getAssociatedObject(self, _cmd) != nil ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (void)safeContainer {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (!self.isSafeContainer) {
        NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        
        class_addMethod(kClass, @selector(removeObjectForKey:), (IMP) safeRemoveObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectForKey:))));
        class_addMethod(kClass, @selector(setObject:forKey:), (IMP) safeSetObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setObject:forKey:))));
        
        objc_registerClassPair(kClass);
        self.isSafeContainer = YES;
    }
    dispatch_semaphore_signal(semaphore);
}

static void safeRemoveObjectForKey(id self, SEL _cmd, id key) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!key) {
        NSLog(@"\"%@\"-parameter0:(%@) cannot be nil", NSStringFromSelector(_cmd), key);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, key);
}

static void safeSetObjectForKey(id self, SEL _cmd, id anObject, id aKey) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, id, id) = (void *) objc_msgSendSuper;
    if (!anObject) {
        NSLog(@"\"%@\"-parameter0:(%@) cannot be nil", NSStringFromSelector(_cmd), anObject);
        return;
    }
    if (!aKey) {
        NSLog(@"\"%@\"-parameter1:(%@) cannot be nil", NSStringFromSelector(_cmd), aKey);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, anObject, aKey);
}


@end

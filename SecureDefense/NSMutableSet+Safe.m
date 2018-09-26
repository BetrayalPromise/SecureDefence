//
//  NSSet+Safe.m
//  Footstone
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageCenter.h"
#import "NSSet+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMutableSet (Safe)

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
        NSString *className = [NSString stringWithFormat:@"SafeMutableSet__%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        
        class_addMethod(kClass, @selector(addObject:), (IMP) safeAddObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(addObject:))));
        class_addMethod(kClass, @selector(removeObject:), (IMP) safeRemoveObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObject:))));
        
        objc_registerClassPair(kClass);
        self.isSafeContainer = YES;
    }
    dispatch_semaphore_signal(semaphore);
}

static void safeAddObject(id self, SEL _cmd, id object) {
    struct objc_super superObject = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendSuperCasted)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-object:%@ cannot be set nil", NSStringFromSelector(_cmd), object);
        return;
    }
    objc_msgSendSuperCasted(&superObject, _cmd, object);
}

static void safeRemoveObject(id self, SEL _cmd, id object) {
    struct objc_super superObject = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendSuperCasted)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-parameter0:(%@) cannot be nil", NSStringFromSelector(_cmd), object);
        return;
    }
    objc_msgSendSuperCasted(&superObject, _cmd, object);
}

@end

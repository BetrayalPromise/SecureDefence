//
//  NSArray+Aspect.m
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageCenter.h"
#import "NSPointerArray+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSPointerArray (Safe)

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
        NSString *className = [NSString stringWithFormat:@"SafePointerArray__%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        
        class_addMethod(kClass, @selector(pointerAtIndex:), (IMP) safePointerAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(pointerAtIndex:))));
        class_addMethod(kClass, @selector(removePointerAtIndex:), (IMP) safeRemovePointerAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removePointerAtIndex:))));
        class_addMethod(kClass, @selector(insertObject:atIndex:), (IMP) safeInsertPointerAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(insertObject:atIndex:))));
        class_addMethod(kClass, @selector(replacePointerAtIndex:withPointer:), (IMP) safeReplacePointerAtIndexWithPointer, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(replacePointerAtIndex:withPointer:))));
        objc_registerClassPair(kClass);
        self.isSafeContainer = YES;
    }
    dispatch_semaphore_signal(semaphore);
}

static void *safePointerAtIndex(id self, SEL _cmd, NSUInteger index) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, unsigned long) = (void *) objc_msgSendSuper;
    if (index >= [(NSPointerArray *) self count]) {
        NSLog(@"\"%@\" -index:(%lu) should less than %lu", NSStringFromSelector(_cmd), index, (unsigned long) [(NSPointerArray *) self count]);
        return NULL;
    }
    return objc_msgSendToSuper(&superClass, _cmd, index);
}

static void safeRemovePointerAtIndex(id self, SEL _cmd, NSUInteger index) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, NSUInteger) = (void *) objc_msgSendSuper;
    if (index >= [self count]) {
        NSLog(@"\"%@\" -index:(%lu) should less than %lu", NSStringFromSelector(_cmd), index, (unsigned long) [(NSPointerArray *) self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, index);
}

static void safeInsertPointerAtIndex(id self, SEL _cmd, void *item, NSUInteger index) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, void *, NSUInteger) = (void *) objc_msgSendSuper;
    if (index >= [self count]) {
        NSLog(@"\"%@\" -index:(%lu) should less than %lu", NSStringFromSelector(_cmd), index, (unsigned long) [(NSPointerArray *) self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, item, index);
}

static void safeReplacePointerAtIndexWithPointer(id self, SEL _cmd, NSUInteger index, void *item) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, void *, NSUInteger) = (void *) objc_msgSendSuper;
    if (index >= [self count]) {
        NSLog(@"\"%@\" -index:(%lu) should less than %lu", NSStringFromSelector(_cmd), index, (unsigned long) [(NSPointerArray *) self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, item, index);
}

@end

//
//  NSArray+Aspect.m
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageTrash.h"
#import "NSPointerArray+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSPointerArray (Safe)

- (NSPointerArray *)safe {
    if (!objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle))) {
        objc_setAssociatedObject(self, @selector(associatedObjectLifeCycle), [MessageTrash new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    if ([NSStringFromClass([self class]) hasPrefix:@"Safe"]) {
        return self;
    }
    NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
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
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageTrash new];
}

- (void)associatedObjectLifeCycle {
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

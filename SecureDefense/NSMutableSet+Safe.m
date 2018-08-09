//
//  NSSet+Safe.m
//  Footstone
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageTrash.h"
#import "NSSet+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMutableSet (Safe)

- (NSMutableSet<id> *)safe {
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

    class_addMethod(kClass, @selector(addObject:), (IMP) safeAddObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(addObject:))));
    class_addMethod(kClass, @selector(removeObject:), (IMP) safeRemoveObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObject:))));

    objc_registerClassPair(kClass);

    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageTrash new];
}

- (void)associatedObjectLifeCycle {
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

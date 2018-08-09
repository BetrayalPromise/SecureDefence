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

- (NSMutableDictionary<id, id> *)safe {
    if (!objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle))) {
        objc_setAssociatedObject(self, @selector(associatedObjectLifeCycle), [MessageCenter new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

    class_addMethod(kClass, @selector(removeObjectForKey:), (IMP) safeRemoveObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectForKey:))));
    class_addMethod(kClass, @selector(setObject:forKey:), (IMP) safeSetObjectForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setObject:forKey:))));

    objc_registerClassPair(kClass);
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageCenter new];
}

- (void)associatedObjectLifeCycle {
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

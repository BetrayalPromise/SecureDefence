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

@implementation NSSet (Safe)

- (NSSet<id> *)safe {
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
    class_addMethod(kClass, @selector(setByAddingObject:), (IMP) safeSetByAddingObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setByAddingObject:))));
    class_addMethod(kClass, @selector(setWithObject:), (IMP) safeSetWithObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setWithObject:))));

    objc_registerClassPair(kClass);
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageCenter new];
}

- (void)associatedObjectLifeCycle {
}

static NSSet<id> *safeSetByAddingObject(id self, SEL _cmd, id anObject) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    NSSet<id> *(*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!anObject) {
        NSLog(@"\"%@\"-anObject:%@ cannot be set nil", NSStringFromSelector(_cmd), anObject);
        return [NSSet new];
    }
    return objc_msgSendToSuper(&superClass, _cmd, anObject);
}

//+ (instancetype)setWithObject:(ObjectType)object {
//
//}

id safeSetWithObject(id self, SEL _cmd, id object) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    id (*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!object) {
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, object);
}

@end

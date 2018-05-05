//
//  NSSet+Safe.m
//  Footstone
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSSet+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MessageTrash.h"

@implementation NSMutableSet (Safe)

- (NSMutableSet <id> *)safe {
    if (!self.isSafe) {
        if (!objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle))) {
            objc_setAssociatedObject(self, @selector(associatedObjectLifeCycle), [MessageTrash new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
        Class kClass        = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);

        class_addMethod(kClass, @selector(addObject:), (IMP)safeAddObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(addObject:))));
        class_addMethod(kClass, @selector(removeObject:), (IMP)safeRemoveObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObject:))));

        objc_registerClassPair(kClass);

        self.isSafe = YES;
    }
    return self;
}

- (void)setIsSafe:(BOOL)isSafe {
    objc_setAssociatedObject(self, @selector(isSafe), @(isSafe), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSafe {
    return objc_getAssociatedObject(self, _cmd) != nil ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageTrash new];
}

- (void)associatedObjectLifeCycle {

}

static void safeAddObject(id self, SEL _cmd, id object) {
    struct objc_super superObject = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendSuperCasted)(const void *, SEL, id) = (void *)objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-object:%@ cannot be set nil", NSStringFromSelector(_cmd), object);
        return;
    }
    objc_msgSendSuperCasted(&superObject, _cmd, object);
}

static void safeRemoveObject(id self, SEL _cmd, id object) {
    struct objc_super superObject = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendSuperCasted)(const void *, SEL, id) = (void *)objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-parameter0:(%@) cannot be nil", NSStringFromSelector(_cmd), object);
        return;
    }
    objc_msgSendSuperCasted(&superObject, _cmd, object);
}

@end

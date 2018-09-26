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

@implementation NSDictionary (Safe)

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
        NSString *className = [NSString stringWithFormat:@"SafeDictionary__%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        
        class_addMethod(kClass, @selector(objectsForKeys:notFoundMarker:), (IMP) safeObjectsForKeysNotFoundMarker, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectsForKeys:notFoundMarker:))));
        
        objc_registerClassPair(kClass);
        self.isSafeContainer = YES;
    }
    dispatch_semaphore_signal(semaphore);
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageCenter new];
}

- (void)associatedObjectLifeCycle {
}

static NSArray<id> *safeObjectsForKeysNotFoundMarker(id self, SEL _cmd, NSArray<id> *keys, id marker) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, NSArray<id> *, id) = (void *) objc_msgSendSuper;
    if (!marker) {
        NSLog(@"\"%@\"-parameter1:(%@) cannot be nil", NSStringFromSelector(_cmd), marker);
        return nil;
    }
    return (__bridge NSArray<id> *) (objc_msgSendToSuper(&superClass, _cmd, keys, marker));
}

@end

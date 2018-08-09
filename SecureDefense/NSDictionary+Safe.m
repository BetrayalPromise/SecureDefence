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

- (NSDictionary<id, id> *)safe {
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

    class_addMethod(kClass, @selector(objectsForKeys:notFoundMarker:), (IMP) safeObjectsForKeysNotFoundMarker, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectsForKeys:notFoundMarker:))));

    objc_registerClassPair(kClass);

    return self;
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

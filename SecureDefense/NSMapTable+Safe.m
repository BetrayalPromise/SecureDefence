//
//  NSMapTable+Safe.m
//  a
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageCenter.h"
#import "NSMapTable+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMapTable (Safe)

- (NSMapTable<id, id> *)safe {
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


    objc_registerClassPair(kClass);

    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageCenter new];
}

- (void)associatedObjectLifeCycle {
}

@end

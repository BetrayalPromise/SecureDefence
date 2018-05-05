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

@implementation NSSet (Safe)

- (NSSet <id> *)safe {
    if (!self.isSafe) {
        NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
        Class kClass        = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);
        class_addMethod(kClass, @selector(setByAddingObject:), (IMP)safeSetByAddingObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setByAddingObject:))));

        objc_registerClassPair(kClass);
        self.isSafe = YES;
    }
    return self;
}

+ (void)safe {
    NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
    Class kClass        = objc_getClass([className UTF8String]);
    if (!kClass) {
        kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    }
    object_setClass(self, kClass);
    class_addMethod(kClass, @selector(setWithObject:), (IMP)safeSetWithObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setWithObject:))));

    objc_registerClassPair(kClass);

}

- (void)setIsSafe:(BOOL)isSafe {
    objc_setAssociatedObject(self, @selector(isSafe), @(isSafe), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSafe {
    return objc_getAssociatedObject(self, _cmd) != nil ? [objc_getAssociatedObject(self, _cmd) boolValue] : NO;
}

static NSSet<id> * safeSetByAddingObject(id self, SEL _cmd, id anObject) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    NSSet<id> * (*objc_msgSendToSuper)(const void *, SEL, id) = (void *)objc_msgSendSuper;
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
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    id (*objc_msgSendToSuper)(const void *, SEL, id) = (void *)objc_msgSendSuper;
    if (!object) {
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, object);
}

@end

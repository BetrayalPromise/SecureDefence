//
//  NSObject+Aspect.m
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSObject+Safe.h"
#import <objc/message.h>

@implementation NSObject (Aspect)

- (id)safe {
    if (!self.isSafe) {
        NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
        Class kClass        = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);

        class_addMethod(kClass, @selector(setValue:forKey:), (IMP)safeSetValueForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setValue:forKey:))));

        class_addMethod(kClass, @selector(valueForKey:), (IMP)safeValueForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(valueForKey:))));

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


- (nullable id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@) not found", NSStringFromSelector(_cmd), key);
    return nil;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@)  set %@ forKey %@ not found", NSStringFromSelector(_cmd), key, value, key);
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@) set nil for key %@", NSStringFromSelector(_cmd), key, key);
}

/// 处理 键值都为nil
void safeSetValueForKey(id self, SEL _cmd, id value, id key) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void * (*objc_msgSendToSuper)(const void *, SEL, id,  id) = (void *)objc_msgSendSuper;

    if (!value) {
        NSLog(@"\"%@\"-value:(%@) can not be nil", NSStringFromSelector(_cmd), value);
        return;
    }
    if (!key) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), key);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, value, key);
}

void * safeValueForKey(id self, SEL _cmd, id key) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void * (*objc_msgSendToSuper)(const void *, SEL, id) = (void *)objc_msgSendSuper;
    if (!key) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, key);
}

@end




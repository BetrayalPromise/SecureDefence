//
//  NSObject+Aspect.m
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSObject+SafeKeyValue.h"
#import <objc/message.h>

@implementation NSObject (SafeKeyValue)

- (id)safe {
    if ([NSStringFromClass([self class]) hasPrefix:@"Safe"]) {
        return self;
    }

    NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
    Class kClass = objc_getClass([className UTF8String]);
    if (!kClass) {
        kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    }
    object_setClass(self, kClass);

    class_addMethod(kClass, @selector(setValue:forKey:), (IMP) safeSetValueForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setValue:forKey:))));

    class_addMethod(kClass, @selector(valueForKey:), (IMP) safeValueForKey, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(valueForKey:))));

    objc_registerClassPair(kClass);

    return self;
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
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, id, id) = (void *) objc_msgSendSuper;

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

void *safeValueForKey(id self, SEL _cmd, id key) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!key) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, key);
}

+ (void)safeGuardKeyValue {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    Class cls = [self class];

    if (YES) {
        Method origMethod = class_getInstanceMethod(cls, @selector(setValue:forKey:));
        SEL origsel = @selector(setValue:forKey:);
        Method swizMethod = class_getInstanceMethod(cls, @selector(safe_valueForKey:));
        SEL swizsel = @selector(safe_valueForKey:);
        BOOL addMehtod = class_addMethod(cls, origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
        if (addMehtod) {
            class_replaceMethod(cls, swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, swizMethod);
        }
    }

    if (YES) {
        Method origMethod = class_getInstanceMethod(cls, @selector(setValue:forKey:));
        SEL origsel = @selector(setValue:forKey:);
        Method swizMethod = class_getInstanceMethod(cls, @selector(safe_valueForKey:));
        SEL swizsel = @selector(safe_valueForKey:);
        BOOL addMehtod = class_addMethod(cls, origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
        if (addMehtod) {
            class_replaceMethod(cls, swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, swizMethod);
        }
    }

    Method source = class_getClassMethod(self, _cmd);
    method_setImplementation(source, (IMP) instanceEmptyMethod);
    dispatch_semaphore_signal(semaphore);
}

- (void)safe_setValue:(id)value forKey:(NSString *)key {

}

- (id)safe_valueForKey:(NSString *)key {
    return nil;
}

static inline void instanceEmptyMethod(id self, SEL selector) {
    printf("+[%s %s]\n", NSStringFromClass(self).UTF8String, NSStringFromSelector(selector).UTF8String);
}

@end

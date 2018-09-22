//
//  NSObject+Aspect.m
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSObject+Safe.h"
#import <objc/message.h>
#import "MessageCenter.h"

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

+ (void)safeGuardUnrecognizedSelector {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (YES) {
        Class cls = [self class];
        Method origMethod = class_getInstanceMethod(cls, @selector(forwardingTargetForSelector:));
        SEL origsel = @selector(forwardingTargetForSelector:);
        Method swizMethod = class_getInstanceMethod(cls, @selector(instance_forwardingTargetForSelector:));
        SEL swizsel = @selector(instance_forwardingTargetForSelector:);
        BOOL addMehtod = class_addMethod(cls, origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
        if (addMehtod) {
            class_replaceMethod(cls, swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, swizMethod);
        }
    }
    if (YES) {
        Class metaCls = objc_getMetaClass(NSStringFromClass(self).UTF8String);
        Method origMethod = class_getClassMethod(metaCls, @selector(forwardingTargetForSelector:));
        SEL origsel = @selector(forwardingTargetForSelector:);
        Method swizMethod = class_getClassMethod(metaCls, @selector(class_forwardingTargetForSelector:));
        SEL swizsel = @selector(class_forwardingTargetForSelector:);
        BOOL addMehtod = class_addMethod(metaCls, origsel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
        if (addMehtod) {
            class_replaceMethod(metaCls, swizsel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, swizMethod);
        }
    }

    Method source = class_getClassMethod(self, _cmd);
    IMP imp = method_setImplementation(source, (IMP) classEmptyMethod);
    if (imp == NULL) {
        NSLog(@"!!!!!!!!!!");
    }
    dispatch_semaphore_signal(semaphore);
}

static inline void classEmptyMethod(id self, SEL selector) {
    printf("+[%s %s]\n", NSStringFromClass(self).UTF8String, NSStringFromSelector(selector).UTF8String);
}

- (id)instance_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signature) {
        return [self instance_forwardingTargetForSelector:aSelector];
    }
    return [MessageCenter instanceSource:[self class] selector:aSelector];
}

+ (id)class_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signature) {
        return [self class_forwardingTargetForSelector:aSelector];
    }
    return [MessageCenter classSource:[self class] selector:aSelector];
}

@end

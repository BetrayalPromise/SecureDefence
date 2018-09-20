//
//  NSNotificationCenter+SafeGuardRemove.m
//  SecureDefense_Example
//
//  Created by 李阳 on 20/9/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSNotificationCenter+SafeGuardRemove.h"
#import <objc/runtime.h>

@interface AssociatedRecord : NSObject

@end

@implementation AssociatedRecord {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter *)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

@implementation NSNotificationCenter (SafeGuardRemove)

+ (void)safeGuardRemove {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    Class cls = [self class];

    if (YES) {
        Method origMethod = class_getInstanceMethod(cls, @selector(addObserver:selector:name:object:));
        SEL origsel = @selector(addObserver:selector:name:object:);
        Method swizMethod = class_getInstanceMethod(cls, @selector(safe_addObserver:selector:name:object:));
        SEL swizsel = @selector(safe_addObserver:selector:name:object:);
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

static inline void instanceEmptyMethod(id self, SEL selector) {
    printf("+[%s %s]\n", NSStringFromClass(self).UTF8String, NSStringFromSelector(selector).UTF8String);
}

- (void)safe_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    addRecord(self, observer);
    [self safe_addObserver:observer selector:aSelector name:aName object:anObject];
}

void addRecord(NSNotificationCenter *center ,id obs) {
    AssociatedRecord *remover = nil;
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, @selector(associatedFunction));
        if (!remover) {
            remover = [[AssociatedRecord alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, @selector(associatedFunction), remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

- (void)associatedFunction {

}

@end

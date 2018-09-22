//
//  NSNotificationCenter+SafeGuardRemove.m
//  SecureDefense_Example
//
//  Created by 李阳 on 20/9/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSNotificationCenter+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>

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

- (NSNotificationCenter *)safe {
    if ([NSStringFromClass([self class]) hasPrefix:@"Safe"]) {
        return self;
    }
    NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
    Class kClass = objc_getClass([className UTF8String]);
    if (!kClass) {
        kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
    }
    object_setClass(self, kClass);

    class_addMethod(kClass, @selector(objectForKey:), (IMP) safeAddObserverSelectorNameObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(addObserver:selector:name:object:))));

    objc_registerClassPair(kClass);

    return self;
}

static void safeAddObserverSelectorNameObject(id self, SEL _cmd, id observer, SEL aSelector, NSNotificationName aName, id anObject) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (* objc_msgSendToSuper)(const void *, SEL, id, SEL, NSNotificationName, id) = (void *) objc_msgSendSuper;
    addRecord(self, observer);
    objc_msgSendToSuper(&superClass, _cmd, observer, aSelector, aName, anObject);
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

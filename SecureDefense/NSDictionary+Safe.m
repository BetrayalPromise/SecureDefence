//
//  NSDictionary+Safe.m
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSDictionary (Safe)

- (NSDictionary <id, id> *)safe {
    if (!self.isSafe) {
        NSString *className = [NSString stringWithFormat:@"Safe%@", [self class]];
        Class kClass        = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);

        class_addMethod(kClass, @selector(objectsForKeys:notFoundMarker:), (IMP)safeObjectsForKeysNotFoundMarker, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectsForKeys:notFoundMarker:))));

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

static NSArray <id> * safeObjectsForKeysNotFoundMarker(id self, SEL _cmd, NSArray<id> *keys, id marker) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void * (*objc_msgSendToSuper)(const void *, SEL, NSArray<id> *,  id) = (void *)objc_msgSendSuper;
    if (!marker) {
        NSLog(@"\"%@\"-parameter1:(%@) cannot be nil", NSStringFromSelector(_cmd), marker);
        return nil;
    }
    return (__bridge NSArray<id> *)(objc_msgSendToSuper(&superClass, _cmd, keys, marker));
}

@end




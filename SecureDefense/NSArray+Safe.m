//
//  NSArray+Aspect.m
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "MessageCenter.h"
#import "NSArray+Safe.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSArray (Safe)

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
        NSString *className = [NSString stringWithFormat:@"SafeArray__%@", [self class]];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
            objc_registerClassPair(kClass);
        }
        object_setClass(self, kClass);
        
        class_addMethod(kClass, @selector(objectAtIndex:), (IMP) safeObjectAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectAtIndex:))));
        class_addMethod(kClass, @selector(arrayByAddingObject:), (IMP) safeArrayByAddingObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(arrayByAddingObject:))));
        class_addMethod(kClass, @selector(indexOfObject:inRange:), (IMP) safeIndexOfObjectInRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(indexOfObject:inRange:))));
        class_addMethod(kClass, @selector(indexOfObjectIdenticalTo:inRange:), (IMP) safeIndexOfObjectIdenticalToInRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(indexOfObjectIdenticalTo:inRange:))));
        class_addMethod(kClass, @selector(objectsAtIndexes:), (IMP) safeObjectsAtIndexes, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectsAtIndexes:))));
        class_addMethod(kClass, @selector(objectAtIndexedSubscript:), (IMP) safeObjectAtIndexedSubscript, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(objectAtIndexedSubscript:))));
        class_addMethod(kClass, @selector(subarrayWithRange:), (IMP) safeSubarrayWithRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(subarrayWithRange:))));
        class_addMethod(kClass, @selector(enumerateObjectsAtIndexes:options:usingBlock:), (IMP) safeEnumerateObjectsAtIndexesOptionsUsingBlock,
                        method_getTypeEncoding(class_getInstanceMethod([self class], @selector(enumerateObjectsAtIndexes:options:usingBlock:))));
        class_addMethod(kClass, @selector(indexOfObjectAtIndexes:options:passingTest:), (IMP) safeIndexOfObjectAtIndexesOptionspassingTest,
                        method_getTypeEncoding(class_getInstanceMethod([self class], @selector(indexOfObjectAtIndexes:options:passingTest:))));
        class_addMethod(kClass, @selector(indexesOfObjectsAtIndexes:options:passingTest:), (IMP) safeIndexesOfObjectsAtIndexesOptionsPassingTest,
                        method_getTypeEncoding(class_getInstanceMethod([self class], @selector(indexesOfObjectsAtIndexes:options:passingTest:))));
        class_addMethod(kClass, @selector(indexOfObject:inSortedRange:options:usingComparator:), (IMP) safeIndexOfObjectInSortedRangeOptionsUsingComparator,
                        method_getTypeEncoding(class_getInstanceMethod([self class], @selector(indexOfObject:inSortedRange:options:usingComparator:))));
        self.isSafeContainer = YES;
    }
    dispatch_semaphore_signal(semaphore);
}

static void *safeObjectAtIndex(id self, SEL _cmd, unsigned long index) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, unsigned long) = (void *) objc_msgSendSuper;
    if (index < [(NSArray *) self count]) {
        return objc_msgSendToSuper(&superClass, _cmd, index);
    } else {
        NSLog(@"\"%@\" -index:(%lu) should less than %lu", NSStringFromSelector(_cmd), index, (unsigned long) [(NSArray *) self count]);
        return nil;
    }
}

static void *safeArrayByAddingObject(id self, SEL _cmd, id object) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (object != nil) {
        return objc_msgSendToSuper(&superClass, _cmd, object);
    } else {
        NSLog(@"\"%@\" -object:%@ cannot be set nil", NSStringFromSelector(_cmd), object);
        return nil;
    }
}

static long safeIndexOfObjectInRange(id self, SEL _cmd, id object, NSRange range) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    long (*objc_msgSendToSuper)(const void *, SEL, id, NSRange) = (void *) objc_msgSendSuper;

    if (!object) {
        NSLog(@"\"%@\" -object:%@ cannot be set nil", NSStringFromSelector(_cmd), object);
        return LONG_MAX;
    }

    if (range.location + range.length <= ((NSArray *) self).count) {
        return objc_msgSendToSuper(&superClass, _cmd, object, range);
    } else {
        NSLog(@"\"%@\"-range:%@ should be at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long) [(NSArray *) self count]);
        return LONG_MAX;
    }
}

static long safeIndexOfObjectIdenticalToInRange(id self, SEL _cmd, id object, NSRange range) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    long (*objc_msgSendToSuper)(const void *, SEL, id, NSRange) = (void *) objc_msgSendSuper;
    if (range.location + range.length <= ((NSArray *) self).count) {
        return objc_msgSendToSuper(&superClass, _cmd, object, range);
    } else {
        NSLog(@"\"%@\"-range:%@ must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long) [(NSArray *) self count]);
        return LONG_MAX;
    }
}

static void *safeObjectsAtIndexes(id self, SEL _cmd, NSIndexSet *indexes) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, id) = (void *) objc_msgSendSuper;
    if (!indexes) {
        NSLog(@"\"%@\"-indexes:%@ cannot be set nil", NSStringFromSelector(_cmd), indexes);
        return nil;
    } else {
        __block BOOL isPass = YES;
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
            if (isPass) {
                if (idx < [(NSArray *) self count]) {
                    isPass = YES;
                } else {
                    isPass = NO;
                }
            }
        }];
        if (!isPass) {
            NSLog(@"\"%@\"-indexes:%@ should be set at range [0, %lu)", NSStringFromSelector(_cmd), indexes, [(NSArray *) self count]);
            return nil;
        }
        return objc_msgSendToSuper(&superClass, _cmd, indexes);
    }
}

static void *safeObjectAtIndexedSubscript(id self, SEL _cmd, unsigned long index) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, unsigned long) = (void *) objc_msgSendSuper;
    if (index < [(NSArray *) self count]) {
        return objc_msgSendToSuper(&superClass, _cmd, index);
    } else {
        NSLog(@"\"%@\"-index:(%lu) should be at range [0, %lu)", NSStringFromSelector(_cmd), index, (unsigned long) [(NSArray *) self count]);
        return nil;
    }
}

static NSArray<id> *safeSubarrayWithRange(id self, SEL _cmd, NSRange range) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void *(*objc_msgSendToSuper)(const void *, SEL, NSRange) = (void *) objc_msgSendSuper;
    if (range.location + range.length <= [(NSArray *) self count]) {
        return (__bridge NSArray<id> *) (objc_msgSendToSuper(&superClass, _cmd, range));
    } else {
        NSLog(@"\"%@\"-index:%@ must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long) [(NSArray *) self count]);
        return nil;
    }
}

static void safeEnumerateObjectsAtIndexesOptionsUsingBlock(id self, SEL _cmd, NSIndexSet *s, NSEnumerationOptions opts, void (*block)(id obj, NSUInteger idx, BOOL *stop)) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    void (*objc_msgSendToSuper)(const void *, SEL, NSIndexSet *, NSEnumerationOptions, void (*)(id, NSUInteger, BOOL *)) = (void *) objc_msgSendSuper;
    __block BOOL isPass = YES;
    [s enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
        if (isPass) {
            if (idx < [(NSArray *) self count]) {
                isPass = YES;
            } else {
                isPass = NO;
            }
        }
    }];
    if (!isPass) {
        NSLog(@"\"%@\"-indexes:%@ should be set at range [0, %lu)", NSStringFromSelector(_cmd), s, [(NSArray *) self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, s, opts, block);
}

static NSUInteger safeIndexOfObjectAtIndexesOptionspassingTest(id self, SEL _cmd, NSIndexSet *s, NSEnumerationOptions opts, void (*block)(id obj, NSUInteger idx, BOOL *stop)) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    NSUInteger (*objc_msgSendToSuper)(const void *, SEL, NSIndexSet *, NSEnumerationOptions, void (*)(id, NSUInteger, BOOL *)) = (void *) objc_msgSendSuper;
    __block BOOL isPass = YES;
    [s enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
        if (isPass) {
            if (idx < [(NSArray *) self count]) {
                isPass = YES;
            } else {
                isPass = NO;
            }
        }
    }];
    if (!isPass) {
        NSLog(@"\"%@\"-indexes:%@ should be set at range [0, %lu)", NSStringFromSelector(_cmd), s, [(NSArray *) self count]);
        return MAXFLOAT;
    }
    return objc_msgSendToSuper(&superClass, _cmd, s, opts, block);
}

static NSIndexSet *safeIndexesOfObjectsAtIndexesOptionsPassingTest(id self, SEL _cmd, NSIndexSet *s, NSEnumerationOptions opts, void (*block)(id obj, NSUInteger idx, BOOL *stop)) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    NSIndexSet *(*objc_msgSendToSuper)(const void *, SEL, NSIndexSet *, NSEnumerationOptions, void (*)(id, NSUInteger, BOOL *)) = (void *) objc_msgSendSuper;
    __block BOOL isPass = YES;
    [s enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop) {
        if (isPass) {
            if (idx < [(NSArray *) self count]) {
                isPass = YES;
            } else {
                isPass = NO;
            }
        }
    }];
    if (!isPass) {
        NSLog(@"\"%@\"-indexes:%@ should be set at range [0, %lu)", NSStringFromSelector(_cmd), s, [(NSArray *) self count]);
        return nil;
    }
    return objc_msgSendToSuper(&superClass, _cmd, s, opts, block);
}

static NSUInteger safeIndexOfObjectInSortedRangeOptionsUsingComparator(id self, SEL _cmd, id obj, NSRange r, NSBinarySearchingOptions opts, NSComparator cmp) {
    struct objc_super superClass = {.receiver = self, .super_class = class_getSuperclass(object_getClass(self))};
    NSUInteger (*objc_msgSendToSuper)(const void *, SEL, id, NSRange, NSBinarySearchingOptions, NSComparator) = (void *) objc_msgSendSuper;
    if (r.location + r.length > [(NSArray *) self count]) {
        NSLog(@"\"%@\"-range:%@ should be set at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(r), [(NSArray *) self count]);
        return MAXFLOAT;
    }
    return objc_msgSendToSuper(&superClass, _cmd, obj, r, opts, cmp);
}


@end

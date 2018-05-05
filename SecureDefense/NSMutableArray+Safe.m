//
//  NSArray+Aspect.m
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSArray+Safe.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MessageTrash.h"

@implementation NSMutableArray (Safe)

- (NSMutableArray <id> *)safe {
    if (!self.isSafe) {
        if (!objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle))) {
            objc_setAssociatedObject(self, @selector(associatedObjectLifeCycle), [MessageTrash new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        NSString * className = [NSString stringWithFormat:@"Safe%@",self.class];
        Class kClass = objc_getClass([className UTF8String]);
        if (!kClass) {
            kClass = objc_allocateClassPair([self class], [className UTF8String], 0);
        }
        object_setClass(self, kClass);

        class_addMethod(kClass, @selector(insertObject:atIndex:), (IMP)safeInsertObjectAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(insertObject:atIndex:))));
        class_addMethod(kClass, @selector(removeObjectAtIndex:), (IMP)safeRemoveObjectAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectAtIndex:))));
        class_addMethod(kClass, @selector(replaceObjectAtIndex:withObject:), (IMP)safeReplaceObjectAtIndexWithObject, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(replaceObjectAtIndex:withObject:))));
        class_addMethod(kClass, @selector(exchangeObjectAtIndex:withObjectAtIndex:), (IMP)safeExchangeObjectAtIndexWithObjectAtIndex, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(exchangeObjectAtIndex:withObjectAtIndex:))));
        class_addMethod(kClass, @selector(removeObject:inRange:), (IMP)safeRemoveObjectInRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(exchangeObjectAtIndex:withObjectAtIndex:))));
        class_addMethod(kClass, @selector(removeObjectIdenticalTo:inRange:), (IMP)safeRemoveObjectIdenticalToInRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectIdenticalTo:inRange:))));
        class_addMethod(kClass, @selector(removeObjectsInRange:), (IMP)safeRemoveObjectsInRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectsInRange:))));
        class_addMethod(kClass, @selector(replaceObjectsInRange:withObjectsFromArray:range:), (IMP)safeReplaceObjectsInRangeWithObjectsFromArrayRange, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(replaceObjectsInRange:withObjectsFromArray:range:))));
        class_addMethod(kClass, @selector(replaceObjectsInRange:withObjectsFromArray:), (IMP)safeReplaceObjectsInRangeWithObjectsFromArray, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(replaceObjectsInRange:withObjectsFromArray:))));
        class_addMethod(kClass, @selector(insertObjects:atIndexes:), (IMP)safeInsertObjectsAtIndexes, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(insertObjects:atIndexes:))));
        class_addMethod(kClass, @selector(removeObjectsAtIndexes:), (IMP)safeRemoveObjectsAtIndexes, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(removeObjectsAtIndexes:))));
        class_addMethod(kClass, @selector(replaceObjectsAtIndexes:withObjects:), (IMP)safeReplaceObjectsAtIndexesWithObjects, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(replaceObjectsAtIndexes:withObjects:))));
        class_addMethod(kClass, @selector(setObject:atIndexedSubscript:), (IMP)safeSetObjectAtIndexedSubscript, method_getTypeEncoding(class_getInstanceMethod([self class], @selector(setObject:atIndexedSubscript:))));

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

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) != nil ? objc_getAssociatedObject(self, @selector(associatedObjectLifeCycle)) : [MessageTrash new];
}

- (void)associatedObjectLifeCycle {

}

static void safeInsertObjectAtIndex(id self, SEL _cmd, id object, unsigned long index) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };

    void (*objc_msgSendToSuper)(const void *, SEL, id, unsigned long) = (void *)objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-object:(%@) is nil", NSStringFromSelector(_cmd), object);
        return;
    }
    if (index > [(NSArray*)self count]) {
        NSLog(@"\"%@\"-index:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index, (unsigned long)[(NSArray*)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, object, index);
}

static void safeRemoveObjectAtIndex(id self, SEL _cmd, unsigned long index) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, unsigned long) = (void *)objc_msgSendSuper;
    if (index < [(NSArray*)self count]) {
        objc_msgSendToSuper(&superClass, _cmd, index);
    } else {
        NSLog(@"\"%@\"-index:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index, (unsigned long)[(NSArray *)self count]);
    }
}

static void safeReplaceObjectAtIndexWithObject(id self, SEL _cmd, unsigned long index, id object) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, unsigned long, id) = (void *)objc_msgSendSuper;
    if (!object) {
        NSLog(@"\"%@\"-object%@ must be not equal to nil", NSStringFromSelector(_cmd), object);
        return;
    }
    if (index > [(NSArray*)self count]) {
        NSLog(@"\"%@\"-index:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index, (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, index, object);
}

static void safeExchangeObjectAtIndexWithObjectAtIndex(id self, SEL _cmd, unsigned long index1, unsigned long index2) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, unsigned long, unsigned long) = (void *)objc_msgSendSuper;
    if (index1 >= [(NSArray *)self count]) {
        NSLog(@"\"%@\"-index1:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index1, (unsigned long)[(NSArray *)self count]);
        return;
    }
    if (index2 >= [(NSArray *)self count]) {
        NSLog(@"\"%@\"-index2:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index2, (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, index1, index2);
}

static void safeRemoveObjectInRange(id self, SEL _cmd, id object, NSRange range) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, id, NSRange) = (void *)objc_msgSendSuper;

    if (range.location + range.length > [(NSArray *)self count]) {
        NSLog(@"\"%@\"-range:%@ must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, object, range);
}

static void safeRemoveObjectIdenticalToInRange(id self, SEL _cmd, id object, NSRange range) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, id, NSRange) = (void *)objc_msgSendSuper;

    if (range.location + range.length > [(NSArray *)self count]) {
        NSLog(@"\"%@\"-range:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, object, range);
}

static void safeRemoveObjectsInRange(id self, SEL _cmd, NSRange range) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSRange) = (void *)objc_msgSendSuper;
    if (range.location + range.length > [(NSArray *)self count]) {
        NSLog(@"\"%@\"-range:(%@) should be at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, range);
}

static void safeReplaceObjectsInRangeWithObjectsFromArrayRange(id self, SEL _cmd, NSRange range, NSArray <id> * otherArray, NSRange otherRange) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSRange, NSArray <id> *, NSRange) = (void *)objc_msgSendSuper;
    if (range.location + range.length > [(NSArray *)self count]) {
        NSLog(@"\"%@\"-parameter0:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]);
        return;
    }
    if (otherRange.location + otherRange.length > [otherArray count]) {
        NSLog(@"\"%@\"-parameter3:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(otherRange), (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, range, otherArray, otherRange);
}

static void safeReplaceObjectsInRangeWithObjectsFromArray(id self, SEL _cmd, NSRange range, NSArray <id> *otherArray) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSRange, NSArray <id> *) = (void *)objc_msgSendSuper;
    if (range.location + range.length > [(NSArray *)self count]) {
        NSLog(@"\"%@\"-parameter0:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, range, otherArray);
}

static void safeInsertObjectsAtIndexes(id self, SEL _cmd, NSArray <id> * objects, NSIndexSet * indexes) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSArray <id> *, NSIndexSet *) = (void *)objc_msgSendSuper;
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSLog(@"\"%@\"-parameter0:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, objects, indexes);
}

static void safeRemoveObjectsAtIndexes(id self, SEL _cmd, NSIndexSet *indexes) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSIndexSet *) = (void *)objc_msgSendSuper;
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSLog(@"\"%@\"-parameter0:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, indexes);
}

static void safeReplaceObjectsAtIndexesWithObjects(id self, SEL _cmd, NSIndexSet *indexes, NSArray<id> *objects) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, NSIndexSet * indexes, NSArray<id> * objects) = (void *)objc_msgSendSuper;
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSLog(@"\"%@\"-parameter0:(%@) must at range [0, %lu)", NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, indexes, objects);
}

static void safeSetObjectAtIndexedSubscript(id self, SEL _cmd, id obj, NSUInteger idx) {
    struct objc_super superClass = {
        .receiver    = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendToSuper)(const void *, SEL, id, NSUInteger) = (void *)objc_msgSendSuper;
    if (idx > [(NSMutableArray *)self count]) {
        NSLog(@"\"%@\"-idx:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), idx, (unsigned long)[(NSArray *)self count]);
        return;
    }
    if (!obj) {
        NSLog(@"\"%@\"-obj:%@ cannot be set nil", NSStringFromSelector(_cmd), obj);
        return;
    }
    objc_msgSendToSuper(&superClass, _cmd, obj, idx);
}

@end





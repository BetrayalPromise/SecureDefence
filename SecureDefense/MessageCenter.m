//
//  MessageCenter.m
//  PersistentStorageUsage
//
//  Created by 李阳 on 3/5/2016.
//  Copyright © 2016 TuoErJia. All rights reserved.
//

#import "MessageCenter.h"
#import <objc/runtime.h>

@implementation MessageCenter

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static MessageCenter * instance = nil;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

static inline void instanceRealizationFunction(id obj, SEL _cmd) {

}

static inline void classRealizationFunction(id obj, SEL _cmd) {

}

+ (instancetype)instanceSource:(Class)source selector:(SEL)selector {
    MessageCenter *mt = [MessageCenter new];
    class_addMethod(self, selector, (IMP) instanceRealizationFunction, "v@:");
#ifdef DEBUG
    NSLog(@"unrecognized instance selector: -[%@ %@]", source, NSStringFromSelector(selector));
#endif
    return mt;
}

+ (instancetype)classSource:(Class)source selector:(SEL)selector {
    MessageCenter *mt = [MessageCenter new];
    class_addMethod(objc_getMetaClass(NSStringFromClass(self).UTF8String), selector, (IMP) classRealizationFunction, "v@:");
#ifdef DEBUG
    NSLog(@"unrecognized class selector: -[%@ %@]", source, NSStringFromSelector(selector));
#endif
    return mt;
}

@end

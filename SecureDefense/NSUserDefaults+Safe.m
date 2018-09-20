//
//  NSUserDefaults+Safe.m
//  Demo
//
//  Created by LiChunYang on 13/8/2018.
//  Copyright © 2018 com.qmtv. All rights reserved.
//

#import "NSUserDefaults+Safe.h"
#import <objc/runtime.h>

@interface SafeUserDefaults: NSUserDefaults

@end

@implementation SafeUserDefaults

- (id)objectForKey:(NSString *)defaultName {
    if (defaultName) {
        return [super objectForKey:defaultName];
    }
    return nil;
}

@end

@implementation NSUserDefaults (Safe)

+ (void)safeGuideUserDefaults {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    object_setClass([NSUserDefaults standardUserDefaults], [SafeUserDefaults class]);

    Method source = class_getClassMethod(self, _cmd);
    method_setImplementation(source, (IMP) classEmptyMethod);
    dispatch_semaphore_signal(semaphore);
}

static inline void classEmptyMethod(id self, SEL selector) {
    printf("+[%s %s]\n", NSStringFromClass(self).UTF8String, NSStringFromSelector(selector).UTF8String);
}

@end


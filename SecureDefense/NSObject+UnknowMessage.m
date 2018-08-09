//
//  NSObject+Message.m
//  A
//
//  Created by LiChunYang on 4/6/2018.
//  Copyright © 2018 com.qmtv. All rights reserved.
//

#import "MessageCenter.h"
#import "NSObject+UnknowMessage.h"
#import <objc/message.h>

@implementation NSObject (UnknowMessage)

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    NSString * selString = NSStringFromSelector([anInvocation selector]);
//    NSString * clsString = NSStringFromClass([self class]);
//    MessageTrash * mt = [MessageTrash new];
//    [anInvocation setTarget:mt];
//    [anInvocation setArgument:&clsString atIndex:2];
//    [anInvocation setArgument:&selString atIndex:3];
//    [anInvocation invokeWithTarget:mt];
//}
//#pragma clang diagnostic pop
//
//- (NSMethodSignature *)exchange_methodSignatureForSelector:(SEL)aSelector {
//    if ([[self class] belongsRelation] == BundleTypeSystem) {
//        return [self exchange_methodSignatureForSelector:aSelector];
//    }
//    return [NSMethodSignature signatureWithObjCTypes:"v@:@@"];
//}

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

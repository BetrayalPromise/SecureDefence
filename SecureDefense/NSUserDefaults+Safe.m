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
    object_setClass([NSUserDefaults standardUserDefaults], [SafeUserDefaults class]);
}

@end


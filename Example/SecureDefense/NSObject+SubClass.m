//
//  NSObject+SubClass.m
//  SecureDefense_Example
//
//  Created by LiChunYang on 6/6/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSObject+SubClass.h"
#import <objc/message.h>
#import <pthread.h>

@implementation NSObject (SubClass)

+ (NSArray<Class> *)findSubClass {
    int count = objc_getClassList(NULL, 0);
    if (count <= 0) {
        return @[];
    }
    NSMutableArray *subClassesArray = [NSMutableArray arrayWithObject:self];
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    for (NSUInteger i = 0; i < count; i++) {
        if (self == class_getSuperclass(classes[i])) {
            pthread_mutex_lock(&mutex);
            [subClassesArray addObject:classes[i]];
            pthread_mutex_unlock(&mutex);
        }
    }
    pthread_mutex_destroy(&mutex);
    free(classes);
    return subClassesArray;
}

@end

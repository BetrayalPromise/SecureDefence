#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+Safe.h"
#import "NSDictionary+Safe.h"
#import "NSHashTable+Safe.h"
#import "NSMapTable+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSMutableSet+Safe.h"
#import "NSObject+Safe.h"
#import "NSPointerArray+Safe.h"
#import "NSSet+Safe.h"
#import "SecureDefense.h"

FOUNDATION_EXPORT double SecureDefenseVersionNumber;
FOUNDATION_EXPORT const unsigned char SecureDefenseVersionString[];


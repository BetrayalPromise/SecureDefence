//
//  NSHashTable+Safe.h
//  a
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

/// NSHashTable可以添加nil
@interface NSHashTable <T> (Safe)

@property (nonatomic, weak, readonly) NSHashTable <T> * safe;
@property (nonatomic, assign, readonly) BOOL isSafe;

@end

//
//  NSMapTable+Safe.h
//  a
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable <K, V> (Safe)

@property (nonatomic, weak, readonly) NSMapTable <K, V> * safe;
@property (nonatomic, assign, readonly) BOOL isSafe;

@end

//
//  NSSet+Safe.h
//  Footstone
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet <T> (Safe)

@property (nonatomic, weak, readonly) NSMutableSet <T> * safe;
@property (nonatomic, assign, readonly) BOOL isSafe;

@end

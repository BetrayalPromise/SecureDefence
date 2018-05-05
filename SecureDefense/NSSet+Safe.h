//
//  NSSet+Safe.h
//  Footstone
//
//  Created by 李阳 on 5/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet <T> (Safe)

@property (nonatomic, weak, readonly) NSSet <T> * safe;
@property (nonatomic, assign, readonly) BOOL isSafe;

+ (void)safe;

@end

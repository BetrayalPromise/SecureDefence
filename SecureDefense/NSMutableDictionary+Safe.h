//
//  NSDictionary+Safe.h
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary <K, V> (Safe)

@property (nonatomic, weak, readonly) NSMutableDictionary <K, V> * safe;
@property (nonatomic, assign, readonly) BOOL isSafe;

@end

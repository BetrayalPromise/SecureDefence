//
//  NSDictionary+Safe.h
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary <K, V>(Safe)

@property (nonatomic, assign, readonly) BOOL isSafeContainer;

- (void)safeContainer;

@end

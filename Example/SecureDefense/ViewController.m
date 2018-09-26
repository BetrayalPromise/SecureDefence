//
//  ViewController.m
//  SecureDefense_Example
//
//  Created by mac on 2018/9/26.
//  Copyright © 2018年 BetrayalPromise. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Class cls = [self class];
//    do {
//        NSLog(@"%@", NSStringFromClass(cls));
//        cls = class_getSuperclass(cls);
//    } while (cls);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self setValue:nil forKey:nil];
//    [self valueForKey:nil];
//    [self setValue:nil forKey:@"dfadfadfa"];
//    [self setValue:@"dfadfad" forKey:nil];
}

@end

//
//  QMTVViewController.m
//  SecureDefense
//
//  Created by BetrayalPromise on 05/05/2018.
//  Copyright (c) 2018 BetrayalPromise. All rights reserved.
//

#import "QMTVViewController.h"
#import "NSObject+SubClass.h"
#import <SecureDefense/SecureDefense.h>
#import <objc/runtime.h>

@interface QMTVViewController ()

@end

@implementation QMTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
        入参异常防御
     */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

    NSArray * array = [NSArray new];
    [array safe];
    id result = array[1000];
    NSLog(@"%@", result);

    [self safe];
    [self setValue:nil forKey:nil];
    [self valueForKey:nil];
    [self setValue:nil forKey:@"dfadfadfa"];
    [self setValue:@"dfadfad" forKey:nil];

    [[NSUserDefaults standardUserDefaults] safe];
    [[NSUserDefaults standardUserDefaults] objectForKey:nil];

#pragma clang diagnostic pop


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    /*
        转发防御
     */

    [NSObject safeGuardUnrecognizedSelector];

    [NSObject performSelector:@selector(AAAA)];
    [self performSelector:@selector(AAAA)];
    [NSObject performSelector:@selector(AAAA)];
    [self performSelector:@selector(AAAA)];

#pragma clang diagnostic pop

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

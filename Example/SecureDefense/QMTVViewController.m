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
#import "ViewController.h"
#import <objc/message.h>

@interface QMTVViewController ()

@end

@implementation QMTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSArray * array = [NSArray new];
    [array safeKeyValue];
    
    [array safeContainer];
    NSLog(@"%@", array);

    /*
        入参异常防御
     */
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

//    NSArray * array = [NSArray new];
//    [array safeContainer];
//    id result = array[1000];
//    NSLog(@"%@", result);


//    [self setValue:nil forKey:nil];
//    [self valueForKey:nil];
//    [self setValue:nil forKey:@"dfadfadfa"];
//    [self setValue:@"dfadfad" forKey:nil];

//    [[NSUserDefaults standardUserDefaults] safe];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:nil];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSObject new] forKey:nil];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ADFA"];
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:nil];
//    [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:nil];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:nil];
//    [[NSUserDefaults standardUserDefaults] setURL:nil forKey:nil];
//    [[NSUserDefaults standardUserDefaults] objectForKey:nil];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:nil];
//    [[NSUserDefaults standardUserDefaults] stringForKey:nil];
//    [[NSUserDefaults standardUserDefaults] arrayForKey:nil];
//    [[NSUserDefaults standardUserDefaults] dictionaryForKey:nil];
//    [[NSUserDefaults standardUserDefaults] dataForKey:nil];
//    [[NSUserDefaults standardUserDefaults] stringArrayForKey:nil];
//    [[NSUserDefaults standardUserDefaults] integerForKey:nil];
//    [[NSUserDefaults standardUserDefaults] floatForKey:nil];
//    [[NSUserDefaults standardUserDefaults] doubleForKey:nil];
//    [[NSUserDefaults standardUserDefaults] boolForKey:nil];
//    [[NSUserDefaults standardUserDefaults] URLForKey:nil];
    
#pragma clang diagnostic pop


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    /*
        转发防御
     */

//    [NSObject safeGuardUnrecognizedSelector];
//
//    [NSObject performSelector:@selector(AAAA)];
//    [self performSelector:@selector(AAAA)];
//    [NSObject performSelector:@selector(AAAA)];
//    [self performSelector:@selector(AAAA)];

#pragma clang diagnostic pop
    
//    Class cls = [self class];
//    do {
//        NSLog(@"%@", NSStringFromClass(cls));
//        cls = class_getSuperclass(cls);
//    } while (cls);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleButtonEvent:(UIButton *)btn {
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

@end

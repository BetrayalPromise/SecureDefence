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

    //    NSArray * array = @[@"A", @"B", @"C"].safe;

    //    [array objectAtIndex:0];
    //    [array arrayByAddingObject:nil];
    //    [array indexOfObject:@"B" inRange:NSMakeRange(0, 2)];
    //    [array indexOfObjectIdenticalTo:@"B" inRange:NSMakeRange(0, 2)];
    //    [array subarrayWithRange:NSMakeRange(0, 1)];
    //    [array objectsAtIndexes:[NSIndexSet indexSetWithIndex:10]];
    //    [array objectAtIndexedSubscript:1000];

    /*
         [array arrayByAddingObjectsFromArray:nil];
         [array componentsJoinedByString:nil];
         [array containsObject:nil];
         [array descriptionWithLocale:nil];
         [array descriptionWithLocale:nil indent:1000];
         [array firstObjectCommonWithArray:nil];
         [array indexOfObject:nil];
         [array isEqualToArray:nil];
         [array indexOfObjectIdenticalTo:nil];
    */

    //    NSMutableArray * mutableArray = [NSMutableArray new].safe;
    //    [mutableArray addObject:@"AA"];
    //    [mutableArray removeObjectAtIndex:5];
    //    [mutableArray addObjectsFromArray:nil];
    //    [mutableArray removeObject:nil inRange:NSMakeRange(0, 1)];
    //    [mutableArray removeObject:nil];
    //    [mutableArray removeObjectIdenticalTo:nil inRange:NSMakeRange(0, 1)];
    //    [mutableArray removeObjectsInArray:nil];
    //    [mutableArray setObject:nil atIndexedSubscript:0];

    //    NSSet * set = [NSSet set].safe;
    //    [set anyObject];
    //    [set containsObject:nil];
    //    [set descriptionWithLocale:nil];
    //    [set intersectsSet:nil];
    //    [set isEqualToSet:nil];
    //    [set isSubsetOfSet:nil];
    //    [set setByAddingObject:nil];
    //    id a= [set setByAddingObjectsFromSet:nil];
    //    id b = [set setByAddingObjectsFromArray:nil];

    //    NSMutableSet * mutableSet = [NSMutableSet set].safe;
    //    [set addObject:nil];
    //    [mutableSet addObjectsFromArray:nil];
    //    [mutableSet intersectSet:nil];
    //    [mutableSet minusSet:nil];


    //    NSPointerArray * pointerArray = [NSPointerArray weakObjectsPointerArray].safe;
    //    [pointerArray pointerAtIndex:1000];
    //    [pointerArray removePointerAtIndex:10000];


    //    NSHashTable * hashTable = [NSHashTable hashTableWithOptions:(NSPointerFunctionsWeakMemory)];
    //    NSLog(@"%@", hashTable);
    //    [hashTable addObject:nil];
    //    NSLog(@"%@", hashTable);
    //    NSObject *obj = [NSObject new];
    //    __weak NSObject *obj1 =obj;
    //    [hashTable addObject:obj1];
    //    NSLog(@"%@", hashTable);
    //    [hashTable removeObject:[UIViewController new]];

    //    NSMapTable * mapTable = [NSMapTable weakToWeakObjectsMapTable];
    //    id a = [mapTable objectForKey:nil];
    //    [mapTable removeObjectForKey:nil];
    //    [mapTable setObject:nil forKey:nil];


    NSArray *array0 = [NSArray new].safe;
    NSArray *array1 = [[NSArray alloc] init];
    NSArray *array2 = [NSArray array];
    NSArray *array3 = [[NSArray alloc] initWithObjects:nil count:0];



    //    NSArray * array3 = [NSArray arrayWithObject:@"1"].safe;
    //    NSArray * test3 = [NSArray arrayWithObject:@"1"];
    //
    //    NSArray * array4 = [NSArray arrayWithObject:@1].safe;
    //    NSArray * test4 = [NSArray arrayWithObject:@1];

    NSArray *a = [NSArray findSubClass];
    //    NSLog(@"%@", a);

    // __NSSingleObjectArrayI __NSArray0 __NSArrayI

    NSArray *arr1 = [[NSArray alloc] initWithObjects:@0, nil].safe;

    NSArray *arr2 = [[NSArray alloc] initWithObjects:@0, nil].safe;

    NSArray *arr3 = [[NSArray alloc] initWithObjects:@0, nil];

    NSArray *arr4 = [[NSArray alloc] initWithObjects:@0, @1, nil].safe;
    NSArray *arr5 = [[NSArray alloc] initWithObjects:@0, @1, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

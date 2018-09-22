# SecureDefense

[![CI Status](https://img.shields.io/travis/BetrayalPromise/SecureDefense.svg?style=flat)](https://travis-ci.org/BetrayalPromise/SecureDefense)
[![Version](https://img.shields.io/cocoapods/v/SecureDefense.svg?style=flat)](https://cocoapods.org/pods/SecureDefense)
[![License](https://img.shields.io/cocoapods/l/SecureDefense.svg?style=flat)](https://cocoapods.org/pods/SecureDefense)
[![Platform](https://img.shields.io/cocoapods/p/SecureDefense.svg?style=flat)](https://cocoapods.org/pods/SecureDefense)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```
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
```

## Requirements

## Installation

SecureDefense is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SecureDefense'
```

## Author

BetrayalPromise, BetrayalPromise@gmail.com

## License

SecureDefense is available under the MIT license. See the LICENSE file for more info.

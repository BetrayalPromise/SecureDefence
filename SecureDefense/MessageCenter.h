//
//  MessageCenter.h
//  PersistentStorageUsage
//
//  Created by 李阳 on 3/5/2016.
//  Copyright © 2016 TuoErJia. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma - mark
#pragma - mark FunctionExtension

@interface MessageCenter : NSObject

/// 汇报实例发生未知选择子问题
+ (instancetype)instanceSource:(Class)source selector:(SEL)selector;
/// 汇报类发生未知选择子问题
+ (instancetype)classSource:(Class)source selector:(SEL)selector;



@end

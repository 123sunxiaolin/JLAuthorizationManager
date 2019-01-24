//
//  JLBasePermisssion.h
//  JLAuthorizationDemo
//
//  Created by Jacklin on 2019/1/24.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLAuthorizationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBasePermisssion : NSObject <JLAuthorizationProtocol>

- (void)safeAsyncWithCompletion:(dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END

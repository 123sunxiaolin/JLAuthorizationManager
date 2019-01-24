//
//  JLBasePermisssion.m
//  JLAuthorizationDemo
//
//  Created by Jacklin on 2019/1/24.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//

#import "JLBasePermisssion.h"

@implementation JLBasePermisssion
@synthesize type;

- (void)safeAsyncWithCompletion:(dispatch_block_t)completion {
    if (NSThread.isMainThread) {
        if (completion) {
            completion();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
}

- (JLAuthorizationStatus)authorizationStatus {
    return JLAuthorizationStatusNotDetermined;
}

- (void)requestAuthorizationWithCompletion:(nonnull JLAuthorizationCompletion)completion {}



@end

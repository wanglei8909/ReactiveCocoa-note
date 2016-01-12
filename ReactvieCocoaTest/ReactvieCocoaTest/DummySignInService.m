//
//  DummySignInService.m
//  ReactvieCocoaTest
//
//  Created by 王蕾 on 16/1/11.
//  Copyright © 2016年 Apple inc. All rights reserved.
//

#import "DummySignInService.h"


@implementation DummySignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}


@end

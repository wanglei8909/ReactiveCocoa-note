//
//  DummySignInService.h
//  ReactvieCocoaTest
//
//  Created by 王蕾 on 16/1/11.
//  Copyright © 2016年 Apple inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface DummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end

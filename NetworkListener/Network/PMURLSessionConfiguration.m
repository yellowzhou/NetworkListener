//
//  PMURLSessionConfiguration.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "PMURLSessionConfiguration.h"
#import "PMURLProtocol.h"
#import <objc/runtime.h>

@implementation PMURLSessionConfiguration



+ (instancetype)defaultConfiguration {
    
    static PMURLSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration=[[PMURLSessionConfiguration alloc] init];
    });
    return staticConfiguration;
    
}

- (void)load {
    _isSwizzle = YES;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)unload {
    _isSwizzle = NO;
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:cls toClass:[self class]];
    
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    
    return @[[PMURLProtocol class]];
}

@end

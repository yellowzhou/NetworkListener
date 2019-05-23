//
//  NSJSONSerialization+Extension.m
//  NetworkListener
//
//  Created by yellow on 2019/4/26.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "NSJSONSerialization+Extension.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

@implementation NSJSONSerialization (Extension)

//替换对象方法
+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getInstanceMethod([self class], origSelector);
    Method method2 = class_getInstanceMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}
//替换类方法
+ (void)swizzleClassSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getClassMethod([self class], origSelector);
    Method method2 = class_getClassMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}

+(void)load {
    [self swizzleClassSelector:@selector(JSONObjectWithData:options:error:) withNewSelector:@selector(myJSONObjectWithData:options:error:)];
}

+ (nullable id)myJSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id object = [self myJSONObjectWithData:data options:opt error:error];
    if (object) {
        return object;
    }
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    JSValue *value = [[[JSContext alloc]init] evaluateScript:[NSString stringWithFormat:@"JSON.stringify(%@)",text]];
    NSData *jsonData = [[value toString] dataUsingEncoding:NSUTF8StringEncoding];
    object = [self myJSONObjectWithData:jsonData options:opt error:error];
    if (object) {
        return object;
    }
    return text;
}


@end

//
//  NSObject+Extension.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (id)jsonObject
{
    if (![self isKindOfClass:[NSData class]]) {
        return self;
    }
    
    return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingMutableContainers error:nil];
}

- (NSString *)jsonString
{
    if ([self isKindOfClass:[NSString class]]) return [self copy];
    
    NSData *data = [self jsonData];
    if (data) {
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData *)jsonData
{
    if ([self isKindOfClass:[NSData class]]) {
        return [self copy];
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    }
    return nil;
}

+ (NSArray *)methodList
{
    NSMutableArray *list = [NSMutableArray new];
    unsigned int count;
    Method *methods = class_copyMethodList(self, &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        !name?:[list addObject:name];
    }
    free(methods);
    return [list copy];
}

+ (NSArray *)varList
{
    NSMutableArray *list = [NSMutableArray new];
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        Ivar iv = ivars[i];
        const char *name = ivar_getName(iv);
        NSString *key = [NSString stringWithUTF8String:name];
        !key?:[list addObject:key];
    }
    return [list copy];
}

@end

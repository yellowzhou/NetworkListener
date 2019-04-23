//
//  NSObject+Extension.h
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)

- (id)jsonObject;

- (NSString *)jsonString;

- (NSData *)jsonData;

+ (NSArray *)methodList;
+ (NSArray *)varList;



@end

NS_ASSUME_NONNULL_END

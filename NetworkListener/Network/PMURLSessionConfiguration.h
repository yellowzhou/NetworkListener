//
//  PMURLSessionConfiguration.h
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMURLSessionConfiguration : NSObject

@property (nonatomic,assign,readonly) BOOL isSwizzle;


+ (instancetype)defaultConfiguration;


- (void)load;


- (void)unload;

@end

NS_ASSUME_NONNULL_END

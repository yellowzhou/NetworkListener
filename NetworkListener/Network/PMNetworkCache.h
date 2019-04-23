//
//  PMNetworkCache.h
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMNetworkHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMNetworkCache : NSObject

+ (CGFloat)networkFlowCount;
+ (void)setNetworkFlowCount:(CGFloat)flow;

+ (BOOL)enableCache;
+ (void)setEnableCache:(BOOL)enable;
+ (void)clearCache;

+ (NSString *)saveCacheWithModel:(PMNetworkHttpModel *)model;

+ (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request;


@end

NS_ASSUME_NONNULL_END

//
//  PMNWListener.h
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMNetworkHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

#define URL_PROTOCOL_LOAD_FINISH_NOTIFICATION    @"URL_PROTOCOL_LOAD_FINISH_NOTIFICATION"

@interface PMURLProtocol : NSURLProtocol

+ (BOOL)enableListener;
+ (void)networkListener:(BOOL)enabled;



@end

NS_ASSUME_NONNULL_END

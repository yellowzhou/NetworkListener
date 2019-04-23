//
//  PMStatusBar.h
//  Listener
//
//  Created by yellow on 2019/4/22.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMStatusBar : UIView


+ (void)showStatus:(NSString *)text;
+ (void)showWithText:(NSString *)text barColor:(UIColor*)barColor textColor:(UIColor*)textColor delay:(NSInteger)second;

@end

NS_ASSUME_NONNULL_END

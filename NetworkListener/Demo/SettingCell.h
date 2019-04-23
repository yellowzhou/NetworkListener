//
//  SettingCell.h
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *checkbox;

@property (nonatomic, copy) void (^checkboxAction)(NSInteger type,BOOL on);
@end

NS_ASSUME_NONNULL_END

//
//  SettingViewController.m
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "PMURLProtocol.h"
#import "PMNetworkCache.h"
#import <SVProgressHUD.h>


NS_ENUM(NSInteger,ActionType) {
    ActionTypeAllowCache=1,
    ActionTypeClearCache,
    ActionTypeListener,
};

@interface SettingViewController ()

@property (nonatomic, strong)   NSArray *dataSource;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@{@"text":@"是否允许缓存",@"type":@(ActionTypeAllowCache)},
                        @{@"text":@"清除缓存",@"type":@(ActionTypeClearCache)},
                        @{@"text":@"是否监听",@"type":@(ActionTypeListener)}];
    
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
    [SVProgressHUD setForegroundColor:[UIColor darkTextColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor lightGrayColor]colorWithAlphaComponent:.2]];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item[@"text"];
    cell.tag = [item[@"type"] integerValue];
    __weak typeof(cell) weakCell = cell;
    cell.checkboxAction = ^(NSInteger type,BOOL on) {
        __strong typeof(weakCell) strongCell = weakCell;
        if (type == ActionTypeClearCache) {
            if (!on) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:[UIImage imageNamed:@"SVProgressHUD.bundle/success.png"] status:@"缓存已情况"];
                });
                [PMNetworkCache clearCache];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:.3 animations:^{
                        strongCell.checkbox.on = YES;
                    }];
                });
            }
        } else if (type == ActionTypeListener) {
            [PMURLProtocol networkListener:on];
        } else if (type == ActionTypeAllowCache) {
            [PMNetworkCache setEnableCache:on];
        }
    };
    
    if (cell.tag == ActionTypeListener) {
        cell.checkbox.on = [PMURLProtocol enableListener];
    } else if (cell.tag = ActionTypeAllowCache) {
        cell.checkbox.on = [PMNetworkCache enableCache];
    }
    
    return cell;
}




@end

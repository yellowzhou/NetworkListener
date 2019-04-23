//
//  ListenerListController.m
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "ListenerListController.h"
#import "PMNetworkHttpModel.h"

@interface ListenerListController ()

@property (nonatomic, strong)   NSArray<PMNetworkHttpModel *> *dataSource;
@end

@implementation ListenerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [PMNetworkHttpModel searchWithWhere:nil orderBy:@" startDateString" offset:0 count:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    PMNetworkHttpModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.requestURLString;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li   ",model.responseStatusCode]
                                                                attributes:@{
                                                                             NSForegroundColorAttributeName: [UIColor greenColor]
                                                                             }];
    
    NSString *text = [NSString stringWithFormat:@"%@   %@   %@",model.requestHTTPMethod,model.responseMIMEType,[model.startDateString substringFromIndex:5]];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text];
    [attributedText appendAttributedString:string];
    cell.detailTextLabel.attributedText = attributedText;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

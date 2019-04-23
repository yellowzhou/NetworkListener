//
//  ViewController.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import "WebViewController.h"
#import "WKWebViewController.h"
#import "ListenerListController.h"
#import "PMStatusBar.h"
#import "PMURLProtocol.h"
#import "PMNetworkCache.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *sessionBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSLog(@"%@",path);

    [self setButtonBorder:self.sessionBtn];
    [self setButtonBorder:self.connectionBtn];
    [self setButtonBorder:self.btn1];
    [self setButtonBorder:self.btn2];
    [self setButtonBorder:self.btn3];
    [self setButtonBorder:self.setting];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadFinishNotification:) name:URL_PROTOCOL_LOAD_FINISH_NOTIFICATION object:nil];
    
[self refreshTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}


- (void)setButtonBorder:(UIButton *)button
{
    button.layer.borderWidth = .5;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
}

- (void)loadFinishNotification:(NSNotification *)notification
{
    PMNetworkHttpModel *model = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [PMStatusBar showStatus:model.requestURLString];
        
        
        [UIView animateWithDuration:.2 animations:^{
            self.textlabel.text = model.requestURLString;
        }];
        
        
    });
}

- (void)refreshTitle
{
    CGFloat flow = [PMNetworkCache networkFlowCount];
    if (flow > 1024 * 1024) {
        self.title = [NSString stringWithFormat:@"已使用 %.02f MB",flow / (1024 *1024.0)];
    } else if (flow >  1024) {
        self.title = [NSString stringWithFormat:@"已使用 %.02f KB",flow / 1024.0];
    } else {
        self.title = [NSString stringWithFormat:@"已使用 %.02f B",flow];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTitle];
    });
}


- (IBAction)connectBtnClick:(id)sender {
    
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/search/users?q=language:objective-c&sort=followers&order=desc"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://192.168.9.123"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
    
}

- (IBAction)sessionBtnClick:(id)sender {
    
    
//    [[[NSURLSession sharedSession]dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.example1.com"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@",response);
//    }] resume];
//
//    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://www.example2.com"]] resume];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request]resume];
    
}


- (IBAction)pushWebView:(id)sender {
    
    WebViewController *viewController = [[WebViewController alloc]init];
    [viewController loadDataWithUrl:self.textField.text];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pushWKWebView:(id)sender {
    WKWebViewController *viewController = [[WKWebViewController alloc]init];
    [viewController loadDataWithUrl:self.textField.text];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)detail:(id)sender {
    ListenerListController *viewController = [[ListenerListController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end

//
//  WKWebViewController.m
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController ()

@property (nonatomic, strong)   WKWebView   *wkWebView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WKWebView";

}

- (void)loadDataWithUrl:(NSString *)url
{
    self.wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.wkWebView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebView loadRequest:request];;
}

@end

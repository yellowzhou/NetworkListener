//
//  WebViewController.m
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "WebViewController.h"
#import <objc/runtime.h>
#import "NSObject+Extension.h"

@interface WebViewController ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong)   UIWebView   *webView;
#pragma clang diagnostic pop


@end

@implementation WebViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"UIWebView";
    
}

- (void)loadDataWithUrl:(NSString *)url
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
#pragma clang diagnostic pop
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
    
}


@end

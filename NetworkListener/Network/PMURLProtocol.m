//
//  PMNWListener.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "PMURLProtocol.h"
#import "PMURLSessionConfiguration.h"
#import <WebKit/WebKit.h>
#import "PMNetworkCache.h"

@interface NSURLProtocol (WebKit)

+ (void)wk_registerScheme:(NSString *)scheme;

+ (void)wk_unregisterScheme:(NSString *)scheme;

@end

@implementation NSURLProtocol (WebKit)
FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}


@end


@interface PMURLProtocol()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) PMNetworkHttpModel *model;

@end
@implementation PMURLProtocol

+ (BOOL)enableListener {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"NetworkListener"];
}

+ (void)setEnableListener:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"NetworkListener"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)networkListener:(BOOL)enabled
{
    [PMURLProtocol setEnableListener:enabled];
    
    PMURLSessionConfiguration *sessionConfiguration=[PMURLSessionConfiguration defaultConfiguration];
    
    if (enabled) {
        /** 注册自定义 NSURLProcotol */
        [NSURLProtocol registerClass:[PMURLProtocol class]];
        /** 让 WKWebView 遵循NSURLProcotol */
        [NSURLProtocol wk_registerScheme:@"http"];
        [NSURLProtocol wk_registerScheme:@"https"];
        
        /** NSURLSession 注册NSURLProcotol */
        if (![sessionConfiguration isSwizzle]) {
            [sessionConfiguration load];
        }
    }else{
        /** 移除自定义 NSURLProcotol */
        [NSURLProtocol unregisterClass:[PMURLProtocol class]];
        [NSURLProtocol wk_unregisterScheme:@"http"];
        [NSURLProtocol wk_unregisterScheme:@"https"];
        if ([sessionConfiguration isSwizzle]) {
            [sessionConfiguration unload];
        }
    }
}



+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    /** 防止循环加载 */
    if ([NSURLProtocol propertyForKey:@"PMURLProtocol" inRequest:request] ) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:@"PMURLProtocol"
                     inRequest:mutableReqeust];
    return [mutableReqeust copy];
}


- (void)startLoading
{
    NSCachedURLResponse *cachedURLResponse = [PMNetworkCache dataFromRequest:self.request];
    if (cachedURLResponse ) {
        /** 本地存在缓存，直接返回，未发起网络请求 */
        [[self client] URLProtocol:self didReceiveResponse:cachedURLResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:cachedURLResponse.data];
        [[self client] URLProtocolDidFinishLoading:self];
        return;
    }
    
    self.data = [NSMutableData data];
    
    /** 建立网络请求 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
#pragma clang diagnostic pop

    /** 创建统计model */
    self.model = [[PMNetworkHttpModel alloc]initWithRequest:self.request];
}

- (void)stopLoading {
    /** 取消 当前NSURLConnection 操作 */
    [self.connection cancel];
    
    if (self.model) {
        self.model.response = (id)self.response;
        self.model.responseData = [self.data copy];
        /** 请求信息保存数据库 */
        [[self.model modelBuilder]saveToDB];
        
        /** 缓存处理 */
        [PMNetworkCache saveCacheWithModel:self.model];
    }
    
    /** 流量统计 */
    CGFloat flow = [PMNetworkCache networkFlowCount] + self.model.responseExpectedContentLength;
    [PMNetworkCache setNetworkFlowCount:flow];
    [[NSNotificationCenter defaultCenter]postNotificationName:URL_PROTOCOL_LOAD_FINISH_NOTIFICATION object:self.model];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.model.error = error;
    [[self client] URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}
#pragma clang diagnostic pop

#pragma mark - NSURLConnectionDataDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [[self client] URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end

# Listener

Listener是一个网络请求监听库，可以监控App内所有的HTTP请求、缓存处理、请求详情记录，从而达到app对接口异常监控、流量统计、缓存等处理能力
可以监控能力：
* 接口请求：NSURLConnection、NSURLSession
* webview相关请求：UIWebView、WKWebView
* 第三方库：AFNetworking、sdk 等

如果在古老版本使用 CFNetwork 框架发起的网络请求将无法实现网络拦截

* [使用说明](#使用说明)
* [WKWebView遵循NSURLProtocol](#WKWebView遵循NSURLProtocol)
* [请求信息记录、缓存处理、流量统计](#请求信息记录-缓存处理-流量统计)
* [处理结果](#处理结果)

## 使用说明
1. 是否开启网络监听
```
+ (void)networkListener:(BOOL)enabled;
```
2. 每次请求都会发送一个通知
```
#define URL_PROTOCOL_LOAD_FINISH_NOTIFICATION    @"URL_PROTOCOL_LOAD_FINISH_NOTIFICATION"
```

## WKWebView遵循NSURLProtocol
```
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
```

## 请求信息记录 缓存处理 流量统计
```

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
```

## 处理结果
![github](https://github.com/yellowzhou/NetworkListener/blob/master/image/home.png "github")
![github](https://github.com/yellowzhou/NetworkListener/blob/master/image/info.png "github")
![github](https://github.com/yellowzhou/NetworkListener/blob/master/image/webview.png "github")
![github](https://github.com/yellowzhou/NetworkListener/blob/master/image/db.png "github")
![github](https://github.com/yellowzhou/NetworkListener/blob/master/image/test.png "github")



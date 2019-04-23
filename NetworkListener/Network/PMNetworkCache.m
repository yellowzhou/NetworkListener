//
//  PMNetworkCache.m
//  Listener
//
//  Created by yellow on 2019/4/19.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "PMNetworkCache.h"
#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation PMNetworkCache


+ (CGFloat)networkFlowCount
{
    return [[NSUserDefaults standardUserDefaults]floatForKey:@"network_flow_count"];
}

+ (void)setNetworkFlowCount:(CGFloat)flow
{
    [[NSUserDefaults standardUserDefaults] setFloat:flow forKey:@"network_flow_count"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)enableCache
{
    return [[NSUserDefaults standardUserDefaults]floatForKey:@"network_enable_cache"];
}

+ (void)setEnableCache:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"network_enable_cache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cachePath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"network"];
    BOOL isDirectory ;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            [NSException raise:NSInternalInconsistencyException format:@"create cache directory fail."];
        }
    }
    return path;
}

+ (void)clearCache
{
    [PMNetworkHttpModel deleteWithWhere:nil];
    [[NSFileManager defaultManager]removeItemAtPath:[self cachePath] error:nil];
    [self setNetworkFlowCount:0];
}

+ (BOOL)enableCacheWithMIMEType:(NSString *)mimeType
{
    static NSDictionary *contentType;
    contentType = @{@"text/html":@(NO),@"text/css":@(NO),@"application/x-javascript":@(NO),@"text/xml":@(NO),@"image/png":@(YES),@"image/jpeg":@(YES),@"image/gif":@(YES),@"image/x-icon":@(YES),@"application/x-jpg":@(YES),@"application/x-png":@(YES),@"video/mpeg4":@(YES),@"audio/mp3":@(YES),};
    if (contentType[mimeType]) {
        return [contentType[mimeType] boolValue];
    }
    return NO;
}


+ (NSString *)saveCacheWithModel:(PMNetworkHttpModel *)model
{
    if (![self enableCache]) {
        return nil;
    }
    if (!model.responseData) {
        return nil;
    }
    
    if (![self enableCacheWithMIMEType:model.responseMIMEType]) {
        return nil;
    }
    
    
    NSString *path = [[self cachePath] stringByAppendingPathComponent:[model.requestURLString md5]];
    NSLog(@"---------------------------------------");
    NSLog(@"url: %@",model.requestURLString);
    NSLog(@"mime: %@",model.responseMIMEType);
    NSLog(@"path: %@",path);
    NSLog(@"---------------------------------------");
    
    if (![model.responseData writeToFile:path atomically:YES])
    {
        return nil;
    }
    return path;
}

+ (NSData *)fetchCacheWithUrl:(NSString *)requestUrlString
{
    NSString *path = [[self cachePath] stringByAppendingPathComponent:[requestUrlString md5]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

+ (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request
{
    if (![self enableCache]) {
        return nil;
    }
    
    NSString *urlString = request.URL.absoluteString;
    if (!urlString) { // 非缓存文件
        return nil;
    }
    
    NSData *data = [self fetchCacheWithUrl:urlString];
    if(!data) { // 缓存没有找到，采用网络请求方式
        return nil;
    }
    
    PMNetworkHttpModel *model = [[PMNetworkHttpModel searchWithWhere:[NSString stringWithFormat:@" requestURLString='%@'",urlString]] firstObject];
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                        MIMEType:model.responseMIMEType
                                           expectedContentLength:model.responseExpectedContentLength
                                                textEncodingName:model.responseTextEncodingName];
    
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
    return cachedResponse;
    
}

+ (NSString *)contentTypeForPathExtension:(NSString *)pathExtension
{
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pathExtension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
}


@end

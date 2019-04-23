//
//  PMNetWorkHttpModel.m
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "PMNetworkHttpModel.h"
#import "NSDate+Extension.h"
#import "NSObject+Extension.h"

@interface PMNetworkHttpModel()



@end

@implementation PMNetworkHttpModel

+ (NSDictionary *)getTableMapping
{
    return @{@"startDateString":LKSQL_Mapping_Inherit,
             @"endDateString":LKSQL_Mapping_Inherit,
             @"requestURLString":LKSQL_Mapping_Inherit,
             @"requestTimeoutInterval":LKSQL_Mapping_Inherit,
             @"requestHTTPMethod":LKSQL_Mapping_Inherit,
             @"requestAllHTTPHeaderFields":LKSQL_Mapping_Inherit,
             @"requestHTTPBody":LKSQL_Mapping_Inherit,
             @"responseMIMEType":LKSQL_Mapping_Inherit,
             @"responseExpectedContentLength":LKSQL_Mapping_Inherit,
             @"responseTextEncodingName":LKSQL_Mapping_Inherit,
             @"responseSuggestedFilename":LKSQL_Mapping_Inherit,
             @"responseStatusCode":LKSQL_Mapping_Inherit,
             @"responseAllHeaderFields":LKSQL_Mapping_Inherit,
             @"responseDataString":LKSQL_Mapping_Inherit,
             @"errorString":LKSQL_Mapping_Inherit
             
             };
}

+ (NSString *)getTableName
{
    return @"network";
}


+ (NSString *)getPrimaryKey
{
    return @"requestURLString";
}


- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.startDateString = [[NSDate date]stringByFormatter:@"yyyy-MM-dd HH:mm:ss.SSS zzz"];
        self.request = request;
    }
    return self;
}

- (NSString *)endDateString {
    if (!_endDateString) {
        _endDateString = [[NSDate date]stringByFormatter:@"yyyy-MM-dd HH:mm:ss.SSS zzz"];
    }
    return _endDateString;
}

- (id)modelBuilder
{
    self.requestURLString = self.request.URL.absoluteString?:@"";;
    self.requestHTTPMethod = self.request.HTTPMethod?:@"";;
    self.requestTimeoutInterval = self.request.timeoutInterval;
    self.requestAllHTTPHeaderFields = [self.request.allHTTPHeaderFields jsonString]?:@"";;
    self.requestHTTPBody = [[NSString alloc]initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]?:@"";
    
    self.responseMIMEType = self.response.MIMEType?:@"";;
    self.responseExpectedContentLength = self.response.expectedContentLength;
    self.responseTextEncodingName = self.response.textEncodingName?:@"";;
    self.responseSuggestedFilename = self.response.suggestedFilename?:@"";
    self.responseStatusCode = self.response.statusCode;
    self.responseAllHeaderFields = [self.response.allHeaderFields jsonString]?:@"";
    self.responseDataString = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding]?:@"";
    self.errorString = [NSString stringWithFormat:@"%@",self.error];
    
    return  self;
}





@end

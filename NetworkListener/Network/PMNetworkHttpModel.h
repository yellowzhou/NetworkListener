//
//  PMNetWorkHttpModel.h
//  Listener
//
//  Created by yellow on 2019/4/18.
//  Copyright © 2019 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMNetworkHttpModel : NSObject

@property (nonatomic, copy) NSURLRequest    *request;
@property (nonatomic, copy) NSHTTPURLResponse *response;
@property (nonatomic, copy) NSError         *error;
@property (nonatomic, copy) NSData          *responseData;

@property (nonatomic, copy) NSString        *startDateString;
@property (nonatomic, copy) NSString        *endDateString;
@property (nonatomic, copy) NSString        *requestURLString;
@property (nonatomic, assign) float         requestTimeoutInterval;
@property (nonatomic, copy) NSString        *requestHTTPMethod;
@property (nonatomic, copy) NSString        *requestAllHTTPHeaderFields;
@property (nonatomic, copy) NSString        *requestHTTPBody;
@property (nonatomic, copy) NSString        *responseMIMEType;
@property (nonatomic, assign) float        responseExpectedContentLength;
@property (nonatomic, copy) NSString        *responseTextEncodingName;
@property (nonatomic, copy) NSString        *responseSuggestedFilename;
@property (nonatomic, assign) NSInteger        responseStatusCode;
@property (nonatomic, copy) NSString        *responseAllHeaderFields;
@property (nonatomic, copy) NSString        *responseDataString;
@property (nonatomic, copy) NSString        *errorString;



- (instancetype)initWithRequest:(NSURLRequest *)request;

- (id)modelBuilder;


//+ (instancetype)queryDBWithUrlString:(NSString *)urlString

@end

NS_ASSUME_NONNULL_END

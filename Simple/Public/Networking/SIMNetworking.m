//
//  SIMNetworking.m
//  Simple
//
//  Created by ehsy on 16/6/13.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "SIMNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#import <CommonCrypto/CommonDigest.h>

@interface NSString(md5)

@end
@implementation NSString(md5)

+(NSString *)simnetworkingMD5:(NSString *)string
{
    if (!string || string.length == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    return [ms copy];
}
@end


static NSString *sgPrivateNetworkBaseUrl = nil;
static BOOL sgIsEnableInterfaceDebug = NO;
static BOOL sgShouldAutoEncode = NO;
static NSDictionary *sgHttpHeaders = nil;
static SIMResponseType sgResponseType = kSIMResponseTypeJSON;
static SIMRequestType sgRequestType = kSIMRequestTypeJSON;
static SIMNetworkStatus sgNetworkStatus = kSIMNetworkStatusUnknow;
static NSMutableArray *sgRequestTasks;
static BOOL sgCacheGet = YES;
static BOOL sgCachePost = NO;
static BOOL sgShouldCallbackOnCancelRequest = YES;
static NSTimeInterval sgTimeout = 60.0f;
static BOOL sgShouldObtainLocalWhenUnconnected = NO;

@implementation SIMNetworking

+(void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost
{
    sgCacheGet = isCacheGet;
    sgCachePost = shouldCachePost;
}

+(void)updateBaseUrl:(NSString *)baseUrl
{
    sgPrivateNetworkBaseUrl = baseUrl;
}

+(NSString *)baseUrl
{
    return sgPrivateNetworkBaseUrl;
}

+(void)setTimeout:(NSTimeInterval)timeout
{
    sgTimeout = timeout;
}

+(void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain
{
    sgShouldObtainLocalWhenUnconnected = shouldObtain;
}

+(void)enableInterfaceDebug:(BOOL)isDebug
{
    sgIsEnableInterfaceDebug = isDebug;
}

+(BOOL)isDebug
{
    return sgIsEnableInterfaceDebug;
}

static inline NSString *cachePath()
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SIMNetworkingCaches"];
}

+(void)clearCaches
{
    NSString *directoryPath = cachePath();
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    
        if (error) {
            NSLog(@"SIMNetworking clear caches error:%@",error);
        }else{
            NSLog(@"SIMNetworking clear caches ok");
        }
    }
}


+(unsigned long long)totalCacheSize
{
    NSString *directory = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directory stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
                    if (!error) {
                        total +=[dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    return total;
}

+(NSMutableArray *)allTasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sgRequestTasks == nil) {
            sgRequestTasks = [[NSMutableArray alloc]init];
        }
    });
    return sgRequestTasks;
}

+(void)cancelAllRequest
{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(SIMURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if([task isKindOfClass:[SIMURLSessionTask class]])
                {
                    [task cancel];
                }
            }];
    }
}


+(void)cancelRequestWithURL:(NSString *)url
{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(SIMURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString isEqualToString:[self absoluteUrlWithPath:url]]) {
                [task cancel];
                *stop = YES;
            }
        }];
    }
}

+(void)configRequestType:(SIMRequestType)requestType
            responseType:(SIMResponseType)responseType
     shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
 callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest
{
    sgRequestType = requestType;
    sgResponseType = responseType;
    sgShouldAutoEncode = shouldAutoEncode;
    sgShouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+(BOOL)shouldEncode
{
    return sgShouldAutoEncode;
}

+(void)configCommonHttpHeaders:(NSDictionary *)httpHeaders
{
    sgHttpHeaders = httpHeaders;
}


+(SIMURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(SIMResponseSuccess)success
                            fail:(SIMResponseFail)fail
{
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:nil
                   progress:nil
                    success:success
                       fail:fail];
}

+(SIMURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(SIMResponseSuccess)success
                            fail:(SIMResponseFail)fail
{
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:params
                   progress:nil
                    success:success
                       fail:fail];
}

+(SIMURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(SIMGetProgress)progress
                         success:(SIMResponseSuccess)success
                            fail:(SIMResponseFail)fail
{
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                      httpMethod:1
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}

+(SIMURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(SIMResponseSuccess)success
                             fail:(SIMResponseFail)fail
{
   return [self postWithUrl:url
               refreshCache:refreshCache
                     params:params
                   progress:nil
                    success:success
                       fail:fail];
}

+(SIMURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(SIMPostProgress)progress
                          success:(SIMResponseSuccess)success
                             fail:(SIMResponseFail)fail
{
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                      httpMethod:2
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}

#pragma mark - core method
+(SIMURLSessionTask *)_requestWithUrl:(NSString *)url
                         refreshCache:(BOOL)refreshCache
                           httpMethod:(NSUInteger)httpMethod
                               params:(NSDictionary *)params
                             progress:(SIMDownloadProgress)progress
                              success:(SIMResponseSuccess)success
                                 fail:(SIMResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            SIMAppLog(@"urlString 无效，无法生成URL");
            return nil;
        }
    }else{
        NSURL *absoluteUrl = [NSURL URLWithString:absolute];
        if (absoluteUrl == nil) {
            SIMAppLog(@"urlString 无效，无法生成URL");
            return nil;
        }
    }
    
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    SIMURLSessionTask *session = nil;
    if (httpMethod == 1) {
        //获取缓存
        if (sgCacheGet) {
            if (sgShouldObtainLocalWhenUnconnected) {
                if (sgNetworkStatus == kSIMNetworkStatusNotReachable || sgNetworkStatus == kSIMNetworkStatusUnknow) {
                    //无网络环境下获取本地缓存
                    id response = [SIMNetworking cacheResponseWithUrl:absolute
                                                            paramters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response url:absolute params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                //获取缓存
                id response = [SIMNetworking cacheResponseWithUrl:absolute
                                                        paramters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
            
            
        }
        //不获取缓存
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            if (sgCacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest paramters:params];
            }
            [[self allTasks] removeObject:task];
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks]removeObject:task];
            
            if ([error code] < 0 && sgCacheGet) {
                //获取缓存
                id response = [SIMNetworking cacheResponseWithUrl:absolute
                                                        paramters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                }else{
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            }else{
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }else if (httpMethod == 2){
        if (sgCachePost) {
            //获取缓存
            if (sgShouldObtainLocalWhenUnconnected) {
                if (sgNetworkStatus == kSIMNetworkStatusUnknow || sgNetworkStatus == kSIMNetworkStatusNotReachable) {
                    id response = [SIMNetworking cacheResponseWithUrl:absolute paramters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response
                                                         url:absolute
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            
            if (!refreshCache) {
                id response = [SIMNetworking cacheResponseWithUrl:absolute paramters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            if (sgCachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest paramters:params];
            }
            [[self allTasks] removeObject:task];
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            
            if ([error code] < 0 && sgCachePost) {
                //获取缓存
                id response = [SIMNetworking cacheResponseWithUrl:absolute paramters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                }else{
                    [self handleCallbackWithError:error fail:false];
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            }else{
                [self handleCallbackWithError:error fail:false];
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    [session resume];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

+(SIMURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(SIMUploadProgress)progress
                                success:(SIMResponseSuccess)success
                                   fail:(SIMResponseFail)fail
{
    if ([NSURL URLWithString:uploadingFile] == nil) {
        SIMAppLog(@"uploadingFile无效，无法生成URL，请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    }else{
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]];
    }
    
    if (uploadURL == nil) {
        SIMAppLog(@"URLString无效，无法生成URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    SIMURLSessionTask *session = nil;
    
   session = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        }else{
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:response.URL.absoluteString params:nil];
            }
        }
        
    }];
    
    [session resume];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

+(SIMURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(SIMUploadProgress)progress
                              success:(SIMResponseSuccess)success
                                 fail:(SIMResponseFail)fail
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            SIMAppLog(@"urlString无效，无法生成URL");
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]] == nil) {
            SIMAppLog(@"urlString无效，无法生成URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager =[self manager];
    
    SIMURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        
        if (filename == nil ||![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg",str];
        }
        
        //上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject url:absolute params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

+(SIMURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(SIMDownloadProgress)progressBlock
                              success:(SIMResponseSuccess)success
                              failure:(SIMResponseFail)failure
{
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            SIMAppLog(@"URLString无效，无法生成URL");
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self baseUrl],url]] == nil) {
            SIMAppLog(@"URLString无效，无法生成URL");
            return nil;
        }
    }

    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    SIMURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            if ([self isDebug]) {
                SIMAppLog(@"download success for url %@",[self absoluteUrlWithPath:url]);
            }
        }else{
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                SIMAppLog(@"download fail for url %@,reason:%@",[self absoluteUrlWithPath:url],[error description]);
            }
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}


#pragma mark - private
+(AFHTTPSessionManager *)manager
{
    //开启loading
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPSessionManager *manager = nil;
    if ([self baseUrl]) {
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString: [self baseUrl]]];
    }else{
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (sgRequestType) {
        case kSIMRequestTypeJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case kSIMRequestTypePlainText:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    switch (sgResponseType) {
        case kSIMResponseTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case kSIMResponseTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case kSIMResponseTypeData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }

    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    for (NSString *key in sgHttpHeaders.allKeys) {
        if (sgHttpHeaders[key] != nil) {
            [manager.requestSerializer setValue:sgHttpHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[
                                                        @"application/json",
                                                        @"text/html",
                                                        @"text/json",
                                                        @"text/plain",
                                                        @"text/javascript",
                                                        @"text/xml",
                                                        @"image/*"
                                                        ]];
    manager.requestSerializer.timeoutInterval = sgTimeout;
    
    //设置最大并发数
    manager.operationQueue.maxConcurrentOperationCount = 3;
    if (sgShouldObtainLocalWhenUnconnected && (sgCacheGet || sgCachePost)) {
        [self detectNetwork];
    }
    return manager;
}

+(void)detectNetwork
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            sgNetworkStatus = kSIMNetworkStatusUnknow;
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            sgNetworkStatus = kSIMNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            sgNetworkStatus = kSIMNetworkStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            sgNetworkStatus = kSIMNetworkStatusReachableViaWiFi;
        }else{}
    }];
}

+(void)logWithSuccessResponse:(id)response
                          url:(NSString *)url
                       params:(NSDictionary *)params
{
    SIMAppLog(@"\n");
    SIMAppLog(@"\nRequset success,url:%@\n params:%@\n response:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              params,
              [self tryTpParseData:response]
              );
}

+(void)logWithFailError:(NSError *)error
                    url:(NSString *)url
                 params:(id)params
{
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    SIMAppLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        SIMAppLog(@"\nRequest was canceld mannully ,URL:%@ %@%@\n\n",
                  [self generateGETAbsoluteURL:url params:params],
                  format,
                  params);
    }else{
        SIMAppLog(@"\nRequset error,URL:%@ %@%@\n errorInfos:%@\n\n",[self generateGETAbsoluteURL:url params:params],
                  format,
                  params,
                  [error localizedDescription]);
    }

}

//仅对一级字典结构起作用
+(NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params
{
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        }else if ([value isKindOfClass:[NSArray class]]){
            continue;
        }else if ([value isKindOfClass:[NSSet class]]){
            continue;
        }else{
            queries = [NSString stringWithFormat:@"%@%@=%@&",(queries.length == 0?@"&":queries),key,value];
        }
    }
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location !=NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@",url,queries];
        }else{
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@%@",url,queries];
        }
    }
    return url.length == 0 ? queries:url;
}

+(NSString *)encodeUrl:(NSString *)url
{
    return [self simURLEncode:url];
}

+(id)tryTpParseData:(id)responseData
{
    if ([responseData isKindOfClass:[NSData class]]) {
        //尝试解析成json
        if (responseData == nil) {
            return responseData;
        }else{
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            if (error) {
                return responseData;
            }else{
                return response;
            }
        }
    }
    return responseData;
}

+(void)successResponse:(id)responseData callback:(SIMResponseSuccess)success
{
    if (success) {
        success([self tryTpParseData:responseData]);
    }
}

+(NSString *)simURLEncode:(NSString *)url
{
    return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"].invertedSet];
}

+(id)cacheResponseWithUrl:(NSString *)url paramters:(NSDictionary *)params
{
    id cacheData = nil;
    
    if (url){
        NSString *directoryPath = cachePath();
        NSString *absoluteUrl = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString simnetworkingMD5:absoluteUrl];
        NSString *path = [directoryPath stringByAppendingString:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            SIMAppLog(@"read data from cache for url:%@\n",url);
        }
    }
    return cacheData;
}

+(void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request paramters:(NSDictionary *)params
{
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directorPath = cachePath();
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:directorPath isDirectory:nil]) {
            [[NSFileManager defaultManager]createDirectoryAtPath:directorPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
            if (error) {
                SIMAppLog(@"create cache dir error:%@\n",error);
                return;
            }
        }
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [NSString simnetworkingMD5:absoluteURL];
        NSString *path = [directorPath stringByAppendingString:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        }else{
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && !error) {
            BOOL isOK = [[NSFileManager defaultManager] createFileAtPath:path
                                                                contents:data
                                                              attributes:nil];
            if (isOK) {
                SIMAppLog(@"cache file ok for request:%@\n",absoluteURL);
            }else{
                SIMAppLog(@"cache file error for request:%@\n",absoluteURL);
            }
        }
        
    }
}


+(NSString *)absoluteUrlWithPath:(NSString *)path
{
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [self baseUrl].length == 0)  {
        return path;
    }
    NSString *absoluteUrl = path;
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasPrefix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString *mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],mutablePath];
            }else{
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
            }
        }else{
            if ([absoluteUrl hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
            }else{
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",[self baseUrl],path];
            }
        }
    }
    return absoluteUrl;
}

+(void)handleCallbackWithError:(NSError *)error fail:(SIMResponseFail)fail
{
    if ([error code] == NSURLErrorCancelled) {
        if (sgShouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    }else{
        if (fail) {
            fail(error);
        }
    }
}

@end



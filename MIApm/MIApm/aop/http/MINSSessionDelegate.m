//
//  MIHttpDelegate.m
//  MIApm
//
//  Created by mediaios on 2019/4/4.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "MINSSessionDelegate.h"
#import "MIApmHelper.h"
#import "MIHttpModel.h"
#import "MIApmClient.h"

@interface MINSSessionDelegate()
@property (nonatomic,strong) NSMutableArray *selList;
@property (nonatomic,assign) NSUInteger reqDate;
@property (nonatomic,assign) CFAbsoluteTime beginTim;
@property (nonatomic,assign) CFAbsoluteTime endTim;
@property (nonatomic,strong) NSURLRequest *miRequest;
@property (nonatomic,strong) NSHTTPURLResponse *miResponse;
@property (nonatomic,strong) NSError *miError;
@property (nonatomic,assign) NSUInteger sendSize;
@property (nonatomic,assign) NSUInteger receiveSize;
@end

@implementation MINSSessionDelegate

- (NSMutableArray *)selList
{
    if (!_selList) {
        _selList = [NSMutableArray arrayWithCapacity:0];
    }
    return _selList;
}

- (void)invoke:(NSInvocation *)invocation
{
    if ([self.selList containsObject:NSStringFromSelector(invocation.selector)]) {
        if ([self respondsToSelector:invocation.selector]) {
            invocation.target = self;
            [invocation invoke];
        }
    }
}

- (void)registerSel:(NSString *)sel
{
    if (![self.selList containsObject:sel]) {
        [self.selList addObject:sel];
    }
}

- (void)unregisterSel:(NSString *)sel
{
    if ([self.selList containsObject:sel]) {
        [self.selList removeObject:sel];
    }
}

- (void)resetPropertys
{
    _reqDate = 0;
    _beginTim = 0;
    _endTim = 0;
    _miRequest = nil;
    _miResponse = nil;
    _miError = nil;
    _sendSize = 0;
    _receiveSize = 0;
}

#pragma mark-NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics  API_AVAILABLE(ios(10.0)){
    NSLog(@"%s",__func__);
        if (metrics)
            [MIApmHelper monitorHttpWithSessionTaskMetrics:metrics error:_miError];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    _miError = error;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
//    NSLog(@"%s----",__func__);
    _receiveSize = data.length;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
//    NSLog(@"%s----",__func__);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//   NSLog(@"%s----",__func__);
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
//    NSLog(@"%s----",__func__);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
//    NSLog(@"%s----",__func__);
    _sendSize = totalBytesSent;
}

@end
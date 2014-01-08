//
//  HMGNetworkManager.h
//  HomagePrototype
//
//  Created by Tomer Harry on 11/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER @"http://54.204.34.168:4567"

@interface HMGNetworkManager : NSObject

// This method returns an NSURLRequest that will be used for uploading a file with parameters
+ (NSURLRequest*)requestToUploadURL:(NSURL *)url withFile:(NSURL *)file withParams:(NSDictionary *)params;

// This method creates a POST request with given params
+ (NSURLRequest *)createPostRequestURL:(NSURL *)url withParams:(NSDictionary *)params;

+ (NSString*) fileMIMEType:(NSString*) file;

@end

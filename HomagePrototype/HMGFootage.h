//
//  HMGFootage.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGFootage : NSObject

@property (strong, nonatomic) NSURL *rawVideo;
@property (nonatomic, getter = isUploaded) BOOL uploaded;
@property (nonatomic, getter = isProcessed) BOOL processed;

@end

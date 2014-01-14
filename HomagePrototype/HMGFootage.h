//
//  HMGFootage.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGFootage : NSObject

typedef enum {
    HMGFootageStatusStatusOpen,
    HMGFootageStatusStatusUploading,
    HMGFootageStatusStatusProcessing,
    HMGFootageStatusStatusReady
} HMGFootageStatus;


@property (strong, nonatomic) NSURL *rawVideo;
@property (nonatomic) HMGFootageStatus status;
//@property (strong, nonatomic) NSURL *processedVideo;
//@property (nonatomic, getter = isUploaded) BOOL uploaded;
//@property (nonatomic, getter = isProcessed) BOOL processed;

@end

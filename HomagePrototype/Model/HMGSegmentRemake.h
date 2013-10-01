//
//  HMGSegmentRemake.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGSegment.h"
#import <AVFoundation/AVFoundation.h>

@interface HMGSegmentRemake : NSObject

// Array of NSURLs each item in the array holds a URL to a video represnting a processed take for this segment
@property (strong, nonatomic,readonly) NSMutableArray *takes;
@property (nonatomic) NSUInteger selectedTakeIndex;

@property (strong, nonatomic) HMGSegment *segment;


// This method will create a video based on the data in the current instance. The operation is asynchronous. After the video is successfully created, it will be saved as a new take and the completion handler will be called. If the there was a faliure in the video creation, videoURL in the completion handler will be nil, and an error will apear in the error object
- (void)processVideoAsynchronouslyWithCompletionHandler:(void (^)(NSURL *videoURL, NSError *error))completion;

// This method should be called once the video export is finished
//- (void)processVideoDidFinish:(AVAssetExportSession*)exporter;

// Addes a video to the takes 
//- (void)addVideoTake:(NSURL *)videoURL;

//+ (void)mergeVideos:(NSArray*)videoUrls withSoundtrack:(NSURL*)soundtrackURL completion:(void (^)(AVAssetExportSession*))completion


//- (NSURL *)createVideo;
//- (void) assignVideo:(NSURL *) videoURL;

@end



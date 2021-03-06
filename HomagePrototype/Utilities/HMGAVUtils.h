//
//  HMGAVUtils.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HMGAVUtils : NSObject

// This method receives a list of videos (URLs to the videos) and a soundtrack (URL to the soundtrack). The method merges the videos and soundtrack into a new video. The completion method will be called asynchronously once the new video is ready
+ (void)mergeVideos:(NSArray*)videoUrls withSoundtrack:(NSURL*)soundtrackURL completion:(void (^)(AVAssetExportSession*))completion;

// This methods scales the given video into a different duration (makes the video faster or slower). The completion method will be called asynchronously once the new video is ready
+(void)scaleVideo:(NSURL*)videoURL toDuration:(CMTime)duration completion:(void (^)(AVAssetExportSession*))completion;

// This method transformes a list of images into a video. It receives an array of images (UIImage) and frame time in milliseconds for the time that each image will be displayed in the video. The completion method will be called asynchronously once the new video is ready
+(void)imagesToVideo:(NSArray*)images withFrameTime:(CMTime)frameTime completion:(void (^)(AVAssetWriter*))completion;

// This method addes text to video. It recevies a video (as a URL) and the text that will be displyed on the video. The completion method will be called asynchronously once the new video is ready
//Currenlty one text per Video in the center of the Video and it appears the entire Video
+ (void)textOnVideo:(NSURL*)videoURL withText:(NSString*)text withFontName:(NSString*)fontName withFontSize:(CGFloat)fontSize completion:(void (^)(AVAssetExportSession*))completion;

// This method extracts an image (frame) from a given video on the given time
+ (UIImage *)imageForVideo:(NSURL *)videoURL onTime:(CMTime)time;

@end

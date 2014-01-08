//
//  HMGRemake.m
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGRemake.h"
#import "HMGLog.h"
#import "HMGNetworkManager.h"

@implementation HMGRemake

- (id)initWithStory:(HMGStory *)story
{
    self = [super init];
    
    if (self)
    {
        self.storyID = story.storyID;
    }
    
    return self;
}


- (void)addFootage:(NSURL *)video withSceneID:(NSString *)sceneID
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If there is no video assiged in this instance we cannot proceed
    if (!video)
    {
        [NSException raise:@"InvalidArgumentException" format:@"video must not be nil"];
    }
    
    // If there is no scene ID assiged in this instance we cannot proceed
    if (!sceneID)
    {
        [NSException raise:@"InvalidArgumentException" format:@"scene ID must not be nil"];
    }
    
    // Creating a footage object based on the given video and updating the Remake with it
    HMGFootage *footage = [[HMGFootage alloc] init];
    footage.rawVideo = video;
    footage.uploaded = NO;
    NSMutableDictionary *mutableFootages;
    if (self.footages)
    {
        mutableFootages = (id)self.footages;
    }
    else
    {
        mutableFootages = [[NSMutableDictionary alloc] init];
        self.footages = mutableFootages;
    }
    [mutableFootages setObject:footage forKey:sceneID];

    // Uploading the video to the server
    NSURL *footageUploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/footage", SERVER]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    //NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:videoSegment.templateFolder, @"template_folder", videoSegment.segmentFile, @"segment_file", nil];
    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:self.storyID, @"story_id", sceneID, @"scene_id", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:footageUploadURL withFile:video withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:request.HTTPBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            HMGLogError(error.description);
            //completion(nil, error);
        }
        else
        {
            HMGLogDebug(@"Video Successfully uploaded");
            //[self addVideoTake:self.video];
            //completion(self.video, error);
        }
    }];
    
    HMGLogDebug(@"Video upload started");
    [uploadTask resume];

    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

@end

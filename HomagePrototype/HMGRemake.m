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
        self.userID = @"app@homage.it";
        
        // Posting the new Remake
        NSURL *remakePostURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/remake", SERVER]];
        NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:self.storyID, @"story_id", self.userID, @"user_id", nil];
        NSURLRequest *remakePostRequest = [HMGNetworkManager createPostRequestURL:remakePostURL withParams:postParams];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithRequest:remakePostRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            HMGLogDebug(response.description);
            if (error)
            {
                HMGLogError(error.description);
            }
            else
            {
                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                self.remakeID = dataString;
            }
        }] resume];
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
    
    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:self.remakeID, @"remake_id", sceneID, @"scene_id", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:footageUploadURL withFile:video withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:request.HTTPBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        HMGLogDebug(@"response: %@", response.description);
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        HMGLogDebug(@"data: %@", dataString);
        if (error)
        {
            HMGLogError(error.description);
            //completion(nil, error);
        }
        else
        {
            HMGLogDebug(@"Video Successfully uploaded");
            //footage.uploaded = YES;
            
            // Starting the Foreground Extraction on the Server
            NSURL *foregroundURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/foreground", SERVER]];
            NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:self.remakeID, @"remake_id", sceneID, @"scene_id", nil];
            NSURLRequest *foregroundPostRequest = [HMGNetworkManager createPostRequestURL:foregroundURL withParams:postParams];
            
            
            [[session dataTaskWithRequest:foregroundPostRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    HMGLogError(error.description);
                }
                else
                {
                    //footage.processed = YES;
                }
            }] resume];

            
            //[self addVideoTake:self.video];
            //completion(self.video, error);
        }
    }];
    
    HMGLogDebug(@"Video upload started");
    [uploadTask resume];

    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);
}

- (void)render
{
    // Starting the movie Render
    NSURL *renderURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/render", SERVER]];
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:self.remakeID, @"remake_id", nil];
    NSURLRequest *renderPostRequest = [HMGNetworkManager createPostRequestURL:renderURL withParams:postParams];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:renderPostRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            HMGLogError(error.description);
        }
    }] resume];

}


@end

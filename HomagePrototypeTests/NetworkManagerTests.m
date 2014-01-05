//
//  NetworkManagerTests.m
//  HomagePrototype
//
//  Created by Tomer Harry on 11/27/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HMGNetworkManager.h"
#import "AGWaitForAsyncTestHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HMGFileManager.h"
#import "HMGStory.h"
#import "HMGScene.h"
#import "HMGText.h"
#import "HMGHomage.h"

@interface NetworkManagerTests : SenTestCase

@property (strong, nonatomic) NSURL *serverUploadURL;
@property (strong, nonatomic) NSURL *serverUpdateTextURL;
@property (strong, nonatomic) NSURL *redVideo;
@property (strong, nonatomic) NSURL *finishLineVideo;
@property (strong, nonatomic) NSURLSession *session;


@end

static NSString * const redVideoName = @"Red.mov";
static NSString * const finishLineVideoName = @"Tikim_FinishLine_Export.mp4";
static NSString * const server = @"http://54.204.34.168:4567/";

@implementation NetworkManagerTests

- (void)setUp
{
    [super setUp];
    
    self.serverUploadURL = [NSURL URLWithString:@"http://54.204.34.168:4567/upload"];
    
    self.serverUpdateTextURL = [NSURL URLWithString:@"http://54.204.34.168:4567/update_text"];
    
    NSString *redVideoPath = [[NSBundle bundleForClass:[self class]] pathForResource:redVideoName ofType:nil];
    self.redVideo = [NSURL fileURLWithPath:redVideoPath];
    
    NSString *finishLinePath = [[NSBundle bundleForClass:[self class]] pathForResource:finishLineVideoName ofType:nil];
    self.finishLineVideo = [NSURL fileURLWithPath:finishLinePath];
    
    self.session = [NSURLSession sharedSession];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

// Testing the request bodu size, it should be bigger than the size of the file we want to upload
- (void)testRequestBodySize
{
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.redVideo withParams:nil];
    
    NSData *videoData = [NSData dataWithContentsOfFile:self.redVideo.path];
    
    STAssertTrue([request HTTPBody].length > videoData.length, nil);
}

- (void)testMIMEType
{
    NSString *mimeType = [HMGNetworkManager fileMIMEType:self.redVideo.path];
    
    STAssertTrue([mimeType isEqualToString:@"video/quicktime"], nil);
}

/*
- (void)testGetStories
{
    HMGHomage *homage = [HMGHomage sharedHomage];
    
    NSArray *stories = homage.stories;
    
    NSLog(@"#stories: %d", stories.count);
}

- (void)testGetMe
{
    HMGHomage *homage = [HMGHomage sharedHomage];
    
    HMGUser *user = homage.me;
    
    NSLog(@"user mail: %@", user.email);
}

- (void)testGetRemakes
{
    HMGHomage *homage = [HMGHomage sharedHomage];
    
    NSArray *remakes = homage.myRemakes;
    
    NSLog(@"remakes: %d", remakes.count);
}

- (void)testGetStoriesNSURLSession
{
    NSURL *storiesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/stories", server]];
    __block BOOL jobDone = NO;
    
    [[self.session dataTaskWithURL:storiesURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataString: %@", dataString);
        
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSLog(@"json class: %@", [[json class] description]);
        NSLog(@"json: %@", json);
        if (jsonError)
        {
            NSLog(@"json error: %@", jsonError.description);
        }
        jobDone = YES;
    }] resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 60);
}

- (void)testGetStoriesWithoutNSURLSession
{
    NSURL *storiesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/stories", server]];
    
    // Getting the stories Data from the server
    NSData *storiesData = [NSData dataWithContentsOfURL:storiesURL];
    
    // Converting data to JSON
    NSError *error;
    NSArray *jsonStoryArray = [NSJSONSerialization JSONObjectWithData:storiesData options:kNilOptions error:&error];
    
    // Creating stories
    NSMutableArray *storyArray = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonStory in jsonStoryArray) {
       
        HMGStory *story = [[HMGStory alloc] init];
        story.name = [jsonStory objectForKey:@"name"];
        story.description = [jsonStory objectForKey:@"description"];
        story.video = [jsonStory objectForKey:@"video"];
        story.thumbnailPath = [jsonStory objectForKey:@"thumbnail"];
        
        // Creating the scenes of the Story
        NSMutableArray *sceneArray = [[NSMutableArray alloc] init];
        NSArray *scenesJSON = [jsonStory objectForKey:@"scenes"];
        for (NSDictionary *sceneJSON in scenesJSON) {
            
            HMGScene *scene = [[HMGScene alloc] init];
            scene.sceneID = [[sceneJSON objectForKey:@"id"] stringValue];
            scene.context = [sceneJSON objectForKey:@"context"];
            scene.script = [sceneJSON objectForKey:@"script"];
            scene.duration = CMTimeMake([[sceneJSON objectForKey:@"duration"] intValue], 1000);
            scene.video = [sceneJSON objectForKey:@"video"];
            scene.thumbnailPath = [sceneJSON objectForKey:@"thumbnail"];
            scene.silhouettePath = [sceneJSON objectForKey:@"silhouette"];
            scene.selfie = [[sceneJSON objectForKey:@"selfie"] boolValue];
            
            [sceneArray addObject:scene];
        }
        story.scenes = sceneArray;
        
        // Creating the dynamic texts of the Story
        NSMutableArray *textArray = [[NSMutableArray alloc] init];
        NSArray *textsJSON = [jsonStory objectForKey:@"texts"];
        for (NSDictionary *textJSON in textsJSON) {
            
            HMGText *text = [[HMGText alloc] init];
            text.textID = [[textJSON objectForKey:@"id"] stringValue];
            text.maxCharacters = [[textJSON objectForKey:@"max_chars"] intValue];
            text.name = [textJSON objectForKey:@"name"];
            text.description = [textJSON objectForKey:@"description"];
            
            [textArray addObject:text];
        }
        story.texts = textArray;
        
        [storyArray addObject:story];
    }
}


- (void)testDownload
{
    NSURL *serverDownload = [NSURL URLWithString:@"http://54.204.34.168:4567/download/output.mp4"];
    NSURLSession *session = [NSURLSession sharedSession];
    __block BOOL jobDone = NO;

    
    NSURLSessionDownloadTask *videoDownloadTask = [session downloadTaskWithURL:serverDownload completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        // Copying the file to a new location
        NSURL *downloadedVideo = [HMGFileManager copyResourceToNewURL:location forFileName:@"download" ofType:@"mp4"];
        
        // Getting the exported video URL and validating if we can save it
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:downloadedVideo])
        {
            // Saving the video. This is an asynchronous process. The completion block (which is implemented here inline) will be invoked once the saving process finished
            [library writeVideoAtPathToSavedPhotosAlbum:downloadedVideo completionBlock:^(NSURL *assetURL, NSError *error){
                if (error)
                {
                    STFail(error.description);
                }
            }];
        }

        
        jobDone = YES;
    }];
    
    [videoDownloadTask resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}


- (void)testRender
{
    NSURL *serverRender = [NSURL URLWithString:@"http://54.204.34.168:4567/render"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *fileOutputName = @"output";
    __block BOOL jobDone = NO;
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test.aep", @"template_project", @"Test", @"template_folder", fileOutputName, @"output", nil];
    
    // Build POST request
    NSURLRequest *request = [HMGNetworkManager createPostRequestURL:serverRender withParams:postParams];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        jobDone = YES;
    }];
    
    [postDataTask resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}


- (void)testUpdateText
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *text = @"My Text";
    __block BOOL jobDone = NO;
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:text, @"dynamic_text", @"Test", @"template_folder", @"DynamicText.txt", @"dynamic_text_file", nil];
    
    // Build POST request
    NSURLRequest *request = [HMGNetworkManager createPostRequestURL:self.serverUpdateTextURL withParams:postParams];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        jobDone = YES;
    }];
    
    [postDataTask resume];
    
    // Waiting 3 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 3);
}


// Testing the upload of a small file (˜145KB)
- (void)testUploadSmallFile
{
    __block BOOL jobDone = NO;
    NSURLSession *session = [NSURLSession sharedSession];

    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test", @"template_folder", @"test.mov", @"segment_file", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.redVideo withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:[request HTTPBody] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);

        jobDone = YES;
    }];
    
    [uploadTask resume];

    // Waiting 3 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 3);
}

// Testing the upload of a big file (˜5MB)
- (void)testUploadBigFile
{
    __block BOOL jobDone = NO;
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSDictionary *uploadParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Test", @"template_folder", @"test.mov", @"segment_file", nil];
    
    NSURLRequest *request = [HMGNetworkManager requestToUploadURL:self.serverUploadURL withFile:self.finishLineVideo withParams:uploadParams];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:[request HTTPBody] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            STFail(error.description);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        STAssertTrue(httpResponse.statusCode == 200, nil);
        
        NSLog(@"%@", response.description);
        jobDone = YES;
    }];
    
    [uploadTask resume];
    
    // Waiting 30 seconds for the above block to complete
    WAIT_WHILE(!jobDone, 30);
}
*/

@end

//
//  HMGHomage.m
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGHomage.h"
#import "HMGLog.h"

@implementation HMGHomage

// Singleton - returns a shared instance of the Homage object
+ (id)sharedHomage
{
    static HMGHomage *sharedHomage = nil;
    @synchronized(self) {
        if (sharedHomage == nil)
            sharedHomage = [[self alloc] init];
    }
    return sharedHomage;
}


- (NSArray *)stories
{
    HMGLogDebug(@"%s started", __PRETTY_FUNCTION__);
    
    // If there are no stories, loading them from the server
    if (!_stories)
    {
        HMGLogDebug(@"Fetching stories from server");
        
        NSURL *storiesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/stories", SERVER]];
        
        // Getting the stories Data from the server
        NSError *serverError;
        NSData *storiesData = [NSData dataWithContentsOfURL:storiesURL options:NSDataReadingMappedAlways error:&serverError];
        if (serverError)
        {
            NSString *errorDescription = [NSString stringWithFormat:@"Trying to fetch data from: %@, resulted with the following error: %@", storiesURL.path, serverError.description];
            HMGLogError(errorDescription);
            [NSException raise:@"ConnectivityException" format:@"%@", errorDescription];
        }
        
        // Converting data to JSON
        NSError *jsonError;
        id storiesJSON = [NSJSONSerialization JSONObjectWithData:storiesData options:kNilOptions error:&jsonError];
        if (jsonError)
        {
            NSString *dataString = [[NSString alloc] initWithData:storiesData encoding:NSUTF8StringEncoding];
            NSString *errorDescription = [NSString stringWithFormat:@"Trying to parse the following string to json: %@, resulted with the following error: %@", dataString, jsonError.description];
            HMGLogError(errorDescription);
            [NSException raise:@"JSONParserException" format:@"%@", errorDescription];
        }
        
        // Parsing a JSON feed can result with a response of NSDictionary (in case of a single JSON object), or NSArray (in case of multiple JSON object, where each instance in the Array is an NSDictionary). Creating an Array in both Cases
        NSArray *jsonStoryArray;
        if ([storiesJSON isKindOfClass:[NSDictionary class]])
        {
            jsonStoryArray = @[storiesJSON];
        }
        else
        {
            jsonStoryArray = storiesJSON;
        }
        
        // Creating stories
        NSMutableArray *storyArray = [[NSMutableArray alloc] init];
        for (NSDictionary *jsonStory in jsonStoryArray) {
            
            HMGStory *story = [[HMGStory alloc] init];
            story.storyID = [[jsonStory objectForKey:@"_id"] objectForKey:@"$oid"];
            story.name = [jsonStory objectForKey:@"name"];
            story.description = [jsonStory objectForKey:@"description"];
            story.level = [[jsonStory objectForKey:@"level"] intValue];
            NSString *videoPath = [jsonStory objectForKey:@"video"];
            story.video = [NSURL URLWithString:videoPath];
            NSString *thumbnailPath = [jsonStory objectForKey:@"thumbnail"];
            story.thumbnailURL = [NSURL URLWithString:thumbnailPath];
            
            // Creating the scenes of the Story
            NSMutableArray *sceneArray = [[NSMutableArray alloc] init];
            NSArray *scenesJSON = [jsonStory objectForKey:@"scenes"];
            for (NSDictionary *sceneJSON in scenesJSON) {
                
                HMGScene *scene = [[HMGScene alloc] init];
                scene.sceneID = [[sceneJSON objectForKey:@"id"] stringValue];
                scene.context = [sceneJSON objectForKey:@"context"];
                scene.script = [sceneJSON objectForKey:@"script"];
                scene.duration = CMTimeMake([[sceneJSON objectForKey:@"duration"] intValue], 1000);
                NSString *videoPath = [sceneJSON objectForKey:@"video"];
                scene.video = [NSURL URLWithString:videoPath];
                NSString *thumbnailPath = [sceneJSON objectForKey:@"thumbnail"];
                scene.thumbnailURL = [NSURL URLWithString:thumbnailPath];
                NSString *silhouettePath = [sceneJSON objectForKey:@"silhouette"];
                if (silhouettePath && silhouettePath != (id)[NSNull null])
                {
                    scene.silhouetteURL = [NSURL URLWithString:silhouettePath];
                }
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
        
        _stories = storyArray;
    }
    
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);

    return _stories;
}

- (HMGUser *)me
{
    HMGUser *dummyUser = [[HMGUser alloc] init];
    
    dummyUser.userName = @"yoavca";
    dummyUser.email = @"yoav@homage.it";
    dummyUser.firstUse = NO;
    dummyUser.publicUser = YES;
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"pb_ap_button_background.png" ofType:nil];
    dummyUser.image = [UIImage imageWithContentsOfFile:imagePath];
    
    return dummyUser;
}

- (NSArray *)myRemakes
{
    NSMutableArray *remakes = [[NSMutableArray alloc] init];
    
    HMGRemake *remake1 = [[HMGRemake alloc] init];
    HMGRemake *remake2 = [[HMGRemake alloc] init];
    HMGRemake *remake3 = [[HMGRemake alloc] init];
    HMGRemake *remake4 = [[HMGRemake alloc] init];
    
    NSString *image1Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"wrong_meeting.png" ofType:nil];
    remake1.video = [NSURL URLWithString:@"https://s3.amazonaws.com/homageapp/Final+Videos/final_Star+Wars_52ceacccdb25450c2c000001.mp4"];
    remake1.thumbnail = [UIImage imageWithContentsOfFile:image1Path];
    remake1.status = HMGRemakeStatusInProgress;
    
    NSString *image2Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Family_Guy_Wrong_Meeting.png" ofType:nil];
    remake2.video = [NSURL URLWithString:@"https://s3.amazonaws.com/homageapp/Final+Videos/final_Star+Wars_52cedc28db254513fc000004.mp4"];
    remake2.thumbnail = [UIImage imageWithContentsOfFile:image2Path];
    remake2.status = HMGRemakeStatusRendering;
    
    NSString *image3Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"wrong_meeting.png" ofType:nil];
    remake3.video = [NSURL URLWithString:@"https://s3.amazonaws.com/homageapp/Final+Videos/final_Star+Wars_52ceacccdb25450c2c000001.mp4"];
    remake3.thumbnail = [UIImage imageWithContentsOfFile:image3Path];
    remake3.status = HMGRemakeStatusDone;
    
    NSString *image4Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Family_Guy_Wrong_Meeting.png" ofType:nil];
    remake4.video = [NSURL URLWithString:@"https://s3.amazonaws.com/homageapp/Final+Videos/final_Star+Wars_52cedc28db254513fc000004.mp4"];
    remake4.thumbnail = [UIImage imageWithContentsOfFile:image4Path];
    remake4.status = HMGRemakeStatusNew;
    
    [remakes addObject:remake1];
    [remakes addObject:remake2];
    [remakes addObject:remake3];
    [remakes addObject:remake4];
    
    return remakes;
}

@end

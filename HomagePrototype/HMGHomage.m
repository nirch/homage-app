//
//  HMGHomage.m
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGHomage.h"
#import "HMGLog.h"
#import "HMGStory.h"
#import "HMGUser.h"
#import "HMGRemake.h"
#import "HMGScene.h"
#import "HMGText.h"

@implementation HMGHomage

static NSString * const server = @"http://54.204.34.168:4567";

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
        
        NSURL *storiesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/stories", server]];
        
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
        
        _stories = storyArray;
    }
    
    
    HMGLogDebug(@"%s ended", __PRETTY_FUNCTION__);

    return _stories;
}

@end

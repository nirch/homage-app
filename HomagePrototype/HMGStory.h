//
//  HMGStory.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGStory : NSObject

typedef enum {
    HMGStoryLevelEasy,
    HMGStoryLevelMedium,
    HMGStoryLevelHard
} HMGStoryLevel;


@property (strong, nonatomic) NSString *storyID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (nonatomic) HMGStoryLevel level;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSArray *texts;
@property (nonatomic) NSUInteger version;

@end

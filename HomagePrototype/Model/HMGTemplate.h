//
//  Template.h
//  HomagePrototype
//
//  Created by Tomer Harry on 8/29/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGTemplate : NSObject <NSCoding>

typedef enum {
    Easy,
    Medium,
    Hard
} HMGTemplateLevel;

@property (strong, nonatomic) NSString *templateID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (nonatomic) HMGTemplateLevel level;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) NSArray *remakes;
@property (strong, nonatomic) NSArray *segments;
@property (strong, nonatomic) NSURL *soundtrack;
@property (strong, nonatomic) NSString *thumbnailPath;
@property (strong, nonatomic) UIImage *thumbnail;

-(NSString *) levelDescription;
@property (strong, nonatomic) NSString *templateFolder;
@property (strong, nonatomic) NSString *templateProject;




@end

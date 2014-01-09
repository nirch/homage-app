//
//  HMGScene.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>

@interface HMGScene : NSObject

@property (strong, nonatomic) NSString *sceneID;
@property (strong, nonatomic) NSString *context;
@property (strong, nonatomic) NSString *script;
@property (nonatomic) CMTime duration;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) NSURL *silhouetteURL;
@property (strong, nonatomic) UIImage *silhouette;
@property (nonatomic) BOOL selfie;

- (BOOL)isGreenScreenScene;

@end

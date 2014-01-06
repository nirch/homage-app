//
//  HMGRemake.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGFootage.h"

@interface HMGRemake : NSObject

@property (strong, nonatomic) NSString *remakeID;
@property (strong, nonatomic) NSString *storyID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSDictionary *footages;
@property (strong, nonatomic) NSDictionary *texts;
@property (strong, nonatomic) NSURL *video;
@property (strong, nonatomic) UIImage *thumbnail;

- (void)addFootage:(NSURL *)video withSceneID:(NSString *)sceneID;
- (void)addText:(NSString *)text withTextID:(NSString *)textID;

@end

//
//  HMGHomage.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGUser.h"
#import "HMGStory.h"
#import "HMGUser.h"
#import "HMGRemake.h"
#import "HMGScene.h"
#import "HMGText.h"


@interface HMGHomage : NSObject

@property (strong, nonatomic) NSArray *stories; // Array of HMGStory
@property (strong, nonatomic) NSArray *myRemakes; // Array of HMGRemake
@property (strong, nonatomic) HMGUser *me;

// Singleton
+ (id)sharedHomage;

@end

//
//  HMGScene.m
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGScene.h"

@implementation HMGScene


- (BOOL)isGreenScreenScene
{
    if (self.silhouetteURL == nil || self.silhouetteURL == (id)[NSNull null])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end

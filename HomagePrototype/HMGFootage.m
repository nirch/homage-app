//
//  HMGFootage.m
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import "HMGFootage.h"

@implementation HMGFootage

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.uploaded = NO;
        self.processed = NO;
    }
    
    return self;
}

@end

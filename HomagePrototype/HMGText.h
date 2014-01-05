//
//  HMGText.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGText : NSObject

@property (strong, nonatomic) NSString *textID;
@property (nonatomic) NSUInteger maxCharacters;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

@end

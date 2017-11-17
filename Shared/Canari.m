//
//  Canari.m
//  Shared
//
//  Created by Olivier Larivain on 11/16/17.
//  Copyright © 2017 Olivier Larivain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Canari: NSObject
@end

@implementation Canari
+ (void)load {
    [super load];
    NSLog(@"somebody just got linked!");
}
@end

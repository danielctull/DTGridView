//
//  DTGridViewAppDelegate.m
//  DTGridView
//
//  Created by Daniel Tull on 10.02.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import "DTGridViewAppDelegate.h"

@implementation DTGridViewAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end

//
//  DTGridViewAppDelegate.h
//  DTGridView
//
//  Created by Daniel Tull on 10.02.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTGridViewAppDelegate : NSObject <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


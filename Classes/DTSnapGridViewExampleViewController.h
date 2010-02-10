//
//  DTSnapGridViewExampleViewController.h
//  DTKit
//
//  Created by Daniel Tull on 09.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSnapGridView.h"

@interface DTSnapGridViewExampleViewController : UIViewController {
	DTSnapGridView *snapGridView;
}

@property (nonatomic, retain) IBOutlet DTSnapGridView *snapGridView;

@end

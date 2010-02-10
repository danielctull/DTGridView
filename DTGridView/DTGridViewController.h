//
//  DTGridViewController.h
//  DTKit
//
//  Created by Daniel Tull on 19.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"

@interface DTGridViewController : UIViewController <DTGridViewDataSource, DTGridViewDelegate> {
	DTGridView *gridView;
}

@property (nonatomic, retain) DTGridView *gridView;

@end


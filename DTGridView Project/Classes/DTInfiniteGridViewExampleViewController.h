//
//  DTInfiniteGridViewExampleViewController.h
//  DTKit
//
//  Created by Daniel Tull on 11.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTInfiniteGridView.h"

@interface DTInfiniteGridViewExampleViewController : UIViewController <DTGridViewDelegate, DTGridViewDataSource> {
	DTInfiniteGridView *gridView;
}

@end

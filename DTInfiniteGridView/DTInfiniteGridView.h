//
//  DTInfiniteGridView.h
//  DTKit
//
//  Created by Daniel Tull on 11.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"


@interface DTInfiniteGridView : DTGridView {	
	NSInteger fakeNumberOfRows;
	NSMutableDictionary *numberOfColumns;
	
	NSInteger segmentMultiplier;
}

@property (nonatomic, assign) BOOL infiniteVerticalScrolling, infiniteHorizontalScrolling;

@end

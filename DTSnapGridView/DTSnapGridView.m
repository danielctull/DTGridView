//
//  DTSnapGridView.m
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSnapGridView.h"

@interface DTSnapGridView ()
@end

@implementation DTSnapGridView

@dynamic delegate;
- (void)dealloc {
	[decelerationTimer release];
	decelerationTimer = nil;
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	for (UIView *aView in self.subviews) {
				
		if ([aView isKindOfClass:[DTSnapGridViewCell class]]) {
			
			DTSnapGridViewCell *v = (DTSnapGridViewCell *)aView;
			
			v.slideAmount = (2*(v.center.x-self.contentOffset.x) + 2*v.frame.size.width - self.frame.size.width)/(self.frame.size.width - v.frame.size.width);
			
			if (v.slideAmount > 0.5 && v.slideAmount <= 1.5 && ![v isEqual:selectedCell]) {
				selectedCell = v;
			}
		}
	}
}


- (void)didEndMoving {
	[self scrollViewToRow:0 column:selectedCell.xPosition scrollPosition:DTGridViewScrollPositionMiddleCenter animated:YES];
}

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column {
	NSInteger w = (NSInteger)self.frame.size.width/3.0f;
	return (CGFloat)w;
}

@end

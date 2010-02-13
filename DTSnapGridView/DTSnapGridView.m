//
//  DTSnapGridView.m
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSnapGridView.h"

@interface DTSnapGridView ()

- (void)decelerationTimer:(NSTimer *)timer;
- (void)draggingTimer:(NSTimer *)timer;

@property (nonatomic, assign) IBOutlet id<DTSnapGridViewDelegate> delegate;
@property (nonatomic, retain) NSTimer *decelerationTimer, *draggingTimer;

@end

@implementation DTSnapGridView

@dynamic delegate;
@synthesize decelerationTimer, draggingTimer;

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
	
	
	if (!self.draggingTimer && !self.decelerationTimer && self.dragging)
		self.draggingTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(draggingTimer:) userInfo:nil repeats:NO];		
	
	if (!self.decelerationTimer && self.decelerating) {
		self.decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(decelerationTimer:) userInfo:nil repeats:NO];
		[self.draggingTimer invalidate];
		self.draggingTimer = nil;
	}
}

- (void)decelerationTimer:(NSTimer *)timer {
	self.decelerationTimer = nil;
	[self didEndDecelerating];
}

- (void)draggingTimer:(NSTimer *)timer {
	if (self.dragging) {
		self.draggingTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(draggingTimer:) userInfo:nil repeats:NO];
	} else {
		self.draggingTimer = nil;
		[self didEndDragging];
	}
}


- (void)didEndDragging {
	[self scrollViewToRow:0 column:selectedCell.xPosition scrollPosition:DTGridViewScrollPositionMiddleCenter animated:YES];
}

- (void)didEndDecelerating {
	[self scrollViewToRow:0 column:selectedCell.xPosition scrollPosition:DTGridViewScrollPositionMiddleCenter animated:YES];
}

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column {
	NSInteger w = (NSInteger)self.frame.size.width/3;
	return (CGFloat)w;
}

@end

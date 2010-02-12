//
//  DTSnapGridView.m
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSnapGridView.h"


@implementation DTSnapGridView

@dynamic delegate;

- (void)drawRect:(CGRect)rect {
	NSLog(@"%@:%s", self, _cmd);
	[super drawRect:rect];
}

- (void)didLoad {
	for (DTSnapGridViewCell *v in self.subviews) {
		
		NSLog(@"%@:%s %@", self, _cmd, v);
		
		v.slideAmount = (2*(v.center.x-self.contentOffset.x) + 2*v.frame.size.width - self.frame.size.width)/(self.frame.size.width - v.frame.size.width);
		
		if (v.slideAmount > 0.5 && v.slideAmount <= 1.5 && ![v isEqual:selectedCell]) {
			selectedCell = v;
		}
	}
	[super didLoad];
}

- (void)layoutSubviews {
	NSLog(@"%@:%s", self, _cmd);
	[super layoutSubviews];
}/*
	for (DTSnapGridViewCell *v in self.subviews) {
		
		NSLog(@"%@:%s %@", self, _cmd, v);
		
		v.slideAmount = (2*(v.center.x-self.contentOffset.x) + 2*v.frame.size.width - self.frame.size.width)/(self.frame.size.width - v.frame.size.width);
		
		if (v.slideAmount > 0.5 && v.slideAmount <= 1.5 && ![v isEqual:selectedCell]) {
			selectedCell = v;
		}
	}
	[super layoutSubviews];
}
/*	
	for (DTSnapGridViewCell *v in self.subviews) {
		
		NSLog(@"%@:%s %@", self, _cmd, v);
		
		v.slideAmount = (2*(v.center.x-self.contentOffset.x) + 2*v.frame.size.width - self.frame.size.width)/(self.frame.size.width - v.frame.size.width);
		
		if (v.slideAmount > 0.5 && v.slideAmount <= 1.5 && ![v isEqual:selectedCell]) {
			selectedCell = v;
		}
	}
}*/

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column {
	NSInteger w = (NSInteger)self.frame.size.width/3;
	return (CGFloat)w;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[super scrollViewDidEndDecelerating:scrollView];
	[self scrollViewToRow:0 column:selectedCell.xPosition scrollPosition:DTGridViewScrollPositionMiddleCenter animated:YES];
	if ([self.delegate respondsToSelector:@selector(snapGridView:didHighlightIndex:)])
		[self.delegate snapGridView:self didHighlightIndex:selectedCell.xPosition];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[self scrollViewToRow:0 column:selectedCell.xPosition scrollPosition:DTGridViewScrollPositionMiddleCenter animated:YES];
	if (!decelerate)
		if ([self.delegate respondsToSelector:@selector(snapGridView:didHighlightIndex:)])
			[self.delegate snapGridView:self didHighlightIndex:selectedCell.xPosition];
}

@end

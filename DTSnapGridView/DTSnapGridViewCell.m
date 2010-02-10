//
//  DTSnapGridViewCell.m
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSnapGridViewCell.h"

@implementation DTSnapGridViewCell

@synthesize slideAmount;

- (void)setSlideAmount:(CGFloat)amount {
	slideAmount = amount;
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	CGFloat v = self.slideAmount;
	CGFloat s = self.frame.size.width;
	
	for (UIView *view in self.subviews) {
		CGFloat l = view.frame.size.width;
		NSInteger x = (NSInteger)((((v * (s - l)) + l) / 2) - l/2);
		view.frame = CGRectMake((CGFloat)x, view.frame.origin.y, l, view.frame.size.height);
	}
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[self setNeedsLayout];
}

@end

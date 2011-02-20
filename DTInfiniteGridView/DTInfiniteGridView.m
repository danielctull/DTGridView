//
//  DTInfiniteGridView.m
//  DTKit
//
//  Created by Daniel Tull on 11.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTInfiniteGridView.h"


@implementation DTInfiniteGridView

@synthesize infiniteVerticalScrolling, infiniteHorizontalScrolling;

- (id)initWithFrame:(CGRect)frame {
	
	if (!(self = [super initWithFrame:frame])) return nil;
	
	numberOfColumns = [[NSMutableDictionary alloc] init];
	self.showsHorizontalScrollIndicator = NO;
	self.bounces = NO;
	return self;
}

- (NSInteger)realRowNumber:(NSInteger)row {
	if (row >= fakeNumberOfRows)
		return (row % fakeNumberOfRows);
	
	return row;
}

- (NSInteger)realColumnNumber:(NSInteger)column inRow:(NSInteger)row {
	NSInteger theNumberOfColumns = [[numberOfColumns objectForKey:[NSString stringWithFormat:@"%i", row]] intValue];
	
	if (column >= theNumberOfColumns)
		return (column % theNumberOfColumns);
	
	return column;
}

#pragma mark -
#pragma mark Finding stuff from DataSource

- (NSInteger)findNumberOfRows {
	
	fakeNumberOfRows = [self.dataSource numberOfRowsInGridView:self];
	
	if (self.infiniteVerticalScrolling)
		fakeNumberOfRows = fakeNumberOfRows * 2;
	
	return fakeNumberOfRows;
}

- (NSInteger)findNumberOfColumnsForRow:(NSInteger)row {
	NSInteger amount = [self.dataSource numberOfColumnsInGridView:self forRowWithIndex:row];
	segmentMultiplier = 10;
	
	if (!self.infiniteHorizontalScrolling)
		return amount;
	
	[numberOfColumns setObject:[NSNumber numberWithInt:amount] forKey:[NSString stringWithFormat:@"%i", row]];
		
	return (amount * segmentMultiplier);
	
	
}

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column {
	
	if (self.infiniteVerticalScrolling || self.infiniteHorizontalScrolling)
		return [self.dataSource gridView:self widthForCellAtRow:[self realRowNumber:row] column:[self realColumnNumber:column inRow:row]];
	
	return [self.dataSource gridView:self widthForCellAtRow:row column:column];
}

- (CGFloat)findHeightForRow:(NSInteger)row {
	
	if (self.infiniteVerticalScrolling)
		return [self.dataSource gridView:self heightForRow:[self realRowNumber:row]];		

	return [self.dataSource gridView:self heightForRow:row];
}

- (DTGridViewCell *)findViewForRow:(NSInteger)row column:(NSInteger)column {
	if (self.infiniteVerticalScrolling || self.infiniteHorizontalScrolling)
		return [self.dataSource gridView:self viewForRow:[self realRowNumber:row] column:[self realColumnNumber:column inRow:row]];
		
	return [self.dataSource gridView:self viewForRow:row column:column];
}


- (void)layoutSubviews {
	
	CGFloat newX = self.contentOffset.x;
	CGFloat newY = self.contentOffset.y;
	
	if (self.infiniteHorizontalScrolling) {
		
		CGFloat segmentWidth = self.contentSize.width/5;
		
		if (self.contentOffset.x < 2*segmentWidth)
			newX = self.contentOffset.x + segmentWidth;
		else if (self.contentOffset.x > 3*segmentWidth)
			newX = self.contentOffset.x - segmentWidth;		
	}
	
	
	if (self.infiniteVerticalScrolling) {
		
		CGFloat segmentHeight = self.contentSize.height/5;
		
		if (self.contentOffset.y < 2*segmentHeight)
			newY = self.contentOffset.y + segmentHeight;
		else if (self.contentOffset.y > 3*segmentHeight)
			newY = self.contentOffset.y - segmentHeight;	
	}
	
	self.contentOffset = CGPointMake(newX, newY);
	
	[super layoutSubviews];
}

@end

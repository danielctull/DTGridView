//
//  DTSnapGridViewExampleViewController.m
//  DTKit
//
//  Created by Daniel Tull on 09.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTSnapGridViewExampleViewController.h"

@implementation DTSnapGridViewExampleViewController

@synthesize snapGridView;

- (id)init {
	
	if (!(self = [self initWithNibName:@"DTSnapGridViewExampleView" bundle:nil])) return nil;
	
	self.title = @"DTSnapGridView";
	
	return self;
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark DTGridViewDataSource Methods

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gv {
	return 1;
}

- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gv forRowWithIndex:(NSInteger)index {
	return 20;
}

- (CGFloat)gridView:(DTGridView *)gv heightForRow:(NSInteger)rowIndex {
	return gv.frame.size.height;
}

- (CGFloat)gridView:(DTGridView *)gv widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return gv.frame.size.width/3.0;
}

- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
	
	DTGridViewCell *cell = [gv dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"DTSnapGridViewExampleCellView" owner:self options:nil] objectAtIndex:0];
		cell.identifier = @"cell";
	}
	
	return cell;
}


@end

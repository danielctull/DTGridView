//
//  DTGridViewController.m
//  DTKit
//
//  Created by Daniel Tull on 19.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGridViewController.h"


@implementation DTGridViewController

@synthesize gridView;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
	gridView = [[DTGridView alloc] initWithFrame:self.view.bounds];
	self.gridView.autoresizingMask = self.view.autoresizingMask;
	[self.view addSubview:self.gridView];	
}

- (void)viewDidUnload {
	self.gridView = nil;
}

- (void)dealloc {
	[gridView release];
	gridView = nil;
    [super dealloc];
}

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 0;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	return 0;
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	return 0.0;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return 0.0;
}
- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return nil;
}
@end

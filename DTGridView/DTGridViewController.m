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
	NSLog(@"%@:%s", self, _cmd);
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
	DTGridView *gv = [[DTGridView alloc] initWithFrame:self.view.bounds];
	self.gridView = gv;
	[gv release];
	self.gridView.autoresizingMask = self.view.autoresizingMask;
	[self.view addSubview:self.gridView];	
}

- (void)setView:(UIView *)aView {
	NSLog(@"%@:%s", self, _cmd);
	if (!aView)
		if (self.gridView)
			self.gridView = nil;
	
	[super setView:aView];
}

- (void)dealloc {
	NSLog(@"%@:%s", self, _cmd);
	// Crashes with self.gridView! Don't use accessors in dealloc or init.
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

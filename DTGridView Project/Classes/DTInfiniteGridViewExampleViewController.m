//
//  DTInfiniteGridViewExampleViewController.m
//  DTKit
//
//  Created by Daniel Tull on 11.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTInfiniteGridViewExampleViewController.h"


@implementation DTInfiniteGridViewExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"DTInfinteGridView";
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
	gridView = [[DTInfiniteGridView alloc] initWithFrame:self.view.bounds];
	gridView.autoresizingMask = self.view.autoresizingMask;
	gridView.dataSource = self;
	gridView.infiniteVerticalScrolling = NO;
	gridView.infiniteHorizontalScrolling = YES;
	gridView.delegate = self;
	gridView.pagingEnabled = NO;
	[self.view addSubview:gridView];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 1;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	return 4;
}
- (CGFloat)gridView:(DTGridView *)gv heightForRow:(NSInteger)rowIndex {
	return gv.frame.size.height;
}
- (CGFloat)gridView:(DTGridView *)gv widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return gv.frame.size.width / 2;
}
- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	DTGridViewCell *view = [[gv dequeueReusableCellWithIdentifier:@"cell"] retain];
	
	if (!view)
		view = [[DTGridViewCell alloc] initWithReuseIdentifier:@"cell"];
	
	if (columnIndex == 0)
		view.backgroundColor = [UIColor redColor];
	else if (columnIndex == 1)
		view.backgroundColor = [UIColor blueColor];
	else if (columnIndex == 2)
		view.backgroundColor = [UIColor orangeColor];
	else if (columnIndex == 3)
		view.backgroundColor = [UIColor yellowColor];
	else
		NSLog(@"%@:%@ FAIL: %i", self, NSStringFromSelector(_cmd), columnIndex);
	
	return [view autorelease];
}

@end

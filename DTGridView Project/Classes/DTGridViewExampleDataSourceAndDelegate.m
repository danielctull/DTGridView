//
//  DTGridViewExampleDataSourceAndDelegate.m
//  DTKit
//
//  Created by Daniel Tull on 19.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGridViewExampleDataSourceAndDelegate.h"

@implementation DTGridViewExampleDataSourceAndDelegate

- (id)init {
	if (![super init])
		return nil;
	
	colours = [[NSArray alloc] initWithObjects:
					[UIColor redColor],
					[UIColor blueColor],
					[UIColor greenColor],
					[UIColor magentaColor],
					[UIColor yellowColor],
					[UIColor whiteColor],
					[UIColor grayColor],
					[UIColor lightGrayColor],
					[UIColor purpleColor],
					[UIColor orangeColor],
					nil];
	
	return self;
}

- (void)dealloc {
	[pickerView release];
	[navBar release];
	[colours release];
	[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Scroll" style:UIBarButtonItemStyleBordered target:self action:@selector(scroll)] autorelease];	
	self.title = @"DTGridView";
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
	self.gridView.bounces = YES;
}

- (void)scroll {
	
	if (!pickerView)
		pickerView = [[UIPickerView alloc] init];
	
	if (!navBar)
		navBar = [[UINavigationBar alloc] initWithFrame:self.navigationController.navigationBar.frame];
	
//	navBar.title = @"Scroll GridView";

	navBar.barStyle = UIBarStyleBlack;
	UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Scroll GridView"];
	item.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Scroll To" style:UIBarButtonItemStylePlain target:self action:@selector(scrollTo)] autorelease];	
	item.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(endScrolling)] autorelease];	
	[navBar pushNavigationItem:item animated:NO];
	[item release];
	[self.navigationController.navigationBar.superview insertSubview:navBar belowSubview:self.navigationController.navigationBar];
	
	pickerView.dataSource = self;
	pickerView.delegate = self;
	[self.view addSubview:pickerView];
	pickerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	[UIView beginAnimations:@"pickerShow" context:nil];
	self.gridView.contentInset = UIEdgeInsetsMake(pickerView.frame.size.height, 0, 0, 0);//(self.gridView.frame.origin.x, self.gridView.frame.origin.y + pickerView.frame.size.height, self.gridView.frame.size.width, self.gridView.frame.size.height - pickerView.frame.size.height);
	self.gridView.scrollIndicatorInsets = UIEdgeInsetsMake(pickerView.frame.size.height, 0, 0, 0);
	
	//self.gridView.frame = CGRectMake(self.gridView.frame.origin.x, self.gridView.frame.origin.y + pickerView.frame.size.height, self.gridView.frame.size.width, self.gridView.frame.size.height - pickerView.frame.size.height);
	self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
	pickerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, pickerView.frame.size.width, pickerView.frame.size.height);
	
	[UIView commitAnimations];
	
	//[self.gridView scrollViewToRow:1 column:1 scrollPosition:DTGridViewScrollPositionNone animated:YES];
}

- (void)scrollTo {
	[self.gridView scrollViewToRow:[pickerView selectedRowInComponent:0] column:[pickerView selectedRowInComponent:1] scrollPosition:DTGridViewScrollPositionNone animated:YES];
}


- (void)endScrolling {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
	[UIView beginAnimations:@"pickerHide" context:nil];
	self.gridView.contentInset = UIEdgeInsetsZero;
	self.gridView.scrollIndicatorInsets = UIEdgeInsetsZero;
	
	self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
	pickerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
	//self.gridView.frame = CGRectMake(self.gridView.frame.origin.x, self.gridView.frame.origin.y - pickerView.frame.size.height, self.gridView.frame.size.width, self.gridView.frame.size.height + pickerView.frame.size.height);
	[UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 100.0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 25;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i", row];
}

#pragma mark -
#pragma mark DTGridViewDataSource methods

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 25;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	return 25;
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	return 100.0;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return 100.0;
}

- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	
	DTGridViewCell *cell = [gv dequeueReusableCellWithIdentifier:@"cell"];
		
	if (!cell) {
		cell = [[[DTGridViewCell alloc] initWithReuseIdentifier:@"cell"] autorelease];
	}
	
	cell.backgroundColor = [colours objectAtIndex:(random() % 10)];
	
	return cell;
}

#pragma mark -
#pragma mark DTGridViewDelegate methods

- (void)gridView:(DTGridView *)gv selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), [gv cellForRow:rowIndex column:columnIndex]);
	
}

- (void)gridView:(DTGridView *)gridView scrolledToEdge:(DTGridViewEdge)edge {
}

@end

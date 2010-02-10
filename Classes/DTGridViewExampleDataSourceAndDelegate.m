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
	self.gridView.gridDelegate = self;
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

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 100.0;
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//	[self.gridView scrollViewToRow:row column:component scrollPosition:DTGridViewScrollPositionNone animated:YES];
//}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 25;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i", row];
}

- (NSInteger)spacingBetweenRowsInGridView:(DTGridView *)gridView {
	return 7;
}

- (NSInteger)spacingBetweenColumnsInGridView:(DTGridView *)gridView {
	return 4;
}
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
	
	if (rowIndex == 0) {
		if (columnIndex == 0)
			return 120.0;
		else if (columnIndex == 1)
			return 200.0;
		else if (columnIndex == 2)
			return 20.0;
		else if (columnIndex == 3)
			return 60.0;
		else if (columnIndex == 4)
			return 100.0;
	} else if (rowIndex == 1){
		if (columnIndex == 0)
			return 30.0;
		else if (columnIndex == 1)
			return 170.0;
		else if (columnIndex == 2)
			return 200.0;
		else if (columnIndex == 3)
			return 40.0;
		else if (columnIndex == 4)
			return 60.0;
	} else if (rowIndex == 2){
		if (columnIndex == 0)
			return 30.0;
		else if (columnIndex == 1)
			return 160.0;
		else if (columnIndex == 2)
			return 110.0;
		else if (columnIndex == 3)
			return 70.0;
		else if (columnIndex == 4)
			return 130.0;
	} else if (rowIndex == 3) {
		if (columnIndex == 0)
			return 100.0;
		else if (columnIndex == 1)
			return 100.0;
		else if (columnIndex == 2)
			return 100.0;
		else if (columnIndex == 3)
			return 100.0;
		else if (columnIndex == 4)
			return 100.0;
	} else if (rowIndex == 4){
		if (columnIndex == 0)
			return 100.0;
		else if (columnIndex == 1)
			return 100.0;
		else if (columnIndex == 2)
			return 100.0;
		else if (columnIndex == 3)
			return 100.0;
		else if (columnIndex == 4)
			return 100.0;
	} else if (rowIndex == 5){
		if (columnIndex == 0)
			return 100.0;
		else if (columnIndex == 1)
			return 100.0;
		else if (columnIndex == 2)
			return 100.0;
		else if (columnIndex == 3)
			return 100.0;
		else if (columnIndex == 4)
			return 100.0;
	} else if (rowIndex == 6){
		if (columnIndex == 0)
			return 100.0;
		else if (columnIndex == 1)
			return 100.0;
		else if (columnIndex == 2)
			return 100.0;
		else if (columnIndex == 3)
			return 100.0;
		else if (columnIndex == 4)
			return 100.0;
	} else if (rowIndex == 7) {
		if (columnIndex == 0)
			return 100.0;
		else if (columnIndex == 1)
			return 100.0;
		else if (columnIndex == 2)
			return 100.0;
		else if (columnIndex == 3)
			return 100.0;
		else if (columnIndex == 4)
			return 100.0;
	}
	return 150.0;
}

//- (NSNumber *)gridView:(DTGridView *)gridView heightForRowAtIndex:(NSInteger)index;
- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	
	//NSLog(@"gridView: viewForRow:%i column:%i", rowIndex, columnIndex);
	
	DTGridViewCell *view = [[gv dequeueReusableCellWithIdentifier:@"cell"] retain];
	
	//NSLog(@"%s ASKING", _cmd);
	
	if (!view) {
		//NSLog(@"%s NEW CELL", _cmd);
		view = [[DTGridViewCell alloc] initWithReuseIdentifier:@"cell"];
	}
	//view.frame = CGRectMake(0,0,150,150);
	
//	int r = random() % 10;
	
	view.backgroundColor = [colours objectAtIndex:(random() % 10)];
	/*
	if (rowIndex == 0) {
		if (columnIndex == 0)
			view.backgroundColor = [UIColor redColor];
		else if (columnIndex == 1)
			view.backgroundColor = [UIColor blueColor];
		else if (columnIndex == 2)
			view.backgroundColor = [UIColor purpleColor];
		else if (columnIndex == 3)
			view.backgroundColor = [UIColor orangeColor];	
		else if (columnIndex == 4)
			view.backgroundColor = [UIColor whiteColor];
	} else if (rowIndex == 1){
		if (columnIndex == 0)
			view.backgroundColor = [UIColor lightGrayColor];
		else if (columnIndex == 1)
			view.backgroundColor = [UIColor grayColor];
		else if (columnIndex == 2)
			view.backgroundColor = [UIColor redColor];
		else if (columnIndex == 3)
			view.backgroundColor = [UIColor greenColor];	
		else if (columnIndex == 4)
			view.backgroundColor = [UIColor magentaColor];
	} else if (rowIndex == 2){
		if (columnIndex == 0)
			view.backgroundColor = [UIColor redColor];
		else if (columnIndex == 1)
			view.backgroundColor = [UIColor blueColor];
		else if (columnIndex == 2)
			view.backgroundColor = [UIColor purpleColor];
		else if (columnIndex == 3)
			view.backgroundColor = [UIColor orangeColor];	
		else if (columnIndex == 4)
			view.backgroundColor = [UIColor whiteColor];
	} else if (rowIndex == 3) {
		if (columnIndex == 0)
			view.backgroundColor = [UIColor lightGrayColor];
		else if (columnIndex == 1)
			view.backgroundColor = [UIColor grayColor];
		else if (columnIndex == 2)
			view.backgroundColor = [UIColor yellowColor];
		else if (columnIndex == 3)
			view.backgroundColor = [UIColor greenColor];	
		else if (columnIndex == 4)
			view.backgroundColor = [UIColor magentaColor];
	} else if (rowIndex == 4){
			if (columnIndex == 0)
				view.backgroundColor = [UIColor redColor];
			else if (columnIndex == 1)
				view.backgroundColor = [UIColor blueColor];
			else if (columnIndex == 2)
				view.backgroundColor = [UIColor purpleColor];
			else if (columnIndex == 3)
				view.backgroundColor = [UIColor orangeColor];	
			else if (columnIndex == 4)
				view.backgroundColor = [UIColor whiteColor];
		} else if (rowIndex == 5){
			if (columnIndex == 0)
				view.backgroundColor = [UIColor lightGrayColor];
			else if (columnIndex == 1)
				view.backgroundColor = [UIColor grayColor];
			else if (columnIndex == 2)
				view.backgroundColor = [UIColor yellowColor];
			else if (columnIndex == 3)
				view.backgroundColor = [UIColor greenColor];	
			else if (columnIndex == 4)
				view.backgroundColor = [UIColor magentaColor];
		} else if (rowIndex == 6){
			if (columnIndex == 0)
				view.backgroundColor = [UIColor redColor];
			else if (columnIndex == 1)
				view.backgroundColor = [UIColor blueColor];
			else if (columnIndex == 2)
				view.backgroundColor = [UIColor purpleColor];
			else if (columnIndex == 3)
				view.backgroundColor = [UIColor orangeColor];	
			else if (columnIndex == 4)
				view.backgroundColor = [UIColor whiteColor];
		} else if (rowIndex == 7) {
			if (columnIndex == 0)
				view.backgroundColor = [UIColor lightGrayColor];
			else if (columnIndex == 1)
				view.backgroundColor = [UIColor grayColor];
			else if (columnIndex == 2)
				view.backgroundColor = [UIColor yellowColor];
			else if (columnIndex == 3)
				view.backgroundColor = [UIColor greenColor];	
			else if (columnIndex == 4)
				view.backgroundColor = [UIColor magentaColor];
		}
	*/
	return [view autorelease];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	NSLog(@"%@:%s", self, _cmd);
}

- (void)gridView:(DTGridView *)gridView scrolledToEdge:(DTGridViewEdge)edge {
	//NSLog(@"%@:%s", self, _cmd);
}

@end

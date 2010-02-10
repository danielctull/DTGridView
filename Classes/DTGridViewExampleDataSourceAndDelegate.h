//
//  DTGridViewExampleDataSourceAndDelegate.h
//  DTKit
//
//  Created by Daniel Tull on 19.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTGridViewController.h"

@interface DTGridViewExampleDataSourceAndDelegate : DTGridViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSArray *colours;
	UIPickerView *pickerView;
	UINavigationBar *navBar;
}

@end

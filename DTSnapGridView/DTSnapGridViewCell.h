//
//  DTSnapGridViewCell.h
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewCell.h"

@interface DTSnapGridViewCell : DTGridViewCell {
	
	CGFloat slideAmount;
	
}

@property (nonatomic, assign) CGFloat slideAmount;

@end

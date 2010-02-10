//
//  DTLabelsSnapGridViewCell.h
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSnapGridView.h"

@interface DTLabelsSnapGridViewCell : DTSnapGridViewCell {
	UILabel *titleLabel, *subtitleLabel;
	UIColor *selectedTextColor, *textColor;
	
}

@property (nonatomic, retain) UILabel *titleLabel, *subtitleLabel;
@property (nonatomic, retain) UIColor *selectedTextColor, *textColor;
@end

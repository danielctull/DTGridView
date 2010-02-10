//
//  DTGridViewCell.m
//  GridViewTester
//
//  Created by Daniel Tull on 06.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGridViewCell.h"

@implementation DTGridViewCell

@synthesize xPosition, yPosition, identifier, delegate, selected;

@dynamic frame;

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
	
	if (![super initWithFrame:CGRectZero])
		return nil;
	
	identifier = [anIdentifier copy];
	
	return self;
}

- (void)awakeFromNib {
	identifier = nil;
}

- (void)prepareForReuse {
	self.selected = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate gridViewCellWasTouched:self];
	[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)dealloc {
	[identifier release];
    [super dealloc];
}

@end

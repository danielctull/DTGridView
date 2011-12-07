//
//  DTGridViewCell.m
//  GridViewTester
//
//  Created by Daniel Tull on 06.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTGridViewCell.h"
#import "DTGridView.h"

#pragma mark Private Methods
@interface DTGridViewCell ()

@property (nonatomic, retain) NSArray *codedSubviews;

- (DTGridView *)gridView;
@end



@implementation DTGridViewCell

@synthesize xPosition, yPosition, identifier, delegate, selected;
@synthesize highlighted;

@synthesize codedSubviews = _codedSubviews;

@dynamic frame;

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		self.codedSubviews = [self.subviews copy];
	}
	
	return self;
}

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
	
	if (![super initWithFrame:self.frame])
		return nil;
	
	identifier = [anIdentifier copy];
	
	for (UIView *codedSubview in self.codedSubviews) {
		[self addSubview:codedSubview];
	}
	
	return self;
}

- (void)dealloc {
	[identifier release];
	[_codedSubviews release];
    [super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	identifier = nil;
}

- (void)prepareForReuse {
	self.selected = NO;
	self.highlighted = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = YES;
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.highlighted = NO;
	[[self gridView] selectRow:self.yPosition column:self.xPosition scrollPosition:DTGridViewScrollPositionNone animated:YES];
	[self.delegate gridViewCellWasTouched:self];
	[super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Private Methods

- (DTGridView *)gridView {	
	UIResponder *r = [self nextResponder];
	if (![r isKindOfClass:[DTGridView class]]) return nil;
	return (DTGridView *)r;
}

@end

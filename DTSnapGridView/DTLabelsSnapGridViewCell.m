//
//  DTLabelsSnapGridViewCell.m
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTLabelsSnapGridViewCell.h"


@implementation DTLabelsSnapGridViewCell

@synthesize titleLabel, subtitleLabel, selectedTextColor, textColor;

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
    
	if (!(self = [super initWithReuseIdentifier:anIdentifier])) return nil;
	
	titleLabel = [[UILabel alloc] init];
	subtitleLabel = [[UILabel alloc] init];
	selectedTextColor = [UIColor whiteColor];
	textColor = [UIColor whiteColor];
	
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (self.slideAmount <= 0.5 || self.slideAmount > 1.5) {
		self.titleLabel.textColor = self.textColor;
		self.subtitleLabel.textColor = self.textColor;
	} else {
		self.titleLabel.textColor = self.selectedTextColor;
		self.subtitleLabel.textColor = self.selectedTextColor;
	}
}

- (void)prepareForReuse {
	self.frame = CGRectZero;
}

- (void)drawRect:(CGRect)rect {
	
	NSInteger halfHeight = (NSInteger)(self.frame.size.height/2.0);
	
	CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
	self.titleLabel.frame = CGRectMake(0.0f, halfHeight-labelSize.height, labelSize.width, labelSize.height);
	
	labelSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font];
	self.subtitleLabel.frame = CGRectMake(0.0f, halfHeight+1.0f, labelSize.width, labelSize.height);
	
	[self addSubview:self.titleLabel];
	[self addSubview:self.subtitleLabel];
	
	[self layoutSubviews];
}

- (void)dealloc {
	[titleLabel release];
	[subtitleLabel release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ title:%@ frame=(%i %i; %i %i)>", [self class], self.titleLabel.text, (NSInteger)self.frame.origin.x, (NSInteger)self.frame.origin.y, (NSInteger)self.frame.size.width, (NSInteger)self.frame.size.height];
}

@end

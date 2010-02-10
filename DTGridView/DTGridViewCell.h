//
//  DTGridViewCell.h
//  GridViewTester
//
//  Created by Daniel Tull on 06.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewCellInfoProtocol.h"

@protocol DTGridViewCellDelegate;

/*!
 @class DTGridViewCell
 @abstract 
 @discussion 
*/
@interface DTGridViewCell : UIView <DTGridViewCellInfoProtocol> {

	NSInteger xPosition, yPosition;
	NSString *identifier;
	
	BOOL selected;
	
	id<DTGridViewCellDelegate> delegate;
	
}
@property (assign) id delegate;
@property (copy) NSString *identifier;
@property (assign) BOOL selected;
- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)prepareForReuse;
@end

@protocol DTGridViewCellDelegate

-(void)gridViewCellWasTouched:(DTGridViewCell *)gridViewCell;

@end

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
	BOOL highlighted;
	
	id<DTGridViewCellDelegate> delegate;
	
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL highlighted;
- (id)initWithReuseIdentifier:(NSString *)identifier;
- (void)prepareForReuse;
@end

@protocol DTGridViewCellDelegate

-(void)gridViewCellWasTouched:(DTGridViewCell *)gridViewCell;

@end

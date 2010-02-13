//
//  DTSnapGridView.h
//  DTKit
//
//  Created by Daniel Tull on 07.07.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridView.h"
#import "DTSnapGridViewCell.h"

@protocol DTSnapGridViewDelegate;

@interface DTSnapGridView : DTGridView {
	DTSnapGridViewCell *selectedCell;
}
@property (nonatomic, assign) IBOutlet id<DTSnapGridViewDelegate> delegate;
@end

@protocol DTSnapGridViewDelegate <DTGridViewDelegate>
- (void)snapGridView:(DTSnapGridView *)snapGridView didHighlightIndex:(NSInteger)index;
@end

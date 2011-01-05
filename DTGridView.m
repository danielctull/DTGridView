//
//  DTGridView.m
//  GridViewTester
//
//  Created by Daniel Tull on 05.12.2008.
//  Copyright 2008 Daniel Tull. All rights reserved.
//

#import "DTGridView.h"
#import "DTGridViewCellInfoProtocol.h"

NSInteger const DTGridViewInvalid = -1;


@interface DTGridViewCellInfo : NSObject <DTGridViewCellInfoProtocol> {
	NSInteger xPosition, yPosition;
	CGRect frame;
	CGFloat x, y, width, height;
}
@property (nonatomic, assign) CGFloat x, y, width, height;
@end

@implementation DTGridViewCellInfo
@synthesize xPosition, yPosition, x, y, width, height, frame;
- (NSString *)description {
	return [NSString stringWithFormat:@"DTGridViewCellInfo: frame=(%i %i; %i %i) x=%i, y=%i", (NSInteger)self.frame.origin.x, (NSInteger)self.frame.origin.y, (NSInteger)self.frame.size.width, (NSInteger)self.frame.size.height, self.xPosition, self.yPosition];
}
@end

@interface DTGridView ()
- (void)dctInternal_setupInternals;
- (void)loadData;
- (void)checkViews;
- (void)initialiseViews;
- (void)fireEdgeScroll;
- (void)checkNewRowStartingWithCellInfo:(NSObject<DTGridViewCellInfoProtocol> *)info goingUp:(BOOL)goingUp;
- (NSObject<DTGridViewCellInfoProtocol> *)cellInfoForRow:(NSInteger)row column:(NSInteger)col;
- (void)checkRow:(NSInteger)row column:(NSInteger)col goingLeft:(BOOL)goingLeft;


- (void)decelerationTimer:(NSTimer *)timer;
- (void)draggingTimer:(NSTimer *)timer;

@property (nonatomic, retain) NSTimer *decelerationTimer, *draggingTimer;
@end

@implementation DTGridView

@dynamic delegate;
@synthesize dataSource, gridCells, numberOfRows, cellOffset, outset;
@synthesize decelerationTimer, draggingTimer;

- (void)dealloc {
	super.delegate = nil;
	self.dataSource = nil;
	[cellsOnScreen release], cellsOnScreen = nil;
	[gridRows release], gridRows = nil;
	[rowPositions release], rowPositions = nil;
	[rowHeights release], rowHeights = nil;
	[freeCells release], freeCells = nil;
	[cellInfoForCellsOnScreen release], cellInfoForCellsOnScreen = nil;
    [super dealloc];
}

- (void)setGridDelegate:(id <DTGridViewDelegate>)aDelegate {
	self.delegate = aDelegate;
}
- (id <DTGridViewDelegate>)gridDelegate {
	return self.delegate;
}

NSInteger intSort(id info1, id info2, void *context) {
	
	DTGridViewCellInfo *i1 = (DTGridViewCellInfo *)info1;
	DTGridViewCellInfo *i2 = (DTGridViewCellInfo *)info2;

    if (i1.yPosition < i2.yPosition)
        return NSOrderedAscending;
    else if (i1.yPosition > i2.yPosition)
        return NSOrderedDescending;
    else if (i1.xPosition < i2.xPosition)
		return NSOrderedAscending;
	else if (i1.xPosition > i2.xPosition)
        return NSOrderedDescending;
	else
		return NSOrderedSame;
}


- (id)initWithFrame:(CGRect)frame {
	
	if (!(self = [super initWithFrame:frame])) return nil;

	[self dctInternal_setupInternals];
	
	return self;
	
}

- (void)awakeFromNib {
	[self dctInternal_setupInternals];
}

- (void)dctInternal_setupInternals {
	numberOfRows = DTGridViewInvalid;
	columnIndexOfSelectedCell = DTGridViewInvalid;
	rowIndexOfSelectedCell = DTGridViewInvalid;
	
	gridRows = [[NSMutableArray alloc] init];
	rowPositions = [[NSMutableArray alloc] init];
	rowHeights = [[NSMutableArray alloc] init];
	cellsOnScreen = [[NSMutableArray alloc] init];
	
	freeCells = [[NSMutableArray alloc] init];
	
	cellInfoForCellsOnScreen = [[NSMutableArray alloc] init];
}

- (void)setFrame:(CGRect)aFrame {
	
	CGSize oldSize = self.frame.size;
	CGSize newSize = aFrame.size;
	
	if (oldSize.height != newSize.height || oldSize.width != newSize.width) {
		hasResized = YES;
	}
	
	[super setFrame:aFrame];
	
	if (hasResized)  {
		[self setNeedsLayout];
	}
}

- (void)reloadData {
	[self loadData];
	[self setNeedsDisplay];
	[self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
	
	oldContentOffset = 	CGPointMake(0.0, 0.0);
		
	//hasLoadedData = NO;
	
	//if (!hasLoadedData)
	
	[self loadData];
	
	for (UIView *v in self.subviews)
        if ([v isKindOfClass:[DTGridViewCell class]])
             [v removeFromSuperview];
	
	[self initialiseViews];
	
	[self didLoad];
}

- (void)didLoad {
	if ([self.delegate respondsToSelector:@selector(gridViewDidLoad:)])
		[self.delegate gridViewDidLoad:self];
}

- (void)didEndDragging {}
- (void)didEndDecelerating {}
- (void)didEndMoving {}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self checkViews];
	[self fireEdgeScroll];
	
	if (!self.draggingTimer && !self.decelerationTimer && self.dragging)
		self.draggingTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(draggingTimer:) userInfo:nil repeats:NO];		
	
	if (!self.decelerationTimer && self.decelerating) {
		self.decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(decelerationTimer:) userInfo:nil repeats:NO];
		[self.draggingTimer invalidate];
		self.draggingTimer = nil;
	}
}

- (void)decelerationTimer:(NSTimer *)timer {
	self.decelerationTimer = nil;
	[self didEndDecelerating];
	[self didEndMoving];
}

- (void)draggingTimer:(NSTimer *)timer {
	self.draggingTimer = nil;
	[self didEndDragging];
	[self didEndMoving];
}

#pragma mark Adding and Removing Cells

- (void)addCellWithInfo:(NSObject<DTGridViewCellInfoProtocol> *)info {
	
	if (![info isMemberOfClass:[DTGridViewCellInfo class]]) return;
	
	[cellInfoForCellsOnScreen addObject:info];
	
	[cellInfoForCellsOnScreen sortUsingFunction:intSort context:NULL];
	
	DTGridViewCell *cell = [[self findViewForRow:info.yPosition column:info.xPosition] retain];
	[cell setNeedsDisplay];
	cell.xPosition = info.xPosition;
	cell.yPosition = info.yPosition;
	cell.delegate = self;
	cell.frame = info.frame;
	
	if (cell.xPosition == columnIndexOfSelectedCell && cell.yPosition == rowIndexOfSelectedCell)
		cell.selected = YES;
	else
		cell.selected = NO;
	
	[[gridCells objectAtIndex:info.yPosition] replaceObjectAtIndex:info.xPosition withObject:cell];
	
	[self insertSubview:cell atIndex:0];
	
	// remove any existing view at this frame	
	for (UIView *v in self.subviews) {
		if ([v isKindOfClass:[DTGridViewCell class]] &&
			v.frame.origin.x == cell.frame.origin.x &&
			v.frame.origin.y == cell.frame.origin.y &&
			v != cell) {
			
			[v removeFromSuperview];
			break;
		}
	}
	
	[cell release];

}

- (void)removeCellWithInfo:(DTGridViewCellInfo *)info {
	
	
	
	if (info.yPosition > [gridCells count]) return;
	
	NSMutableArray *row = [gridCells objectAtIndex:info.yPosition];
	
	if (info.xPosition > [row count]) return;
	
	DTGridViewCell *cell = [row objectAtIndex:info.xPosition];
	
	if (![cell isKindOfClass:[DTGridViewCell class]]) return;
	
	[cell retain];
	
	[cell removeFromSuperview];
	
	[row replaceObjectAtIndex:info.xPosition withObject:info];
	
	[cellInfoForCellsOnScreen removeObject:info];
	
	// TODO: Should this be set?
	//cell.frame = CGRectZero;
	
	[freeCells addObject:cell];
		
	[cell release];
}

- (CGRect)visibleRect {
    CGRect visibleRect;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.bounds.size;
	return visibleRect;
}

- (BOOL)rowOfCellInfoShouldBeOnShow:(NSObject<DTGridViewCellInfoProtocol> *)info {
	
	CGRect visibleRect = [self visibleRect];
	
	CGRect infoFrame = info.frame;
    
    CGFloat infoBottom = infoFrame.origin.y + infoFrame.size.height;
    CGFloat infoTop = infoFrame.origin.y;
    
    CGFloat visibleBottom = visibleRect.origin.y + visibleRect.size.height;
    CGFloat visibleTop = visibleRect.origin.y;
    
    return (infoBottom >= visibleTop &&
            infoTop <= visibleBottom);
}

- (BOOL)cellInfoShouldBeOnShow:(NSObject<DTGridViewCellInfoProtocol> *)info {
	
	if (!info || ![info isMemberOfClass:[DTGridViewCellInfo class]]) return NO;
	
    CGRect visibleRect = [self visibleRect];
    
    CGFloat infoRight = info.frame.origin.x + info.frame.size.width;
    CGFloat infoLeft = info.frame.origin.x;
    
	CGFloat visibleRight = visibleRect.origin.x + visibleRect.size.width;
    CGFloat visibleLeft = visibleRect.origin.x;
    
    if (infoRight >= visibleLeft &&
		infoLeft <=  visibleRight &&
		[self rowOfCellInfoShouldBeOnShow:info]) return YES;
	
	//NSLog(@"%@ NO: %@", NSStringFromSelector(_cmd), NSStringFromCGRect(info.frame));
	
	return NO;
}


#pragma mark -
#pragma mark Finding Infomation from DataSource

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column {
	return [self.dataSource gridView:self widthForCellAtRow:row column:column];
}

- (NSInteger)findNumberOfRows {
	return [self.dataSource numberOfRowsInGridView:self];
}

- (NSInteger)findNumberOfColumnsForRow:(NSInteger)row {
	return [self.dataSource numberOfColumnsInGridView:self forRowWithIndex:row];
}

- (CGFloat)findHeightForRow:(NSInteger)row {
	return [self.dataSource gridView:self heightForRow:row];
}

- (DTGridViewCell *)findViewForRow:(NSInteger)row column:(NSInteger)column {
	return [self.dataSource gridView:self viewForRow:row column:column];
}
#pragma mark -

- (void)loadData {
	
	hasLoadedData = YES;
	
	if (![self.dataSource respondsToSelector:@selector(numberOfRowsInGridView:)])
		return;
	
	self.numberOfRows = [self findNumberOfRows];
	
	if (!self.numberOfRows)
		return;
	
	[gridRows removeAllObjects];
	[rowHeights removeAllObjects];
	[rowPositions removeAllObjects];
	
	NSMutableArray *cellInfoArrayRows = [[NSMutableArray alloc] init];
	
	CGFloat maxHeight = 0;
	CGFloat maxWidth = 0;
	
	
	for (NSInteger i = 0; i < self.numberOfRows; i++) {
		
		NSInteger numberOfCols = [self findNumberOfColumnsForRow:i];
		
		NSMutableArray *cellInfoArrayCols = [[NSMutableArray alloc] init];
		
		for (NSInteger j = 0; j < numberOfCols; j++) {
			
			
			DTGridViewCellInfo *info = [[DTGridViewCellInfo alloc] init];
			
			info.xPosition = j;
			info.yPosition = i;
			
			
			CGFloat height = [self findHeightForRow:i];
			CGFloat width = [self findWidthForRow:i column:j];
			
			//info.frame.size.height = [dataSource gridView:self heightForRow:i];
			//info.frame.size.width = [dataSource gridView:self widthForCellAtRow:i column:j];
			CGFloat y;
			CGFloat x;
			
			if (i == 0) {
				y = 0.0;
				//info.frame.origin.y = 0.0;
			} else {
				DTGridViewCellInfo *previousCellRow = [[cellInfoArrayRows objectAtIndex:i-1] objectAtIndex:0];
				y = previousCellRow.frame.origin.y + previousCellRow.frame.size.height;
				
				if (cellOffset.y != 0)
					y += cellOffset.y;
			}
			
			if (j == 0) {
				x = 0.0;
			} else {
				DTGridViewCellInfo *previousCellRow = [cellInfoArrayCols objectAtIndex:j-1];
				x = previousCellRow.frame.origin.x + previousCellRow.frame.size.width;
				if (cellOffset.x != 0)
					x += cellOffset.x;
			}
			
			if (maxHeight < y + height)
				maxHeight = y + height;
			
			if (maxWidth < x + width)
				maxWidth = x + width;
			
			info.frame = CGRectMake(x,y,width,height);
			
			[cellInfoArrayCols addObject:info];
			
			[info release];
		}
		
		[cellInfoArrayRows addObject:cellInfoArrayCols];
		[cellInfoArrayCols release];
	}
	
	
	self.contentSize = CGSizeMake(maxWidth, maxHeight);
	
	self.gridCells = cellInfoArrayRows;
	[cellInfoArrayRows release];
	
	if ([self.subviews count] > [self.gridCells count]) {
		// the underlying data must have reduced, time to iterate
		NSSet *gridCellsSet = [NSSet setWithArray:self.gridCells];
		NSArray *subviewsCopy = [self.subviews copy];
		
		for (UIView *cell in subviewsCopy) {
			if (
                [cell isKindOfClass:[DTGridViewCell class]] &&
                ![gridCellsSet member:cell]
                )
            {
				[cell removeFromSuperview];
            }
		}
		
		[subviewsCopy release];
	}
}

- (void)checkViews {
		
	if ([cellInfoForCellsOnScreen count] == 0) {
		[self initialiseViews];
		return;
	}
	
	NSMutableDictionary *leftRightCells = [[NSMutableDictionary alloc] init];
		
	NSArray *orderedCells = [cellInfoForCellsOnScreen copy];
	
	BOOL isGoingUp = NO;
	BOOL isGoingDown = NO;
	BOOL isGoingLeft = NO;
	BOOL isGoingRight = NO;
	
	if (self.contentOffset.y < oldContentOffset.y && self.contentOffset.y >= 0)
		isGoingUp = YES;
	else if (self.contentOffset.y > oldContentOffset.y && self.contentOffset.y + self.frame.size.height < self.contentSize.height)
		isGoingDown = YES;
	else if (hasResized)
		isGoingUp = YES;
	
	if (self.contentOffset.x < oldContentOffset.x && self.contentOffset.x >= 0)
		isGoingLeft = YES;
	else if (self.contentOffset.x > oldContentOffset.x && self.contentOffset.x + self.frame.size.width < self.contentSize.width)
		isGoingRight = YES;
	else if (hasResized)
		isGoingRight = YES;
    
  //  NSLog(@"isGoingUp: %i, isGoingDown: %i, co.y: %f, old.y: %f", isGoingUp, isGoingDown, self.contentOffset.y, oldContentOffset.y);
	
	hasResized = NO;
	oldContentOffset = self.contentOffset;
	
	for (DTGridViewCellInfo *info in orderedCells) {
		
		if (isGoingLeft){
			if (info.xPosition > 0 && info.frame.origin.x > self.contentOffset.x)
				if (![leftRightCells objectForKey:[NSString stringWithFormat:@"%i", info.yPosition]])
					[leftRightCells setObject:info forKey:[NSString stringWithFormat:@"%i", info.yPosition]];
				else if ([[leftRightCells objectForKey:[NSString stringWithFormat:@"%i", info.yPosition]] xPosition] > info.xPosition)
					[leftRightCells setObject:info forKey:[NSString stringWithFormat:@"%i", info.yPosition]];
					
		} else if (isGoingRight) {
			if ([[self.gridCells objectAtIndex:info.yPosition] count] - 1 > info.xPosition && info.frame.origin.x + info.frame.size.width < self.contentOffset.x + self.frame.size.width)
				if (![leftRightCells objectForKey:[NSString stringWithFormat:@"%i", info.yPosition]])
					[leftRightCells setObject:info forKey:[NSString stringWithFormat:@"%i", info.yPosition]];
				else if ([[leftRightCells objectForKey:[NSString stringWithFormat:@"%i", info.yPosition]] xPosition] < info.xPosition)
					[leftRightCells setObject:info forKey:[NSString stringWithFormat:@"%i", info.yPosition]];
		}
		
		if (![self cellInfoShouldBeOnShow:info])
			[self removeCellWithInfo:info];
		
	}
	
	if (isGoingLeft) {
		for (NSString *yPos in [leftRightCells allKeys]) {			
			DTGridViewCellInfo *info = [leftRightCells objectForKey:yPos];
			[self checkRow:info.yPosition column:info.xPosition goingLeft:YES];
		}
		
	} else if (isGoingRight) {
		for (NSString *yPos in [leftRightCells allKeys]) {
			DTGridViewCellInfo *info = [leftRightCells objectForKey:yPos];
			[self checkRow:info.yPosition column:info.xPosition goingLeft:NO];
		}
	}
		
	if (isGoingUp)
		[self checkNewRowStartingWithCellInfo:[orderedCells objectAtIndex:0] goingUp:YES];
	else if (isGoingDown)
		[self checkNewRowStartingWithCellInfo:[orderedCells lastObject] goingUp:NO];
	
	
	[leftRightCells release];
	[orderedCells release];
}

- (void)initialiseViews {
	
	for (NSInteger i = 0; i < [cellInfoForCellsOnScreen count]; i++) {
		
		DTGridViewCellInfo *info = [cellInfoForCellsOnScreen objectAtIndex:i];
		
		if (![self cellInfoShouldBeOnShow:info])
			[self removeCellWithInfo:info];
		
	}
	
	for (NSInteger i = 0; i < [gridCells count]; i++) {
		
		NSMutableArray *row = [gridCells objectAtIndex:i];
		
		for (NSInteger j = 0; j < [row count]; j++) {	
			
			id object = [row objectAtIndex:j];
			
			if ([object isMemberOfClass:[DTGridViewCellInfo class]]) {
				
				DTGridViewCellInfo *info = (DTGridViewCellInfo *)object;
				
				if ([self cellInfoShouldBeOnShow:info])
					[self addCellWithInfo:info];
				
			}
		}
	}
}

- (void)checkRow:(NSInteger)row column:(NSInteger)col goingLeft:(BOOL)goingLeft {
	
	NSObject<DTGridViewCellInfoProtocol> *info = [self cellInfoForRow:row column:col];
	
	if (!info) return;
	
	if ([self cellInfoShouldBeOnShow:info])
		[self addCellWithInfo:info];
		
	if (goingLeft) {
		if (info.frame.origin.x > self.contentOffset.x)
			[self checkRow:row column:(col - 1) goingLeft:goingLeft];
	} else {
		if (info.frame.origin.x + info.frame.size.width < self.contentOffset.x + self.frame.size.width)
			[self checkRow:row column:(col + 1) goingLeft:goingLeft];
	}
}

- (NSObject<DTGridViewCellInfoProtocol> *)cellInfoForRow:(NSInteger)row column:(NSInteger)col {
	
	if (row < 0 || col < 0) return nil;
	
	if ([self.gridCells count] <= row) return nil;
	
	NSArray *rowArray = [self.gridCells objectAtIndex:row];
	
	if ([rowArray count] <= col) return nil;
	
	return (NSObject<DTGridViewCellInfoProtocol> *)[rowArray objectAtIndex:col];
}

- (void)checkNewRowStartingWithCellInfo:(NSObject<DTGridViewCellInfoProtocol> *)info goingUp:(BOOL)goingUp {
	
    //NSLog(@"%@", info);
    
	if (!info) return;
		
	if (![self rowOfCellInfoShouldBeOnShow:info]) return;
	
	NSObject<DTGridViewCellInfoProtocol> *infoToCheck = info;
	
	NSInteger row = info.yPosition;
	NSInteger total = [[self.gridCells objectAtIndex:row] count];
	NSInteger goingRightPosition = info.xPosition;
	NSInteger goingLeftPosition = info.xPosition;
	BOOL goingLeft = NO;
	
	while (![self cellInfoShouldBeOnShow:infoToCheck]) {
				
		goingLeft = !goingLeft;
				
		if (goingLeft)
			infoToCheck = [self cellInfoForRow:row column:--goingLeftPosition];
		else
			infoToCheck = [self cellInfoForRow:row column:++goingRightPosition];
				
		if (goingRightPosition > total)
			return;
	}
	
	if ([infoToCheck isEqual:info]) {
		[self checkRow:infoToCheck.yPosition column:infoToCheck.xPosition goingLeft:YES];
		[self checkRow:infoToCheck.yPosition column:infoToCheck.xPosition goingLeft:NO];
	} else {
		[self checkRow:infoToCheck.yPosition column:infoToCheck.xPosition goingLeft:goingLeft];
	}

	NSObject<DTGridViewCellInfoProtocol> *nextInfo = nil;
	
	if (goingUp)
		nextInfo = [self cellInfoForRow:info.yPosition - 1 column:info.xPosition];
	else
		nextInfo = [self cellInfoForRow:info.yPosition + 1 column:info.xPosition];
		
	if (nextInfo)
		[self checkNewRowStartingWithCellInfo:nextInfo goingUp:goingUp];
}

#pragma mark Public methods

- (DTGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
	
	for (DTGridViewCell *c in freeCells) {
		if ([c.identifier isEqualToString:identifier]) {
			[c retain];
			[freeCells removeObject:c];
			[c prepareForReuse];
			return [c autorelease];
		}
	}
	
	return nil;
}

- (DTGridViewCell *)cellForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	
	for (UIView *v in self.subviews) {
		if ([v isKindOfClass:[DTGridViewCell class]]) {
			DTGridViewCell *c = (DTGridViewCell *)v;
			if (c.xPosition == columnIndex && c.yPosition == rowIndex)
				return c;
		}
	}
	
	return nil;
}

- (void)scrollViewToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex scrollPosition:(DTGridViewScrollPosition)position animated:(BOOL)animated {
	
	CGFloat xPos = 0, yPos = 0;
	
	CGRect cellFrame = [[[self.gridCells objectAtIndex:rowIndex] objectAtIndex:columnIndex] frame];		
	
	// working out x co-ord
	
	if (position == DTGridViewScrollPositionTopLeft || position == DTGridViewScrollPositionMiddleLeft || position == DTGridViewScrollPositionBottomLeft)
		xPos = cellFrame.origin.x;
	
	else if (position == DTGridViewScrollPositionTopRight || position == DTGridViewScrollPositionMiddleRight || position == DTGridViewScrollPositionBottomRight)
		xPos = cellFrame.origin.x + cellFrame.size.width - self.frame.size.width;
	
	else if (position == DTGridViewScrollPositionTopCenter || position == DTGridViewScrollPositionMiddleCenter || position == DTGridViewScrollPositionBottomCenter)
		xPos = (cellFrame.origin.x + (cellFrame.size.width / 2)) - (self.frame.size.width / 2);
	
	else if (position == DTGridViewScrollPositionNone) {
		
		BOOL isBig = NO;
		
		if (cellFrame.size.width > self.frame.size.width)
			isBig = YES;
		
		if ((cellFrame.origin.x < self.contentOffset.x)
		&& ((cellFrame.origin.x + cellFrame.size.width) > (self.contentOffset.x + self.frame.size.width)))
			xPos = self.contentOffset.x;
		
		else if (cellFrame.origin.x < self.contentOffset.x)
			if (isBig)
				xPos = (cellFrame.origin.x + cellFrame.size.width) - self.frame.size.width;
			else 
				xPos = cellFrame.origin.x;
		
			else if ((cellFrame.origin.x + cellFrame.size.width) > (self.contentOffset.x + self.frame.size.width))
				if (isBig)
					xPos = cellFrame.origin.x;
				else
					xPos = (cellFrame.origin.x + cellFrame.size.width) - self.frame.size.width;
				else
					xPos = self.contentOffset.x;
	}
	
	// working out y co-ord
	
	if (position == DTGridViewScrollPositionTopLeft || position == DTGridViewScrollPositionTopCenter || position == DTGridViewScrollPositionTopRight) {
		yPos = cellFrame.origin.y;
		
	} else if (position == DTGridViewScrollPositionBottomLeft || position == DTGridViewScrollPositionBottomCenter || position == DTGridViewScrollPositionBottomRight) {
		yPos = cellFrame.origin.y + cellFrame.size.height - self.frame.size.height;
		
	} else if (position == DTGridViewScrollPositionMiddleLeft || position == DTGridViewScrollPositionMiddleCenter || position == DTGridViewScrollPositionMiddleRight) {
		yPos = (cellFrame.origin.y + (cellFrame.size.height / 2)) - (self.frame.size.height / 2);
		
	} else if (position == DTGridViewScrollPositionNone) {
		BOOL isBig = NO;
		
		if (cellFrame.size.height > self.frame.size.height)
			isBig = YES;
		
		if ((cellFrame.origin.y < self.contentOffset.y)
		&& ((cellFrame.origin.y + cellFrame.size.height) > (self.contentOffset.y + self.frame.size.height)))
			yPos = self.contentOffset.y;
		
		else if (cellFrame.origin.y < self.contentOffset.y)
			if (isBig)
				yPos = (cellFrame.origin.y + cellFrame.size.height) - self.frame.size.height;
			else
				yPos = cellFrame.origin.y;
			else if ((cellFrame.origin.y + cellFrame.size.height) > (self.contentOffset.y + self.frame.size.height))
				if (isBig)
					yPos = cellFrame.origin.y;
				else
					yPos = (cellFrame.origin.y + cellFrame.size.height) - self.frame.size.height;
				else
					yPos = self.contentOffset.y;
	}
	
	if (xPos == self.contentOffset.x && yPos == self.contentOffset.y)
		return;
	
	if (xPos > self.contentSize.width - self.frame.size.width)
		xPos = self.contentSize.width - self.frame.size.width;
	else if (xPos < 0)
		xPos = 0.0;
	
	if (yPos > self.contentSize.height - self.frame.size.height)
		yPos = self.contentSize.height - self.frame.size.height;
	else if (yPos < 0)
		yPos = 0.0;	
	
	[self scrollRectToVisible:CGRectMake(xPos, yPos, self.frame.size.width, self.frame.size.height) animated:animated];
	
	if (!animated)
		[self checkViews];
	
	if ([self.delegate respondsToSelector:@selector(gridView:didProgrammaticallyScrollToRow:column:)])
		[self.delegate gridView:self didProgrammaticallyScrollToRow:rowIndex column:columnIndex];
		
	
}

- (void)selectRow:(NSInteger)rowIndex column:(NSInteger)columnIndex scrollPosition:(DTGridViewScrollPosition)position animated:(BOOL)animated {
	
	for (UIView *v in self.subviews) {
		if ([v isKindOfClass:[DTGridViewCell class]]) {
			DTGridViewCell *c = (DTGridViewCell *)v;
			if (c.xPosition == columnIndex && c.yPosition == rowIndex)
				c.selected = YES;
			else if (c.xPosition == columnIndexOfSelectedCell && c.yPosition == rowIndexOfSelectedCell)
				c.selected = NO;
		}
	}
	rowIndexOfSelectedCell = rowIndex;
	columnIndexOfSelectedCell = columnIndex;
	
	[self scrollViewToRow:rowIndex column:columnIndex scrollPosition:position animated:animated];
}

- (void)fireEdgeScroll {
	
	if (self.pagingEnabled)
		if ([self.delegate respondsToSelector:@selector(pagedGridView:didScrollToRow:column:)])
			[self.delegate pagedGridView:self didScrollToRow:((NSInteger)(self.contentOffset.y / self.frame.size.height)) column:((NSInteger)(self.contentOffset.x / self.frame.size.width))];
	
	if ([self.delegate respondsToSelector:@selector(gridView:scrolledToEdge:)]) {
		
		if (self.contentOffset.x <= 0)
			[self.delegate gridView:self scrolledToEdge:DTGridViewEdgeLeft];
		
		if (self.contentOffset.x >= self.contentSize.width - self.frame.size.width)
			[self.delegate gridView:self scrolledToEdge:DTGridViewEdgeRight];
		
		if (self.contentOffset.y <= 0)
			[self.delegate gridView:self scrolledToEdge:DTGridViewEdgeTop];
		
		if (self.contentOffset.y >= self.contentSize.height - self.frame.size.height)
			[self.delegate gridView:self scrolledToEdge:DTGridViewEdgeBottom];
	}
}

- (void)gridViewCellWasTouched:(DTGridViewCell *)cell {
	
	[self bringSubviewToFront:cell];
	
	if ([self.delegate respondsToSelector:@selector(gridView:selectionMadeAtRow:column:)])
		[self.delegate gridView:self selectionMadeAtRow:cell.yPosition column:cell.xPosition];
}


#pragma mark -
#pragma mark Accessors

- (NSInteger)numberOfRows {
	if (numberOfRows == DTGridViewInvalid) {
		numberOfRows = [self.dataSource numberOfRowsInGridView:self];
	}
	
	return numberOfRows;
}

@end


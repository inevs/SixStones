#import "Board.h"
#import "Stone.h"


@implementation Board

- (id)init {
	self = [super init];
	if (self) {
		_placedStones = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)placeStone:(Stone *)stone atPosition:(CGPoint)position {
	stone.position = position;
	[_placedStones addObject:stone];
}

- (NSSet *)placedStones {
	return [_placedStones copy];
}

- (Stone *)stone:(Stone *)stone neighbourInDirection:(CGPoint)direction {
	NSUInteger index = [_placedStones indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return CGPointEqualToPoint([obj position], CGPointMake(stone.position.x + direction.x, stone.position.y + direction.y));
	}];
	return index == NSNotFound ? nil : _placedStones[index];
}

- (Stone *)farthestStoneInRow:(NSSet *)row inDirection:(CGPoint)direction {
	NSString *key;
	BOOL ascending = NO;
	if (CGPointEqualToPoint(direction, Left)) {
		key = @"position.x";
		ascending = NO;
	}
	if (CGPointEqualToPoint(direction, Right)) {
		key = @"position.x";
		ascending = YES;
	}
	if (CGPointEqualToPoint(direction, Top)) {
		key = @"position.y";
		ascending = NO;
	}
	if (CGPointEqualToPoint(direction, Bottom)) {
		key = @"position.y";
		ascending = YES;
	}
	NSArray *sortedRow = [row sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
	return [sortedRow lastObject];
}

- (NSSet *)rowsWithNeighbourStonesInSameRowWithStone:(Stone *)stone {
	NSMutableSet *neighbours = [[NSMutableSet alloc] init];
	CGPoint directions[] = {Left, Right, Top, Bottom};
	for (int i = 0; i < 4; i++) {
		NSSet *row = [self rowWithNeighboursOfStone:stone inDirection:directions[i]];
		[neighbours addObject:row];
	}
	return neighbours;
}

- (NSSet *)rowWithNeighboursOfStone:(Stone *)stone inDirection:(CGPoint)direction {
	NSMutableSet *row = [[NSMutableSet alloc] init];
	Stone *s = [self stone:stone neighbourInDirection:direction];
	while (s != nil) {
		[row addObject:s];
		s = [self stone:s neighbourInDirection:direction];
	}
	return row;
}
@end
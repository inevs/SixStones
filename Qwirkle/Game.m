#import "Game.h"
#import "Stone.h"
#import "Player.h"
#import "PointGeometry.h"
#import "Board.h"
#import "DropLocation.h"

#define PlayerStonesPerMove 6
#define PlayerCount 1

@interface Game ()
@property (nonatomic, strong) NSMutableArray *heap;
- (NSMutableArray *)buildHeap;
@end

@implementation Game {
	NSMutableArray *_players;
}

- (id)init {
	self = [super init];
	if (self) {
		[self resetGame];
	}
	return self;
}

- (Board *)board {
	return _board;
}

- (void)resetGame {
	self.heap = [self buildHeap];
	_players = [self initializePlayers];
	_dropLocations = [self initializeDropLocations];
	_board = [[Board alloc] init];
	_currentMoveStones = [[NSMutableArray alloc] init];
	[self.delegate gameDidResetState:self];
}

- (NSMutableArray *)initializeDropLocations {
	NSMutableArray *dropLocations = [[NSMutableArray alloc] init];
	[dropLocations addObject:[DropLocation dropLocationWithPositionX:0 positionY:0]];
	return dropLocations;
}

- (NSMutableArray *)initializePlayers {
	NSMutableArray *players = [[NSMutableArray alloc] init];
	for (int i = 0; i < PlayerCount; i++) {
		Player *player = [self initializePlayer];
		[players addObject:player];
	}
	return players;
}

- (Player *)initializePlayer {
	Player *player = [[Player alloc] init];
	[self fillStonesForPlayer:player];
	return player;
}

- (void)fillStonesForPlayer:(Player *)player {
	for (int i = [player.stones count]; i < PlayerStonesPerMove && [_heap count] > 0; i++) {
		Stone *stone = [self.heap lastObject];
		[player addStone:stone];
		[self.heap removeObjectIdenticalTo:stone];
	}
}

- (NSMutableArray *)buildHeap {
	NSMutableArray *heap = [NSMutableArray array];
	[self fillArray:heap];
	[self randomizeArray:heap];
	return heap;
}

- (void)fillArray:(NSMutableArray *)array {
	for (int anzahl = 0; anzahl < 3; anzahl++) {
		for (int color = 0; color < 6; color++) {
			for (int shape = 0; shape < 6; shape++) {
				Stone *stone = [Stone stoneWithShape:(QwirkleShape) shape color:(QwirkleColor) color];
				[array addObject:stone];
			}
		}
	}
}

- (void)randomizeArray:(NSMutableArray *)array {
	srandom((unsigned int) time(NULL));
	for (NSInteger x = 0; x < [array count]; x++) {
		NSInteger randInt = (random() % ([array count] - x)) + x;
		[array exchangeObjectAtIndex:(NSUInteger) x withObjectAtIndex:(NSUInteger) randInt];
	}
}

- (Player *)userPlayer {
	return [_players lastObject];
}

- (void)placeStone:(Stone *)stone atPosition:(CGPoint)position {
	[[self userPlayer] removeStone:stone];
	[_board placeStone:stone atPosition:position];
	[_currentMoveStones addObject:stone];
	[self updateDropLocations];
	[self.delegate gameStateChanged:self];
}

- (void)updateDropLocations {
	[_dropLocations removeAllObjects];
	if (_currentMoveStones.count == 0) {
		for (Stone *placedStone in [_board placedStones]) {
			[self addDropLocationsForEmptyNeighboursOfStone:placedStone];
		}
	} else if (_currentMoveStones.count == 1) {
		Stone *stone = [_currentMoveStones lastObject];
		[self addDropLocationsForEmptyNeighboursOfStone:stone];
		[self addDropLocationsToEndOfRowFromStone:stone];
	} else {
		Stone *stone = [_currentMoveStones lastObject];
		MoveDirection moveDirection = [self moveDirectionForMove:_currentMoveStones];
		if (moveDirection == MoveDirectionVertical) {
			NSMutableSet *topNeighbours = [[_board rowWithNeighboursOfStone:stone inDirection:Top] mutableCopy];
			[topNeighbours addObject:stone];
			Stone *farthestNeighbourTop = [_board farthestStoneInRow:topNeighbours inDirection:Top];
			[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointTopNeighbour(farthestNeighbourTop.position)]];
			NSMutableSet *bottomNeighbours = [[_board rowWithNeighboursOfStone:stone inDirection:Bottom] mutableCopy];
			[bottomNeighbours addObject:stone];
			Stone *farthestNeighbourBottom = [_board farthestStoneInRow:bottomNeighbours inDirection:Bottom];
			[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointBottomNeighbour(farthestNeighbourBottom.position)]];
		}
		if (moveDirection == MoveDirectionHorizontal) {
			NSMutableSet *leftNeighbours = [[_board rowWithNeighboursOfStone:stone inDirection:Left] mutableCopy];
			[leftNeighbours addObject:stone];
			Stone *farthestNeighbourLeft = [_board farthestStoneInRow:leftNeighbours inDirection:Left];
			[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointLeftNeighbour(farthestNeighbourLeft.position)]];
			NSMutableSet *rightNeighbours = [[_board rowWithNeighboursOfStone:stone inDirection:Right] mutableCopy];
			[rightNeighbours addObject:stone];
			Stone *farthestNeighbourRight = [_board farthestStoneInRow:rightNeighbours inDirection:Right];
			[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointRightNeighbour(farthestNeighbourRight.position)]];
		}
	}
	[self.delegate gameDropLocationsUpdated:self];
}

- (void)addDropLocationsToEndOfRowFromStone:(Stone *)stone {
	CGPoint directions[] = {Left, Right, Top, Bottom};
	for (int i = 0; i < 4; i++) {
		CGPoint direction = directions[i];
		NSSet *row = [_board rowWithNeighboursOfStone:stone inDirection:direction];
		if ([row count] > 0) {
			Stone *farthestNeighbour = [_board farthestStoneInRow:row inDirection:direction];
			[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointMakeNeighbourOfPointInDirection(farthestNeighbour.position, direction)]];
		}
	}
}

- (MoveDirection)moveDirectionForMove:(NSArray *)stones {
	if ([stones count] < 2) {
		return MoveDirectionUnknown;
	}
	Stone *stone1 = stones[0];
	Stone *stone2 = stones[1];
	if (stone1.position.x == stone2.position.x) {
		return MoveDirectionVertical;
	}
	if (stone1.position.y == stone2.position.y) {
		return MoveDirectionHorizontal;
	}
	return MoveDirectionUnknown;
}

- (void)addDropLocationsForEmptyNeighboursOfStone:(Stone *)stone {
	CGPoint position = stone.position;
	Stone *leftneighbour = [_board stone:stone neighbourInDirection:Left];
	if (!leftneighbour) {
		[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointLeftNeighbour(position)]];
	}
	Stone *rightNeighbour = [_board stone:stone neighbourInDirection:Right];
	if (!rightNeighbour) {
		[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointRightNeighbour(position)]];
	}
	Stone *topNeighbour = [_board stone:stone neighbourInDirection:Top];
	if (!topNeighbour) {
		[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointTopNeighbour(position)]];
	}
	Stone *bottomNeighbour = [_board stone:stone neighbourInDirection:Bottom];
	if (!bottomNeighbour) {
		[_dropLocations addObject:[DropLocation dropLocationWithPosition:CGPointBottomNeighbour(position)]];
	}
}

- (BOOL)canStone:(Stone *)stone bePlacedAtPosition:(CGPoint)position {
	BOOL allowed = YES;
	stone.position = position;
	NSSet *rowsWithNeighbours = [_board rowsWithNeighbourStonesInSameRowWithStone:stone];
	for (NSSet *row in rowsWithNeighbours) {
		if (row.count > 0) {
			allowed &= [self allStonesInRow:row sameColorOrShapeLikeStone:stone];
			allowed &= ![self row:row containsStone:stone];
		}
	}
	return allowed;
}

- (BOOL)row:(NSSet *)row containsStone:(Stone *)stone {
	NSSet *filteredSet = [row filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Stone *evaluatedObject, NSDictionary *bindings) {
		return [stone hasSameColorAndShape:evaluatedObject];
	}]];
	return [filteredSet count] > 0;
}

- (BOOL)allStonesInRow:(NSSet *)row sameColorOrShapeLikeStone:(Stone *)stone {
	BOOL can = YES;
	CGFloat color = stone.color;
	CGFloat shape = stone.shape;
	for (Stone *s in row) {
		color += s.color;
		shape += s.shape;
	}
	color = color / (float) ([row count] + 1);
	shape = shape / (float) ([row count] + 1);

	if (!(color == stone.color || shape == stone.shape)) {
		can = NO;
	}
	return can;
}

- (NSArray *)dropLocations {
	return _dropLocations;
}

- (NSSet *)placedStones {
	return [_board placedStones];
}

- (NSArray *)currentMoveStones {
	return _currentMoveStones;
}

- (void)completeMove {
	[self countPoints];
	[_currentMoveStones removeAllObjects];
	[self fillStonesForPlayer:[self userPlayer]];
	[self updateDropLocations];
	[self.delegate gameMoveEnded:self];
}

- (void)countPoints {
	NSMutableSet *affectedStones = [[NSMutableSet alloc] init];
	for (Stone *stone in _currentMoveStones) {
		NSLog(@"stone = %@", stone);
		NSSet *rowsWithNeighbours = [_board rowsWithNeighbourStonesInSameRowWithStone:stone];
		for (NSSet *row in rowsWithNeighbours) {
			[affectedStones unionSet:row];
		}
	}
	[self.delegate game:self markStones:affectedStones];
}

@end
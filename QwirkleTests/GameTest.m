#import "Stone.h"
#import "Game.h"
#import "Player.h"
#import "Board.h"
#import "DropLocation.h"
#import "Board+Testing.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


#define SomeStone [Stone stoneWithShape:QwirkleShapeCircle color:QwirkleColorBlue]
#define SomePosition CGPointMake(0, 0)

@interface Game (Testing)
@property (nonatomic, strong) NSMutableArray *heap;
- (NSMutableArray *)buildHeap;
- (void)setBoard:(Board *)board;
- (void)setCurrentMoveStones:(NSArray *)stones;
- (void)fillStonesForPlayer:(Player *)player;
@end

@implementation Game (Testing)
@dynamic heap;
- (void)setBoard:(Board *)board {
	_board = board;
}

- (void)setCurrentMoveStones:(NSArray *)stones {
	_currentMoveStones = [stones mutableCopy];
}
@end

@interface GameTest : XCTestCase
@end

@implementation GameTest {
	Game *game;
}

- (void)setUp {
	game = [[Game alloc] init];
}

- (Stone *)stoneWithPosition:(CGPoint)point {
	Stone *firstStone = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorBlue];
	firstStone.position = point;
	return firstStone;
}

- (void)testHas108Stones {
	assertThat([game buildHeap], hasCountOf(108));
}

- (void)testGivingStonesToPlayerRemovesThemFromHeap {
	[game resetGame];
	assertThat(game.heap, hasCountOf(102));
	assertThat([game userPlayer].stones, hasCountOf(6));
}

- (void)testAddsPlacedStoneToCurrentMoveStones {
	Stone *stone = SomeStone;
	[game placeStone:stone atPosition:SomePosition];
	assertThat(game.currentMoveStones, hasItem(stone));
}

- (void)testInformsDelegateAboutStateChange {
	id delegate = mockProtocol(@protocol(GameDelegate));
	game.delegate = delegate;
	[game placeStone:SomeStone atPosition:SomePosition];
	[verify(delegate) gameStateChanged:game];
}

- (void)testRemovesPlacedStoneFromPlayer {
	Stone *stone = SomeStone;
	[game placeStone:stone atPosition:SomePosition];
	assertThat([[game userPlayer] stones], isNot(hasItem(stone)));
}

- (void)testSetsDropLocationsToNeighboursForAllPlacedStones {
	[game placeStone:SomeStone atPosition:CGPointMake(0, 0)];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 1)];
	[game completeMove];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(6));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:2]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:1 positionY:1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:1]));
}

- (void)testSetsDropLocationsToAllEmptyNeighboursOfFirstPlacedStone {
	[game placeStone:SomeStone atPosition:CGPointMake(0, 0)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:0]));
}

- (void)testAddsDropLocationsToTopEndOfRowForFirstPlacedStone {
	[game setBoard:[self boardWithStones:@[[self stoneWithPosition:CGPointMake(0, 0)]]]];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 1)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:2]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
}

- (Board *)boardWithStones:(NSArray *)array {
	Board *board = [[Board alloc] init];
	[board setPlacedStones:array];
	return board;
}

- (void)testAddsDropLocationsToBottomEndOfRowForFirstPlacedStone {
	[game setBoard:[self boardWithStones:@[[self stoneWithPosition:CGPointMake(0, 1)]]]];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 0)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:2]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
}

- (void)testAddsDropLocationsToLeftEndOfRowForFirstPlacedStone {
	[game setBoard:[self boardWithStones:@[[self stoneWithPosition:CGPointMake(0, 0)]]]];
	[game placeStone:SomeStone atPosition:CGPointMake(1, 0)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:2 positionY:0]));
}

- (void)testAddsDropLocationsToRightEndOfRowForFirstPlacedStone {
	[game setBoard:[self boardWithStones:@[[self stoneWithPosition:CGPointMake(1, 0)]]]];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 0)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:2 positionY:0]));
}

- (void)testAddsDropLocationsToBothEndOfRowIfHorizontalRowIsPlaced {
	Stone *stone1 = [self stoneWithPosition:CGPointMake(0, 0)];
	Stone *stone2 = [self stoneWithPosition:CGPointMake(1, 0)];
	[game setBoard:[self boardWithStones:@[stone1, stone2]]];
	[game setCurrentMoveStones:@[stone1, stone2]];

	[game placeStone:SomeStone atPosition:CGPointMake(2, 0)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(2));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:0]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:3 positionY:0]));
}

- (void)testAddsDropLocationsToBothEndOfRowIfVerticalRowIsPlaced {
	Stone *stone1 = [self stoneWithPosition:CGPointMake(0, 0)];
	Stone *stone2 = [self stoneWithPosition:CGPointMake(0, 1)];
	[game setBoard:[self boardWithStones:@[stone1, stone2]]];
	[game setCurrentMoveStones:@[stone1, stone2]];

	[game placeStone:SomeStone atPosition:CGPointMake(0, 2)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(2));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:3]));
}

- (void)testAddsDropLocationsToBothEndOfRowIfRowContainsAlreadyPlacedStones {
	[game setBoard:[self boardWithStones:@[[self stoneWithPosition:CGPointMake(0, 0)]]]];

	[game placeStone:SomeStone atPosition:CGPointMake(0, 1)];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 2)];

	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(2));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:3]));
}

- (void)testComplex {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
	];
	[game setBoard:[self boardWithStones:stones]];
	[game placeStone:SomeStone atPosition:CGPointMake(1, 1)];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 1)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(2));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:-1 positionY:1]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:2 positionY:1]));
}

- (void)testEvaluatesRowOnlyWithContinuingStones {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
			[self stoneWithPosition:CGPointMake(1, -1)],
			[self stoneWithPosition:CGPointMake(1, -2)],
			[self stoneWithPosition:CGPointMake(0, -2)],
	];
	[game setBoard:[self boardWithStones:stones]];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 1)];
	[game placeStone:SomeStone atPosition:CGPointMake(0, 2)];
	NSArray *dropLocations = game.dropLocations;
	assertThat(dropLocations, hasCountOf(2));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:3]));
	assertThat(dropLocations, hasItem([DropLocation dropLocationWithPositionX:0 positionY:-1]));
}

- (void)testPlaceOnlyStonesWithSameColorInARow {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	[game placeStone:yellowCircle atPosition:CGPointMake(0, 0)];
	Stone *redCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorRed];
	assertThatBool([game canStone:redCircle bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(TRUE));
}

- (void)testPlaceOnlyStonesWithSameShapeInARow {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	[game placeStone:yellowCircle atPosition:CGPointMake(0, 0)];
	Stone *yellowStar = [[Stone alloc] initWithShape:QwirkleShapeStar color:QwirkleColorYellow];
	assertThatBool([game canStone:yellowStar bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(TRUE));
}

- (void)testPlaceNoStaonesWithDifferentShapeAndColorInRow {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	[game placeStone:yellowCircle atPosition:CGPointMake(0, 0)];
	Stone *redStar = [[Stone alloc] initWithShape:QwirkleShapeStar color:QwirkleColorRed];
	assertThatBool([game canStone:redStar bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(FALSE));
}

- (void)testFirstStoneCanBePlacedEverywhere {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	assertThatBool([game canStone:yellowCircle bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(TRUE));
}

- (void)testRowsMustBeSameShapeOrSameColorRows {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	yellowCircle.position = CGPointMake(0, 0);
	Stone *redCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorRed];
	redCircle.position = CGPointMake(1, 0);
	NSArray *stones = @[yellowCircle, redCircle];
	[game setBoard:[self boardWithStones:stones]];
	Stone *yellowSquare = [[Stone alloc] initWithShape:QwirkleShapeSquare color:QwirkleColorYellow];
	assertThatBool([game canStone:yellowSquare bePlacedAtPosition:CGPointMake(2, 0)], equalToBool(FALSE));
}

- (void)testMultipleRowsCanApplyDifferentRulesets {
	Stone *yellowCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorYellow];
	yellowCircle.position = CGPointMake(0, 0);
	Stone *redCircle = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorRed];
	redCircle.position = CGPointMake(1, 0);
	Stone *redSquare = [[Stone alloc] initWithShape:QwirkleShapeSquare color:QwirkleColorRed];
	redSquare.position = CGPointMake(1, 1);
	NSArray *stones = @[yellowCircle, redCircle, redSquare];
	[game setBoard:[self boardWithStones:stones]];
	Stone *yellowSquare = [[Stone alloc] initWithShape:QwirkleShapeSquare color:QwirkleColorYellow];
	assertThatBool([game canStone:yellowSquare bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(TRUE));
}

- (void)testSameStonesInSameRowAreNotAllowed {
	Stone *redSquare1 = [[Stone alloc] initWithShape:QwirkleShapeSquare color:QwirkleColorRed];
	redSquare1.position = CGPointMake(0, 0);
	[game setBoard:[self boardWithStones:@[redSquare1]]];
	Stone *redSquare2 = [[Stone alloc] initWithShape:QwirkleShapeSquare color:QwirkleColorRed];
	assertThatBool([game canStone:redSquare2 bePlacedAtPosition:CGPointMake(0, 1)], equalToBool(FALSE));
}
@end

#import "Board.h"
#import "Stone.h"
#import "Board+Testing.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#define SomeStone [Stone stoneWithShape:QwirkleShapeCircle color:QwirkleColorBlue]
#define SomePosition CGPointMake(0, 0)

@interface BoardTest : XCTestCase
@end

@implementation BoardTest {
	Board *board;
}

- (void)setUp {
	board = [[Board alloc] init];
}

- (Stone *)stoneWithPosition:(CGPoint)point {
	Stone *firstStone = [[Stone alloc] initWithShape:QwirkleShapeCircle color:QwirkleColorBlue];
	firstStone.position = point;
	return firstStone;
}

- (void)testSetsPositionAtPlacedStone {
	CGPoint position = CGPointMake(3, 2);
	id stone = mock([Stone class]);
	[board placeStone:stone atPosition:position];
	[verify(stone) setPosition:position];
}

- (void)testAddsStoneToPlacedStones {
	Stone *stone = SomeStone;
	[board placeStone:stone atPosition:SomePosition];
	assertThat([board placedStones], hasCountOf(1));
}

- (void)testEvaluatesStonesInSameRow {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
			[self stoneWithPosition:CGPointMake(3, 3)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(2, 0)] inDirection:Left];
	assertThat(row, hasCountOf(2));
	assertThat(row, hasItem([self stoneWithPosition:CGPointMake(0, 0)]));
	assertThat(row, hasItem([self stoneWithPosition:CGPointMake(1, 0)]));
}

- (void)testEvaluatesFarthesLeftNeighbourInRow {
	NSArray *row = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
			[self stoneWithPosition:CGPointMake(2, 0)]];
	[board setPlacedStones:row];
	Stone *stone = [board farthestStoneInRow:(id) row inDirection:Left];
	assertThat(stone, isNot(nilValue()));
	assertThat(stone, equalTo([self stoneWithPosition:CGPointMake(0, 0)]));
}

- (void)testEvaluatesFarthesRightNeighbourInRow {
	NSArray *row = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
			[self stoneWithPosition:CGPointMake(2, 0)]];
	[board setPlacedStones:row];
	Stone *stone = [board farthestStoneInRow:(id) row inDirection:Right];
	assertThat(stone, isNot(nilValue()));
	assertThat(stone, equalTo([self stoneWithPosition:CGPointMake(2, 0)]));
}

- (void)testEvaluatesFarthesTopNeighbourInRow {
	NSArray *row = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(0, 1)],
			[self stoneWithPosition:CGPointMake(0, 2)]];
	[board setPlacedStones:row];
	Stone *stone = [board farthestStoneInRow:(id) row inDirection:Top];
	assertThat(stone, isNot(nilValue()));
	assertThat(stone, equalTo([self stoneWithPosition:CGPointMake(0, 0)]));
}

- (void)testEvaluatesFarthesBottomNeighbourInRow {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(0, 1)],
			[self stoneWithPosition:CGPointMake(0, 2)]];
	[board setPlacedStones:stones];
	Stone *stone = [board farthestStoneInRow:(id) stones inDirection:Bottom];
	assertThat(stone, isNot(nilValue()));
	assertThat(stone, equalTo([self stoneWithPosition:CGPointMake(0, 2)]));
}

- (void)testFindsNoNeighbourStonesInEmptyBoard {
	[board setPlacedStones:@[]];
	NSSet *row = [board rowWithNeighboursOfStone:SomeStone inDirection:Left];
	assertThat(row, hasCountOf(0));
}

- (void)testGivesNeighboursInRightDirection {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(-1, 0)],
			[self stoneWithPosition:CGPointMake(-2, 0)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(-3, 0)] inDirection:Right];
	assertThat(row, hasCountOf(3));
}

- (void)testGivesNeighboursInLeftDirection {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(1, 0)],
			[self stoneWithPosition:CGPointMake(2, 0)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(3, 0)] inDirection:Left];
	assertThat(row, hasCountOf(3));
}

- (void)testGivesNeighboursInBottomDirection {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(0, -1)],
			[self stoneWithPosition:CGPointMake(0, -2)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(0, -3)] inDirection:Bottom];
	assertThat(row, hasCountOf(3));
}

- (void)testGivesNeighboursInTopDirection {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(0, 1)],
			[self stoneWithPosition:CGPointMake(0, 2)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(0, 3)] inDirection:Top];
	assertThat(row, hasCountOf(3));
}

- (void)testExcludesStonesInRowThatAreNoNeighbours {
	NSArray *stones = @[
			[self stoneWithPosition:CGPointMake(0, 0)],
			[self stoneWithPosition:CGPointMake(0, 1)],
			[self stoneWithPosition:CGPointMake(0, 2)],
			[self stoneWithPosition:CGPointMake(0, 5)]];
	[board setPlacedStones:stones];
	NSSet *row = [board rowWithNeighboursOfStone:[self stoneWithPosition:CGPointMake(0, 3)] inDirection:Top];
	assertThat(row, hasCountOf(3));

}

@end

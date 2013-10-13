#import "BoardViewController.h"
#import "Player.h"
#import "Stone.h"
#import "StoneView.h"
#import "Board.h"
#import "DropLocation.h"
#import "DropLocationView.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#define SomeStone [Stone stoneWithShape:QwirkleShapeCircle color:QwirkleColorBlue]
#define SomeDropLocation [DropLocation dropLocationWithPositionX:0 positionY:0]

@interface BoardViewController (Testing)
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (void)updatePlayerStones;
- (void)updatePlacedStones;
- (void)updateDropLocations;
- (void)handleDroppedStone:(StoneView *)stoneView;
@end

@interface BoardViewControllerTest : XCTestCase
@end

@implementation BoardViewControllerTest {
	BoardViewController *boardViewController;
	id playerView;
	id game;
	id player;
	id boardView;
}

- (void)setUp {
	boardViewController = [[BoardViewController alloc] init];
	playerView = mock([UIView class]);
	boardViewController.playerView = playerView;
	game = mock([Game class]);
	player = mock([Player class]);
	[given([game userPlayer]) willReturn:player];
	boardViewController.game = game;
	boardView = mock([UIView class]);
	boardViewController.boardView = boardView;
}

- (void)testAddsStoneForEveryPlayerStone {
	[given([player stones]) willReturn:@[SomeStone, SomeStone]];
	[boardViewController updatePlayerStones];
	[verifyCount(playerView, times(2)) addSubview:(id) instanceOf([StoneView class])];
}

- (void)testAddsStoneForEveryPlacedStone {
	[given([game placedStones]) willReturn:@[SomeStone, SomeStone]];
	[boardViewController updatePlacedStones];
	[verifyCount(boardView, times(2)) addSubview:(id) instanceOf([StoneView class])];
}

- (void)testAddsDropLocationViewForEveryDroplocation {
	[given([game dropLocations]) willReturn:@[SomeDropLocation, SomeDropLocation]];
	[boardViewController updateDropLocations];
	[verifyCount(boardView, times(2)) addSubview:(id) instanceOf([DropLocationView class])];
}

@end

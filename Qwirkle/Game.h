#import <Foundation/Foundation.h>

typedef enum {
	MoveDirectionUnknown,
	MoveDirectionHorizontal,
	MoveDirectionVertical,
} MoveDirection;

@class Game;
@class Player, Stone;
@class Board;

@protocol GameDelegate <NSObject>
- (void)gameDidResetState:(Game *)game;
- (void)gameStateChanged:(Game *)game;
- (void)gameMoveEnded:(Game *)game;
- (void)gameDropLocationsUpdated:(Game *)game;
- (void)game:(Game *)game markStones:(NSSet *)stone;
@end


@interface Game : NSObject {
	NSMutableArray *_dropLocations;
	NSMutableArray *_currentMoveStones;
	Board *_board;
}

@property (weak, nonatomic) id <GameDelegate> delegate;

- (void)resetGame;
- (Player *)userPlayer;
- (void)placeStone:(Stone *)stone atPosition:(CGPoint)position;
- (BOOL)canStone:(Stone *)stone bePlacedAtPosition:(CGPoint)position;
- (NSArray *)dropLocations;
- (NSSet *)placedStones;
- (NSArray *)currentMoveStones;
- (void)completeMove;

@end
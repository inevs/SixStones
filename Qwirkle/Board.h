#import <Foundation/Foundation.h>

#define Left CGPointMake(-1, 0)
#define Right CGPointMake(1, 0)
#define Top CGPointMake(0, -1)
#define Bottom CGPointMake(0, 1)

@class Stone;

@interface Board : NSObject {
	NSMutableArray *_placedStones;
}

- (void)placeStone:(Stone *)stone atPosition:(CGPoint)position;
- (NSSet *)placedStones;
- (Stone *)stone:(Stone *)stone neighbourInDirection:(CGPoint)direction;
- (Stone *)farthestStoneInRow:(NSSet *)row inDirection:(CGPoint)direction;
- (NSSet *)rowsWithNeighbourStonesInSameRowWithStone:(Stone *)stone;
- (NSSet *)rowWithNeighboursOfStone:(Stone *)stone inDirection:(CGPoint)direction;

@end
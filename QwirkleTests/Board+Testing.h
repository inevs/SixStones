#import "Board.h"

@interface Board (Testing)
- (void)setPlacedStones:(NSArray *)stones;
- (Stone *)farthestStoneInRow:(NSSet *)row inDirection:(CGPoint)direction;
@end


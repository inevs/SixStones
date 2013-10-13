#import "Board+Testing.h"

@implementation Board (Testing)
- (void)setPlacedStones:(NSArray *)stones {
	_placedStones = [stones mutableCopy];
}
@end

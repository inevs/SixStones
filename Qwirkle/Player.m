#import "Player.h"
#import "Stone.h"


@implementation Player {
	NSMutableArray *_stones;
}

- (id)init {
	self = [super init];
	if (self) {
		_stones = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addStone:(Stone *)stone {
	[_stones addObject:stone];
}

- (void)removeStone:(Stone *)stone {
	[_stones removeObjectIdenticalTo:stone];
}
@end
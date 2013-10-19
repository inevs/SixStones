#import "IsSameColorAndShapeMatcher.h"
#import "Stone.h"


@implementation IsSameColorAndShapeMatcher {
	Stone *_stone;
}

+ (instancetype)isSameColorAndShape:(Stone *)stone {
	return [[self alloc] initWithStone:stone];
}

- (id)initWithStone:(Stone *)stone {
	self = [super init];
	if (self) {
		_stone = stone;		
	}
	return self;
}

- (BOOL)matches:(id)item {
	if ([item isKindOfClass:[Stone class]]) {
		Stone *other = item;
		return [other shape] == _stone.shape && [other color] == _stone.color;
	}
	return NO;
}

- (void)describeTo:(id <HCDescription>)description {
    [description appendText:@"Stone with same color or shape"];
}

@end

id <HCMatcher> isSameColorAndShape(Stone *stone) {
    return [IsSameColorAndShapeMatcher isSameColorAndShape:stone];
}
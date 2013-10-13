#import "DropLocation.h"


@implementation DropLocation {
}

+ (DropLocation *)dropLocationWithPosition:(CGPoint)position {
	return [[DropLocation alloc] initWithPosition:position];
}

+ (DropLocation *)dropLocationWithPositionX:(NSInteger)x positionY:(NSInteger)y {
	return [[DropLocation alloc] initWithPosition:CGPointMake(x, y)];
}

- (id)initWithPosition:(CGPoint)position {
	self = [super init];
	if (self) {
		self.position = position;
	}
	return self;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![[other class] isEqual:[self class]])
		return NO;

	return [self isEqualToLocation:other];
}

- (BOOL)isEqualToLocation:(DropLocation *)location {
	if (self == location)
		return YES;
	if (location == nil)
		return NO;
	if (self.position.x != location.position.x)
		return NO;
	if (self.position.y != location.position.y)
		return NO;
	return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = [[NSNumber numberWithDouble:self.position.x] hash];
	hash = hash * 31u + [[NSNumber numberWithDouble:self.position.y] hash];
	return hash;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
	[description appendFormat:@"self.position.x=%f", self.position.x];
	[description appendFormat:@", self.position.y=%f", self.position.y];
	[description appendString:@">"];
	return description;
}

@end
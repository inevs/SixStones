#import "Stone.h"


@implementation Stone {
}

+ (Stone *)stoneWithShape:(QwirkleShape)shape color:(QwirkleColor)color {
	return [[Stone alloc] initWithShape:shape color:color];
}

- (id)initWithShape:(QwirkleShape)shape color:(QwirkleColor)color {
	self = [super init];
	if (self) {
		self.shape = shape;
		self.color = color;
	}
	return self;
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@ %@ at position:%@", [self colorName], [self shapeName], NSStringFromCGPoint(self.position)];
	return description;
}

- (id)valueForKeyPath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"position.x"])
		return @(_position.x);
	if ([keyPath isEqualToString:@"position.y"])
		return @(_position.y);
	return [super valueForKeyPath:keyPath];
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![[other class] isEqual:[self class]])
		return NO;

	return [self isEqualToStone:other];
}

- (BOOL)isEqualToStone:(Stone *)stone {
	if (stone == nil)
		return NO;
	if (self.shape != stone.shape)
		return NO;
	if (self.color != stone.color)
		return NO;
	if (self.position.x != stone.position.x)
		return NO;
	if (self.position.y != stone.position.y)
		return NO;
	return YES;
}

- (NSUInteger)hash {
	NSUInteger hash = (NSUInteger) self.shape;
	hash = hash * 31u + (NSUInteger) self.color;
	hash = hash * 31u + [[NSNumber numberWithDouble:self.position.x] hash];
	hash = hash * 31u + [[NSNumber numberWithDouble:self.position.y] hash];
	return hash;
}

- (BOOL)hasSameColorAndShape:(Stone *)other {
	return self.color == other.color && self.shape == other.shape;
}

- (NSString *)shapeName {
	switch (self.shape) {
		case QwirkleShapeSquare:
			return @"Square";
		case QwirkleShapeCircle:
			return @"Circle";
		case QwirkleShapeDiamond:
			return @"Diamond";
		case QwirkleShapeStar:
			return @"Star";
		case QwirkleShapeRomb:
			return @"Romb";
		case QwirkleShapeFlower:
			return @"Flower";
	}
	return @"";
}

- (NSString *)colorName {
	switch (self.color) {
		case QwirkleColorBlue:return @"Blue";
		case QwirkleColorRed:return @"Red";
		case QwirkleColorGreen:return @"Green";
		case QwirkleColorOrange:return @"Orange";
		case QwirkleColorYellow:return @"Yellow";
		case QwirkleColorPurple:return @"Purple";
	}
	return @"";
}
@end
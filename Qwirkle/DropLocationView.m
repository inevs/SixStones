#import "DropLocationView.h"
#import "DropLocation.h"

#define StoneSize 60

@implementation DropLocationView {
}

- (id)initWithDropLocation:(DropLocation *)dropLocation {
	self = [super initWithFrame:CGRectMake(0, 0, StoneSize, StoneSize)];
	if (self) {
		self.dropLocation = dropLocation;
		self.backgroundColor = [UIColor clearColor];
		self.layer.cornerRadius = 5.0;
		[self addDashedLine];
	}
	return self;
}

- (id)init {
	return [self initWithDropLocation:[DropLocation dropLocationWithPosition:CGPointMake(0, 0)]];
}

- (void)addDashedLine {
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.bounds = self.bounds;
	shapeLayer.position = self.center;
	shapeLayer.fillColor = [[UIColor clearColor] CGColor];
	shapeLayer.strokeColor = [[UIColor colorWithWhite:1.0 alpha:0.8] CGColor];
	shapeLayer.lineWidth = 3.0f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineDashPattern = @[@4, @3];

	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 0, 0);
	CGPathAddLineToPoint(path, NULL, 0, StoneSize);
	CGPathAddLineToPoint(path, NULL, StoneSize, StoneSize);
	CGPathAddLineToPoint(path, NULL, StoneSize, 0);
	CGPathAddLineToPoint(path, NULL, 0, 0);
	[shapeLayer setPath:path];
	CGPathRelease(path);

	[[self layer] addSublayer:shapeLayer];
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
	[description appendFormat:@"droplocation: %@", self.dropLocation];
	[description appendString:@">"];
	return description;
}

@end
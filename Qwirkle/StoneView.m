#import "StoneView.h"
#import "Stone.h"

@implementation StoneView {
	Stone *_stone;
}
- (id)initWithStone:(Stone *)stone {
	self = [super initWithFrame:CGRectMake(0, 0, StoneSize, StoneSize)];
	if (self) {
		_stone = stone;
		[self configureBackground];
		[self addImageWithShape:stone.shape color:stone.color];
		self.layer.borderWidth = 5.0;
	}
	return self;
}

- (void)configureBackground {
	self.backgroundColor = [UIColor blackColor];
	self.layer.cornerRadius = 5.0;
	self.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:1.0].CGColor;
	self.layer.shadowOffset = CGSizeMake(5.0, 5.0);
	self.layer.shadowOpacity = 0.8;
}

- (void)addImageWithShape:(QwirkleShape)shape color:(QwirkleColor)color {
	CALayer *image = [CALayer layer];
	image.position = self.layer.position;
	image.bounds = CGRectInset(self.bounds, 10, 10);
	NSString *imageName = [self imageNameForShape:shape color:color];
	image.contents = (__bridge id) ([UIImage imageNamed:imageName].CGImage);
	[self.layer addSublayer:image];
}

- (NSString *)imageNameForShape:(QwirkleShape)shape color:(QwirkleColor)color {
	NSString *colorString = [self stringForColor:color];
	NSString *shapeString = [self stringForShape:shape];
	return [NSString stringWithFormat:@"%@_%@", colorString, shapeString];
}

- (NSString *)stringForShape:(QwirkleShape)shape {
	NSString *shapeString;
	switch (shape) {
		case QwirkleShapeCircle:
			shapeString = @"circle";
	        break;
		case QwirkleShapeDiamond:
			shapeString = @"diamond";
	        break;
		case QwirkleShapeFlower:
			shapeString = @"flower";
	        break;
		case QwirkleShapeRomb:
			shapeString = @"romb";
	        break;
		case QwirkleShapeSquare:
			shapeString = @"square";
	        break;
		case QwirkleShapeStar:
			shapeString = @"star";
	        break;
	}
	return shapeString;
}

- (NSString *)stringForColor:(QwirkleColor)color {
	NSString *colorString;
	switch (color) {
		case QwirkleColorBlue:
			colorString = @"blue";
	        break;
		case QwirkleColorRed:
			colorString = @"red";
	        break;
		case QwirkleColorGreen:
			colorString = @"green";
	        break;
		case QwirkleColorOrange:
			colorString = @"orange";
	        break;
		case QwirkleColorPurple:
			colorString = @"purple";
	        break;
		case QwirkleColorYellow:
			colorString = @"yellow";
	        break;
	}
	return colorString;
}

- (Stone *)stone {
	return _stone;
}

- (void)markRed {
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1].CGColor;
	[UIView animateWithDuration:1.0 delay:1.0 options:0 animations:^{
		self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0].CGColor;
	} completion:^(BOOL finished) {
		NSLog(@"finished %d", finished);
	}];
}
@end
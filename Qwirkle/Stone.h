#import <Foundation/Foundation.h>

typedef enum {
	QwirkleShapeSquare,
	QwirkleShapeCircle,
	QwirkleShapeDiamond,
	QwirkleShapeStar,
	QwirkleShapeRomb,
	QwirkleShapeFlower
} QwirkleShape;

typedef enum {
	QwirkleColorBlue,
	QwirkleColorRed,
	QwirkleColorGreen,
	QwirkleColorOrange,
	QwirkleColorYellow,
	QwirkleColorPurple
} QwirkleColor;

@interface Stone : NSObject

@property (nonatomic) QwirkleShape shape;
@property (nonatomic) QwirkleColor color;

@property (nonatomic) CGPoint position;
+ (Stone *)stoneWithShape:(QwirkleShape)shape color:(QwirkleColor)color;
- (id)initWithShape:(QwirkleShape)shape color:(QwirkleColor)color;
- (BOOL)hasSameColorAndShape:(Stone *)other;
@end
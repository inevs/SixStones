#import <Foundation/Foundation.h>

@interface DropLocation : NSObject

@property (nonatomic) CGPoint position;

+ (DropLocation *)dropLocationWithPosition:(CGPoint)position;
+ (DropLocation *)dropLocationWithPositionX:(NSInteger)x positionY:(NSInteger)y;
- (id)initWithPosition:(CGPoint)position;

@end
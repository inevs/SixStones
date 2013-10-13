#import <Foundation/Foundation.h>

@class Stone;


@interface Player : NSObject

@property (nonatomic, strong, readonly) NSArray *stones;

- (void)addStone:(Stone *)stone;

- (void)removeStone:(Stone *)stone;
@end

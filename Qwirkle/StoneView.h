#define StoneSize 60

@class Stone;

@interface StoneView : UIView
- (id)initWithStone:(Stone *)stone;
- (Stone *)stone;
- (void)markRed;
@end
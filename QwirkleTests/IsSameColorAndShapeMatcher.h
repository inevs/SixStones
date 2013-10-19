#import <Foundation/Foundation.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@class Stone;


@interface IsSameColorAndShapeMatcher : HCBaseMatcher

+ (instancetype)isSameColorAndShape:(Stone *)stone;
- (id)initWithStone:(Stone *)stone;

OBJC_EXPORT id <HCMatcher> isSameColorAndShape(Stone *stone);

@end

#import "Stone.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface StoneTest : XCTestCase
@end

@implementation StoneTest

- (void)testComparesStoneWithSameColorAndShapeAsEqualColorShaped {
	Stone *left = [Stone stoneWithShape:QwirkleShapeCircle color:QwirkleColorRed];
	Stone *right = [Stone stoneWithShape:QwirkleShapeCircle color:QwirkleColorRed];
	assertThatBool([left hasSameColorAndShape:right], equalToBool(TRUE));
}
@end

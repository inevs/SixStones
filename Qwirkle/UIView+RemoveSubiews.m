#import "UIView+RemoveSubiews.h"


@implementation UIView (RemoveSubiews)

- (void)removeSubviewsOfClass:(Class)class {
	for (UIView *viewToRemove in self.subviews) {
		if ([viewToRemove isKindOfClass:class]) {
			[viewToRemove removeFromSuperview];
		}
	}
}
@end
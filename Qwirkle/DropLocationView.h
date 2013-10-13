#import <Foundation/Foundation.h>

@class DropLocation;


@interface DropLocationView : UIView
@property (nonatomic) CGPoint position;
@property (nonatomic, strong) DropLocation *dropLocation;
- (id)initWithDropLocation:(DropLocation *)dropLocation;
@end
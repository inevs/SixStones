#import <CoreGraphics/CoreGraphics.h>

CG_INLINE CGPoint
CGPointLeftNeighbour(CGPoint point) {
  CGPoint p; p.x = point.x - 1; p.y = point.y; return p;
}

CG_INLINE CGPoint
CGPointRightNeighbour(CGPoint point) {
  CGPoint p; p.x = point.x + 1; p.y = point.y; return p;
}

CG_INLINE CGPoint
CGPointTopNeighbour(CGPoint point) {
  CGPoint p; p.x = point.x; p.y = point.y - 1; return p;
}

CG_INLINE CGPoint
CGPointBottomNeighbour(CGPoint point) {
  CGPoint p; p.x = point.x; p.y = point.y + 1; return p;
}

CG_INLINE CGPoint
CGPointMakeNeighbourOfPointInDirection(CGPoint point, CGPoint direction) {
	CGPoint p; p.x = point.x + direction.x; p.y = point.y + direction.y; return p;
}

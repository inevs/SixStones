#import "BoardViewController.h"
#import "Stone.h"
#import "StoneView.h"
#import "DropLocationView.h"
#import "DropLocation.h"
#import "Player.h"
#import "UIView+RemoveSubiews.h"

#define Margin 10

@interface BoardViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@end

@implementation BoardViewController {
	CGPoint _dragStartLocation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.game = [[Game alloc] init];
		self.game.delegate = self;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
	self.scrollView.contentSize = CGSizeMake(100 * StoneSize, 100 * StoneSize);
	[self.game resetGame];
}

- (IBAction)doneButtonTouched:(id)sender {
	[self.game completeMove];
}

- (void)updateUI {
	[self updatePlayerStones];
	[self updatePlacedStones];
	[self updateDropLocations];
}

- (void)updatePlayerStones {
	[self.playerView removeSubviewsOfClass:[StoneView class]];
	[[[self.game userPlayer] stones] enumerateObjectsUsingBlock:^(Stone *stone, NSUInteger idx, BOOL *stop) {
		StoneView *stoneView = [[StoneView alloc] initWithStone:stone];
		[self.playerView addSubview:stoneView];
//		[stoneView.po_frameBuilder centerHorizontallyInSuperview];
//		[stoneView.po_frameBuilder moveWithOffsetY:50 + idx * (StoneSize + Margin)];
		UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stoneDragged:)];
		[stoneView addGestureRecognizer:panGestureRecognizer];
	}];
}

- (void)updatePlacedStones {
	NSLog(@"%s", sel_getName(_cmd));
	[self.boardView removeSubviewsOfClass:[StoneView class]];
	for (Stone *stone in [self.game placedStones]) {
		StoneView *stoneView = [[StoneView alloc] initWithStone:stone];
		stoneView.center = [self centerForPosition:stone.position];
		[self.boardView addSubview:stoneView];
	}
}

- (void)updateDropLocations {
	[self.boardView removeSubviewsOfClass:[DropLocationView class]];
	for (DropLocation *dropLocation in [self.game dropLocations]) {
		DropLocationView *dropLocationView = [[DropLocationView alloc] initWithDropLocation:dropLocation];
		dropLocationView.center = [self centerForPosition:dropLocation.position];
		[self.boardView addSubview:dropLocationView];
	}
}

- (CGPoint)centerForPosition:(CGPoint)position {
	CGPoint centerInScrollView = CGPointMake(CGRectGetMidX(self.boardView.bounds), CGRectGetMidY(self.boardView.bounds));
	return CGPointMake(centerInScrollView.x + ((StoneSize + Margin) * position.x), centerInScrollView.y + ((StoneSize + Margin) * position.y));
}

- (void)stoneDragged:(UIPanGestureRecognizer *)gestureRecognizer {
	StoneView *stoneView = (StoneView *) gestureRecognizer.view;
	stoneView.layer.zPosition = 100;

	UIGestureRecognizerState recognizerState = [gestureRecognizer state];
	if (recognizerState == UIGestureRecognizerStateBegan) {
		_dragStartLocation = stoneView.center;
	}
	if (recognizerState == UIGestureRecognizerStateChanged) {
		CGPoint point = [gestureRecognizer translationInView:self.view];
		stoneView.frame = CGRectOffset(stoneView.frame, point.x, point.y);
		[gestureRecognizer setTranslation:CGPointZero inView:self.view];
	}
	if (recognizerState == UIGestureRecognizerStateEnded) {
		[self handleDroppedStone:stoneView];
	}
}

- (void)handleDroppedStone:(StoneView *)stoneView {
	DropLocationView *dropLocationView = [self dropLocationViewForStoneView:stoneView];
	if (dropLocationView == nil || ![self.game canStone:stoneView.stone bePlacedAtPosition:dropLocationView.dropLocation.position]) {
		[self moveStoneBack:stoneView];
	} else {
		[stoneView removeFromSuperview];
		[self.view addSubview:stoneView];
		[UIView animateWithDuration:.25 animations:^{
			stoneView.center = [self.view convertPoint:dropLocationView.center fromView:self.boardView];
		}                completion:^(BOOL finished) {
			stoneView.layer.zPosition = 0;
			[stoneView removeFromSuperview];
			[self.boardView addSubview:stoneView];
			stoneView.center = [self.boardView convertPoint:stoneView.center fromView:self.view];
			[dropLocationView removeFromSuperview];
			[self.game placeStone:stoneView.stone atPosition:dropLocationView.dropLocation.position];
		}];
	}
}

- (void)moveStoneBack:(StoneView *)stoneView {
	[UIView animateWithDuration:.25 animations:^{
		stoneView.center = _dragStartLocation;
	}                completion:^(BOOL finished) {
		stoneView.layer.zPosition = 0;
	}];
}

- (DropLocationView *)dropLocationViewForStoneView:(StoneView *)stoneView {
	NSArray *dropLocations = [self dropLocationViews];
	for (DropLocationView *dropLocationView in dropLocations) {
		CGRect dropLocationRect = CGRectInset(dropLocationView.frame, 20, 20);
		CGRect translated = [self.view convertRect:stoneView.frame toView:self.boardView];
		CGRect droppedStoneRect = CGRectInset(translated, 20, 20);
		if (CGRectIntersectsRect(dropLocationRect, droppedStoneRect)) {
			return dropLocationView;
		}
	}
	return nil;
}

- (NSArray *)dropLocationViews {
	NSArray *dropLocations = [self.boardView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isKindOfClass:[DropLocationView class]];
	}]];
	return dropLocations;
}

- (NSArray *)stoneViews {
	NSArray *stoneViews = [self.boardView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return [evaluatedObject isKindOfClass:[StoneView class]];
	}]];
	return stoneViews;
}

- (void)gameDidResetState:(Game *)game {
	[self updateUI];
}

- (void)gameStateChanged:(Game *)game {
}

- (void)gameMoveEnded:(Game *)game {
	[self updateDropLocations];
	[self updatePlayerStones];
}

- (void)gameDropLocationsUpdated:(Game *)game {
	[self updateDropLocations];
}

- (IBAction)resetGame:(id)sender {
	[self.game resetGame];
}

- (void)game:(Game *)game markStones:(NSSet *)stones {
	for (Stone *stone in stones) {
		StoneView *stoneView = [self stoneViewWithStone:stone];
		[stoneView markRed];
	}
}

- (StoneView *)stoneViewWithStone:(Stone *)stone {
	NSArray *stoneViews = [[self stoneViews] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(StoneView *evaluatedObject, NSDictionary *bindings) {
		return evaluatedObject.stone == stone;
	}]];
	return [stoneViews lastObject];
}

@end


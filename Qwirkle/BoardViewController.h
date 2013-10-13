#import <UIKit/UIKit.h>
#import "Game.h"

@class Game;

@interface BoardViewController : UIViewController <UIScrollViewDelegate, GameDelegate>

@property (nonatomic, strong) Game *game;
@end

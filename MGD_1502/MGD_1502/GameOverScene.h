//
//  GameOverScene.h
//  MGD_1502
//
//  Created by Robert Smith on 2/12/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>


@protocol sceneDelegate <NSObject> 

-(void)showShareScreen;

@end


@interface GameOverScene : SKScene <GKGameCenterControllerDelegate>

@property (strong, nonatomic) id <sceneDelegate> myDelegate;

@property (strong, nonatomic) NSString *highScore;

@property (strong, nonatomic) NSString *recentScore;

@property (strong, nonatomic) NSString *leaderboardId;

-(id)initWithSize:(CGSize)size leaderboardId:(NSString*)leadedboardId recentScore:(NSString*)rScore highscore:(NSString*)hscore;

@end

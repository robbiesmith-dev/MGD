//
//  IntroScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/25/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "IntroScene.h"
#import "AGSpriteButton.h"
#import "GamePlayScene.h"
#import "CreditScene.h"
#import <GameKit/GameKit.h>


@interface IntroScene ()

@property (strong, nonatomic) AGSpriteButton *playButton;
@property (strong, nonatomic) AGSpriteButton *creditButton;
@property (strong, nonatomic) AGSpriteButton *leaderboardButton;
@property (strong, nonatomic) NSString *lastScore;



@end

@implementation IntroScene

-(id)initWithSize:(CGSize)size leaderboardID:(NSString*)leaderboardID
{
    if (self = [super initWithSize:size])
    {
        
        _leaderboardID = leaderboardID;
        
        _lastScore = @"0";
        
        SKLabelNode *titleLable = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        titleLable.text = @"MGD GAME";
        titleLable.fontSize = 44;
        titleLable.position = CGPointMake(CGRectGetMidX(self.frame),
                                         CGRectGetMidY(self.frame)+100);
        
        [self addChild:titleLable];
        
        _playButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_playButton setLabelWithText:@"Play" andFont:[UIFont fontWithName:@"Chalkduster" size:44] withColor:[UIColor whiteColor]];
        _playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _playButton.name = @"play";
        [self addChild:_playButton];
        
        SKAction *playGame = [SKAction performSelector:@selector(playGame) onTarget:self];
        
        [_playButton performAction:playGame onObject:self withEvent:AGButtonControlEventTouchDown];
        
        _leaderboardButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_leaderboardButton setLabelWithText:@"Leaderboad" andFont:[UIFont fontWithName:@"Chalkduster" size:44] withColor:[UIColor whiteColor]];
        _leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -125);
        _leaderboardButton.name = @"leaderboards";
        [self addChild:_leaderboardButton];
        
        SKAction *showLeaderboard = [SKAction performSelector:@selector(showLeaderboard) onTarget:self];
        
        [_leaderboardButton performAction:showLeaderboard onObject:self withEvent:AGButtonControlEventTouchDown];
    }
    return self;
}

-(void) playGame
{
    GamePlayScene *gamePlayScene = [[GamePlayScene alloc]initWithSize:self.frame.size leaderboardID:_leaderboardID lastScore:_lastScore];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

-(void) rollCredits
{
    CreditScene *creditScene = [CreditScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:creditScene transition:transition];
}

-(void)showLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;

    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardID;
    
    [self.view.window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

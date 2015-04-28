//
//  GameOverScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/12/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "GameOverScene.h"
#import "GamePlayScene.h"
#import "IntroScene.h"
#import "AGSpriteButton.h"
#import <Social/Social.h>

@interface GameOverScene()

@property (strong, nonatomic) AGSpriteButton *returnToIntroButton;

@property (strong, nonatomic) AGSpriteButton *playAgianButton;

@property (strong, nonatomic) AGSpriteButton *leaderboardButton;




@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size leaderboardId:(NSString*)leadedboardId recentScore:(NSString*)rScore highscore:(NSString*)hscore
{
    if (self = [super initWithSize:size])
    {
        _recentScore = rScore;
        _leaderboardId = leadedboardId;
        _highScore = hscore;
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Game Over";
        myLabel.fontSize = 45;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)+225);
        
        [self addChild:myLabel];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];

        
        scoreLabel.text = [NSString stringWithFormat:@"Score: %@", _recentScore];
        scoreLabel.fontSize = 45;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)+75);
        
        [self addChild:scoreLabel];
        
        SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        
        highScoreLabel.text = [NSString stringWithFormat:@"High Score: %@", _highScore];
        highScoreLabel.fontSize = 45;
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame)+25);
        
        [self addChild:highScoreLabel];
        
        _returnToIntroButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_returnToIntroButton setLabelWithText:@"Return To Main Menu" andFont:[UIFont fontWithName:@"Chalkduster" size:25] withColor:[UIColor whiteColor]];
        _returnToIntroButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -50);
        _returnToIntroButton.name = @"return";
        [self addChild:_returnToIntroButton];
        
        SKAction *returnToIntro = [SKAction performSelector:@selector(returnToIntro) onTarget:self];
        [_returnToIntroButton performAction:returnToIntro onObject:self withEvent:AGButtonControlEventTouchDown];
        
        _playAgianButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_playAgianButton setLabelWithText:@"Play Again" andFont:[UIFont fontWithName:@"Chalkduster" size:25] withColor:[UIColor whiteColor]];
        _playAgianButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -100);
        _playAgianButton.name = @"return";
        [self addChild:_playAgianButton];
        
        SKAction *playAgain = [SKAction performSelector:@selector(playAgain) onTarget:self];
        [_playAgianButton performAction:playAgain onObject:self withEvent:AGButtonControlEventTouchDown];
        
        _leaderboardButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_leaderboardButton setLabelWithText:@"Leaderboad" andFont:[UIFont fontWithName:@"Chalkduster" size:25] withColor:[UIColor whiteColor]];
        _leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -150);
        _leaderboardButton.name = @"leaderboards";
        [self addChild:_leaderboardButton];
        
        SKAction *showLeaderboard = [SKAction performSelector:@selector(showLeaderboard) onTarget:self];
        
        [_leaderboardButton performAction:showLeaderboard onObject:self withEvent:AGButtonControlEventTouchDown];
        
        AGSpriteButton *tweetButton = [AGSpriteButton buttonWithImageNamed:@"tweet"];
        tweetButton.size = CGSizeMake(75, 75);
        tweetButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -250);
        tweetButton.name = @"tweet";
        [self addChild:tweetButton];
        
        SKAction *tweetGame = [SKAction performSelector:@selector(tweetGame) onTarget:self];
        [tweetButton performAction:tweetGame onObject:self withEvent:AGButtonControlEventTouchDown];
        
        
    }
    return self;
}

-(void) returnToIntro
{
    IntroScene *intro = [[IntroScene alloc]initWithSize:self.frame.size leaderboardID:_leaderboardId];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:intro transition:transition];
}

-(void) playAgain
{
    GamePlayScene *gamePlayScene = [[GamePlayScene alloc]initWithSize:self.frame.size leaderboardID:_leaderboardId lastScore:_recentScore];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

-(void)tweetGame
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *TWITTER = [SLComposeViewController
                                            composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [TWITTER setInitialText:[NSString stringWithFormat:@"I got a score of %@ in MGD_1502!!", _highScore]];
        
        
        
        [self.view.window.rootViewController presentViewController:TWITTER animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter" message:@"To share your high score to Twitter, please log into Twitter in Setting > Twitter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)showLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardId;
    
    [self.view.window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

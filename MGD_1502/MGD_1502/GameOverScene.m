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

@interface GameOverScene()

@property (strong, nonatomic) AGSpriteButton *returnToIntroButton;

@property (strong, nonatomic) AGSpriteButton *playAgianButton;


@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Game Over";
        myLabel.fontSize = 45;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)+75);
        
        [self addChild:myLabel];
        
        _returnToIntroButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_returnToIntroButton setLabelWithText:@"Return To Main Menu" andFont:[UIFont fontWithName:@"Chalkduster" size:25] withColor:[UIColor whiteColor]];
        _returnToIntroButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -50);
        _returnToIntroButton.name = @"return";
        [self addChild:_returnToIntroButton];
        
        SKAction *returnToIntro = [SKAction performSelector:@selector(returnToIntro) onTarget:self];
        [_returnToIntroButton performAction:returnToIntro onObject:self withEvent:AGButtonControlEventTouchDown];
        
        _playAgianButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_playAgianButton setLabelWithText:@"Play Again" andFont:[UIFont fontWithName:@"Chalkduster" size:25] withColor:[UIColor whiteColor]];
        _playAgianButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -150);
        _playAgianButton.name = @"return";
        [self addChild:_playAgianButton];
        
        SKAction *playAgain = [SKAction performSelector:@selector(playAgain) onTarget:self];
        [_playAgianButton performAction:playAgain onObject:self withEvent:AGButtonControlEventTouchDown];
        
    }
    return self;
}

-(void) returnToIntro
{
    IntroScene *intro = [IntroScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:intro transition:transition];
}

-(void) playAgain
{
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}


@end

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

@interface IntroScene ()

@property (strong, nonatomic) AGSpriteButton *playButton;
@property (strong, nonatomic) AGSpriteButton *creditButton;

@end

@implementation IntroScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
        SKLabelNode *titleLable = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        titleLable.text = @"MGD GAME";
        titleLable.fontSize = 44;
        titleLable.position = CGPointMake(CGRectGetMidX(self.frame),
                                         CGRectGetMidY(self.frame)+100);
        
        [self addChild:titleLable];
        
        _playButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_playButton setLabelWithText:@"Play" andFont:[UIFont fontWithName:@"Chalkduster" size:44] withColor:[UIColor whiteColor]];
        _playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+20);
        _playButton.name = @"play";
        [self addChild:_playButton];
        
        SKAction *playGame = [SKAction performSelector:@selector(playGame) onTarget:self];
        
        [_playButton performAction:playGame onObject:self withEvent:AGButtonControlEventTouchDown];
        
        _creditButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_creditButton setLabelWithText:@"Credits" andFont:[UIFont fontWithName:@"Chalkduster" size:44] withColor:[UIColor whiteColor]];
        _creditButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -50);
        _creditButton.name = @"credits";
        [self addChild:_creditButton];
        
        SKAction *rollCredits = [SKAction performSelector:@selector(rollCredits) onTarget:self];
        
        [_creditButton performAction:rollCredits onObject:self withEvent:AGButtonControlEventTouchDown];
    }
    return self;
}

-(void) playGame
{
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

-(void) rollCredits
{
    CreditScene *creditScene = [CreditScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:creditScene transition:transition];
}


@end

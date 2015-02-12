//
//  GameOverScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/12/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "GameOverScene.h"
#import "GamePlayScene.h"


@implementation GameOverScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Game Over";
        myLabel.fontSize = 45;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}


@end

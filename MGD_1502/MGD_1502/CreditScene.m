//
//  CreditScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/25/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "CreditScene.h"
#import "AGSpriteButton.h"
#import "IntroScene.h"

@interface CreditScene()

@property(strong, nonatomic) AGSpriteButton *backButton;

@end

@implementation CreditScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        nameLabel.text = @"Developer: Robert Smith";
        nameLabel.fontSize = 20;
        nameLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)+50);
        
        [self addChild:nameLabel];
        
        SKLabelNode *companyLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        companyLabel.text = @"Company: Full Sail University";
        companyLabel.fontSize = 20;
        companyLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:companyLabel];
        
        _backButton = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
        [_backButton setLabelWithText:@"Back" andFont:[UIFont fontWithName:@"Chalkduster" size:20] withColor:[UIColor whiteColor]];
        _backButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) -50);
        _backButton.name = @"back";
        [self addChild:_backButton];
        
        SKAction *back = [SKAction performSelector:@selector(back) onTarget:self];
        
        [_backButton performAction:back onObject:self withEvent:AGButtonControlEventTouchDown];
    }
    return self;
}

-(void) back
{
    IntroScene *intro = [IntroScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:intro transition:transition];
}

@end

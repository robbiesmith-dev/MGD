//
//  GameScene.m
//  MGD_1502
//
//  Created by Robert Smith on 2/3/15.
//  Copyright (c) 2015 Robert Smith. All rights reserved.
//

#import "GamePlayScene.h"
#import "RandomGen.h"
#import <AVFoundation/AVFoundation.h>
#import "GameOverScene.h"

@interface GamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdate;
@property (nonatomic) NSTimeInterval lastTimeSpawned;

@property (nonatomic) AVAudioPlayer *track;

@property CGPoint spaceshipCenter;

@property BOOL spaceshipTouched;

@property (nonatomic) NSInteger score;

@property (nonatomic) SKNode *hud;


@end

typedef NS_OPTIONS(NSUInteger, Collitions)
{
    Player = 1 << 0,
    Laser = 1 << 1,
    Ground = 1 << 2,
};

@implementation GamePlayScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        
        _score = 0;
        
        self.spaceshipTouched = NO;
        
        //Manage Time Intervals
        self.lastUpdate = 0;
        self.lastTimeSpawned = 0;
        
        // add a physics body to the scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        // change gravity settings of the physics world
        self.physicsWorld.gravity = CGVectorMake(0, -1.5);
        //Edge Frame
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.physicsWorld.contactDelegate = self;
        
        [self addBG];
        [self addPlayer];
        [self addGround];
        [self addHUD];
        
        NSURL *trackURL = [[NSBundle mainBundle] URLForResource:@"MGD_BG_Track" withExtension:@"mp3"];
        
        self.track = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:nil];
        self.track.numberOfLoops = -1;
        [self.track prepareToPlay];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    [self.track play];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        //CGPoint location = [touch locationInNode:self];
        
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for (SKNode *node in nodes)
        {
            if ([node.name isEqualToString:@"player"])
            {
                self.spaceshipTouched = YES;
                [self runAction:[SKAction playSoundFileNamed:@"spaceship.wav" waitForCompletion:NO]];
            }
            else
            {
                self.spaceshipTouched = NO;
            }
            
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.spaceshipTouched == YES)
    {
        for (UITouch *touch in touches)
        {
            CGPoint location = [touch locationInNode:self];
            CGPoint newPosition = CGPointMake(location.x, location.y);
            
            // limit movement so player cant hide or go below ground sprite
            // X
            if (newPosition.x < _player.size.width / 2)
            {
                newPosition.x = _player.size.width / 2;
            }
            if (newPosition.x > self.size.width - (_player.size.width/2))
            {
                newPosition.x = self.size.width - (_player.size.width/2);
            }
            
            // Y
            if (newPosition.y < _player.size.height -10 / 2)
            {
                newPosition.y = _player.size.height - 10 / 2;
            }
            if (newPosition.y > self.size.height - 10 - (_player.size.width/2))
            {
                newPosition.y = self.size.height - 10 - (_player.size.width/2);
            }
            
            // Move the ship
            _player.position = newPosition;
        }

    }
    else
    {
        return;
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    //Update Time Management
    if (self.lastUpdate)
    {
        self.lastTimeSpawned += currentTime - self.lastUpdate;
    }
    
    if (self.lastTimeSpawned > .5)
    {
        [self addLaser];
        //Reset
        self.lastTimeSpawned = 0;
    }
    
    self.lastUpdate = currentTime;
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *bodyOne;
    SKPhysicsBody *bodyTwo;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        bodyOne = contact.bodyA;
        bodyTwo = contact.bodyB;
    }
    else
    {
        bodyOne = contact.bodyB;
        bodyTwo = contact.bodyA;
    }
    if (bodyOne.categoryBitMask == Player && bodyTwo.categoryBitMask == Laser)
    {
        NSLog(@"LOSSER");
        
        [self.track stop];
        
        [self runAction:[SKAction playSoundFileNamed:@"You Lose.mp3" waitForCompletion:NO]];

        SKSpriteNode *player = (SKSpriteNode*)bodyOne.node;
        
        [player removeFromParent];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GameOverScene *gameOverScene = [GameOverScene sceneWithSize:self.frame.size];
            SKTransition *transition = [SKTransition fadeWithDuration:1.0];
            [self.view presentScene:gameOverScene transition:transition];
        });


        
    }
    else if (bodyOne.categoryBitMask == Laser && bodyTwo.categoryBitMask == Ground)
    {
        NSLog(@"AVOIDED");
        
        SKSpriteNode *laser = (SKSpriteNode*)bodyOne.node;
        
        [laser removeFromParent];
        
        _score++;
        
        [self updateScore];
        
        NSLog(@"%ld",(long) _score);
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addHUD
{
    _hud = [[SKNode alloc] init];
    _hud.position = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    _hud.zPosition = 20;
    
    SKLabelNode *score = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    score.name = @"Score";
    score.position = CGPointMake(_hud.position.x + 25, _hud.position.y + 630);
    score.text = [NSString stringWithFormat:@"%ld",(long) _score];
    [_hud addChild:score];
    
    [self addChild:_hud];
    
    
}

-(void) updateScore
{
    SKLabelNode *score = (SKLabelNode*)[_hud childNodeWithName:@"Score"];
    
    score.text = [NSString stringWithFormat:@"%ld",(long) _score];
    
}


- (void)addPlayer
{
    //Player
    _player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _player.size = CGSizeMake(55, 55);
    _player.position = CGPointMake(self.frame.size.width/2, 100);
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.frame.size];
    _player.physicsBody.dynamic = NO;
    _player.name = @"player";
    
    _player.physicsBody.categoryBitMask = Player;
    _player.physicsBody.contactTestBitMask = Laser;
    
    [self addChild:_player];
}

- (void)addBG
{
    //Set Sky from PNG
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"newBG"];
    sky.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    sky.anchorPoint = CGPointMake(0, 0);
    sky.position = CGPointMake(0, 0);
    sky.name = @"bg";
    
    [self addChild:sky];
}

-(void)addLaser
{
    SKSpriteNode *laser = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(3, 10)];
    
    float y = self.frame.size.height  - laser.size.height;
    float x = [RandomGen randomSpotFromLeft:5 + laser.size.width
                                      right:self.frame.size.width - 5];
    
    laser.position = CGPointMake(x,y);
    
    laser.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:laser.frame.size];
    laser.physicsBody.categoryBitMask = Laser;
    laser.physicsBody.contactTestBitMask = Ground | Player;
    laser.name = @"laser";
    
    [self addChild:laser];
    
    [self runAction:[SKAction playSoundFileNamed:@"rock.wav" waitForCompletion:NO]];

}

-(void)addGround
{
    //Ground
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.frame.size.width, 2)];
    SKSpriteNode *player = (SKSpriteNode*)[self childNodeWithName:@"player"];
    ground.position = CGPointMake(self.frame.size.width/2, player.position.y - 5);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.frame.size];
    ground.physicsBody.categoryBitMask = Ground;
    ground.physicsBody.contactTestBitMask = Laser;
    ground.name = @"laser";
    
    [self addChild:ground];
}


@end

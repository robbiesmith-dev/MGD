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
#import "AGSpriteButton.h"

@interface GamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdate;

@property (nonatomic) NSTimeInterval lastTimeSpawned;

@property (nonatomic) NSTimeInterval totalGameTime;

@property (nonatomic) NSTimeInterval addLasers;

@property (nonatomic) AVAudioPlayer *track;

@property CGPoint spaceshipCenter;

@property BOOL spaceshipTouched;

@property (nonatomic) NSInteger score;

@property (nonatomic) SKNode *hud;

@property (nonatomic) SKNode *gameplayNode;

@property (nonatomic) SKNode *pauseMenu;

@property (nonatomic) AGSpriteButton *button;

@property (nonatomic) SKSpriteNode *life;

@property (nonatomic) NSInteger lives;



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
        [self registerAppTransitionObservers];
        
        _gameplayNode = [[SKNode alloc]init];
        _gameplayNode.position = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        [self addChild:_gameplayNode];
        
        _score = 0;
        _lives = 3;
        
        self.spaceshipTouched = NO;
        
        //Manage Time Intervals
        self.lastUpdate = 0;
        
        self.lastTimeSpawned = 0;
        
        self.totalGameTime = 0;
        
        self.addLasers = 0;
        
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
    if (_isPaused)
    {
        return;
        
    }
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
            else if ([node.name isEqualToString:@"pause"])
            {
                if (_isPaused == NO)
                {
                    [self pauseGame];
                }
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
    if (_isPaused)
    {
        return;
    }
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
    if (!_isPaused)
    {
        //Update Time Management
        if (self.lastUpdate)
        {
            self.lastTimeSpawned += currentTime - self.lastUpdate;
            self.totalGameTime += currentTime - self.lastUpdate;
        }
        
        if (self.lastTimeSpawned > .5)
        {
            [self addLaser];
            //Reset
            self.lastTimeSpawned = 0;
        }
        
        self.lastUpdate = currentTime;
        
        
        if (self.totalGameTime > 240)
        {
            self.addLasers = .4;
        }
        else if (self.totalGameTime > 120)
        {
            self.addLasers = .3;
        }
        else if (self.totalGameTime > 10)
        {
            self.addLasers = .2;
        }

    }

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
        if (_lives > 0)
        {
            
            if (_lives == 3)
            {
                SKNode *life = [_hud childNodeWithName:@"one"];
                SKSpriteNode *laser = (SKSpriteNode*)bodyTwo.node;
               // [self runAction:[SKAction playSoundFileNamed:@"LifeLost.m4a" waitForCompletion:NO]];
                [laser removeFromParent];
                [life removeFromParent];
            }
            else if (_lives == 2)
            {
                SKNode *life = [_hud childNodeWithName:@"two"];
                SKSpriteNode *laser = (SKSpriteNode*)bodyTwo.node;
                //[self runAction:[SKAction playSoundFileNamed:@"LifeLost.m4a" waitForCompletion:NO]];
                [laser removeFromParent];
                [life removeFromParent];
            }
            else if (_lives == 1)
            {
                SKNode *life = [_hud childNodeWithName:@"three"];
                SKSpriteNode *laser = (SKSpriteNode*)bodyTwo.node;
               // [self runAction:[SKAction playSoundFileNamed:@"LifeLost.m4a" waitForCompletion:NO]];
                [laser removeFromParent];
                [life removeFromParent];
            }
            
            _lives--;
            return;
        }
        NSLog(@"LOSSER");
        
        [self.track stop];
        
        [self runAction:[SKAction playSoundFileNamed:@"You Lose.mp3" waitForCompletion:NO]];

        SKSpriteNode *player = (SKSpriteNode*)bodyOne.node;
        SKSpriteNode *laser = (SKSpriteNode*)bodyTwo.node;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
        
        SKEmitterNode *boom = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        boom.position = player.position;
        
        [laser removeFromParent];
        [player removeFromParent];
        
        [self addChild:boom];

        [boom runAction:[SKAction waitForDuration:2.0] completion:^{
            [boom removeFromParent];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            GameOverScene *gameOverScene = [GameOverScene sceneWithSize:self.frame.size];
            SKTransition *transition = [SKTransition fadeWithDuration:1.0];
            [self.view presentScene:gameOverScene transition:transition];
        });


        
    }
    else //if (bodyOne.categoryBitMask == Laser && bodyTwo.categoryBitMask == Ground)
    {
        NSLog(@"AVOIDED");
        
        SKSpriteNode *laser = (SKSpriteNode*)bodyOne.node;
        
        [laser removeFromParent];
        
        _score++;
        
        [self updateScore];
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
    score.position = CGPointMake(CGRectGetMinX(self.frame)+35, CGRectGetMaxY(self.frame)-35);
    score.text = [NSString stringWithFormat:@"%ld",(long) _score];
    [_hud addChild:score];
    
    _button = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(50, 50)];
    [_button setLabelWithText:@"Pause" andFont:[UIFont fontWithName:@"Chalkduster" size:14] withColor:[UIColor whiteColor]];
    _button.position = CGPointMake(CGRectGetMaxX(self.frame) -30, CGRectGetMaxY(self.frame) -25);
    _button.name = @"pause";
    [_hud addChild:_button];
    
    _life = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _life.size = CGSizeMake(25, 25);
    _life.position = CGPointMake(CGRectGetMaxX(self.frame) -20, CGRectGetMaxY(self.frame) -60);
    _life.name = @"one";
    [_hud addChild:_life];
    
    _life = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _life.size = CGSizeMake(25, 25);
    _life.position = CGPointMake(CGRectGetMaxX(self.frame) -50, CGRectGetMaxY(self.frame) -60);
    _life.name = @"two";
    [_hud addChild:_life];
    
    _life = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    _life.size = CGSizeMake(25, 25);
    _life.position = CGPointMake(CGRectGetMaxX(self.frame) -80, CGRectGetMaxY(self.frame) -60);
    _life.name = @"three";
    [_hud addChild:_life];
    
    SKAction *pauseGame = [SKAction performSelector:@selector(pauseGame) onTarget:self];
    
    [_button performAction:pauseGame onObject:self withEvent:AGButtonControlEventTouchDown];
    
    [self addChild:_hud];
    
}

-(void) pauseGame
{
    if (_isPaused)
    {
        _isPaused = NO;
        self.gameplayNode.paused = NO;
    }
    else
    {
        _isPaused = YES;
        self.gameplayNode.paused = YES;
    }
}

-(void) resumeGame
{
    _isPaused = NO;
    self.gameplayNode.paused = NO;
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
    
    [_gameplayNode addChild:_player];
}

- (void)addBG
{
    //Set Sky from PNG
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"newBG"];
    sky.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    sky.anchorPoint = CGPointMake(0, 0);
    sky.position = CGPointMake(0, 0);
    sky.name = @"bg";
    
    [_gameplayNode addChild:sky];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)registerAppTransitionObservers
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:NULL];
}

-(void)applicationWillResignActive
{
    if (!_isPaused)
    {
        [self pauseGame];
    }
}

-(void)applicationDidEnterBackground
{
    [_track stop];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    self.gameplayNode.paused = YES;
}

-(void)applicationWillEnterForeground
{
    self.view.paused = NO;
    if (_isPaused)
    {
        self.gameplayNode.paused = YES;
    }
}

@end

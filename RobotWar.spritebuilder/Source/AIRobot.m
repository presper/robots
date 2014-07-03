//
//  AIRobot.m
//  RobotWar
//
//  Created by ronin on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AIRobot.h"

/*
 Goal is to beat the SimpleRobot
 Then goal is to build AI such that it can defeat others
 
 Thoughts re: AI
 Have it shoot first, out of the gate
 Then, do a circle around the center of the Arena
 Edge of circle to corner of Arena is 150 distance (scan distance)
 When enemy detected, move first along diagonal created by centers of self and enemy
 Then keep cornering enemy, 
 firing based on new position
 
 */

static int _TURN_AROUND = 360;
static int _EXTRA_GUN_OFFSET = 0;
static CGFloat _STUN_TIME = 1.0f;

typedef NS_ENUM(NSInteger, RobotAction) {
    RobotActionDefault,
    RobotActionTurnaround
};

@implementation AIRobot {
    RobotAction *_currentRobotAction;
    CGFloat lastShotTime;
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotAction != (RobotAction *)RobotActionTurnaround) {
        [self cancelActiveAction];
        
        // goal is to turn turret toward detected enemy
        
        CGFloat angleToEnemy = [self angleBetweenGunHeadingDirectionAndWorldPosition:position];
        angleToEnemy += _EXTRA_GUN_OFFSET;
        
        if (angleToEnemy < 0) {
            angleToEnemy += _TURN_AROUND;
            [self turnGunLeft:angleToEnemy];
        } else {
            [self turnGunRight:angleToEnemy];
        }
        
        CGFloat _currentTime = [self currentTimestamp];
        if ( _currentTime > _STUN_TIME + lastShotTime) {
            NSLog(@"TIME: %f",_currentTime);
            [self shoot];
        }
        
        //[self turnRobotLeft:20];
        //[self moveBack:80];
        [self turnRobotLeft:15];
        [self moveAhead:40];
        
    }
}

- (void)bulletHitEnemy:(Bullet*)bullet {
    NSLog(@"HERE");
    [self cancelActiveAction];
    NSLog(@"CANCELLED");
    CGFloat _currentTime = [self currentTimestamp];
    if ( _currentTime > _STUN_TIME + lastShotTime) {
        NSLog(@"BULLET TIME: %f",_currentTime);
        [self shoot];
    }
    [self moveBack:40];
}

- (void)shoot {
    lastShotTime = [self currentTimestamp];
    [super shoot];
}

/*
- (void)gotHit {
    [self shoot];
    [self turnRobotLeft:45];
    [self moveAhead:100];
}
 */


@end

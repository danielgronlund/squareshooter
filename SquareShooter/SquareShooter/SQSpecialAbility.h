//
//  SQSpecialAbility.h
//  SquareShooter
//
//  Created by Daniel Grönlund on 2015-11-27.
//  Copyright © 2015 Daniel Grönlund. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SQSpecialAbilityType) {
    SQSpecialAbilityTypeFireRate,
    SQSpecialAbilityTypeExtraDamage,
    SQSpecialAbilityTypeSuperSpeed,
    SQSpecialAbilityTypeBazooka
};

@interface SQSpecialAbility : NSObject
@property (nonatomic) float abilityValue;
@property (nonatomic) SQSpecialAbilityType type;
@end

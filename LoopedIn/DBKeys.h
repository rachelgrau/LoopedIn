//
//  DBKeys.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <Foundation/Foundation.h>

/* User table keys */
#define USERNAME @"username"
#define PASSWORD @"password"
#define ROLE @"role"
#define FULL_NAME @"fullName"
#define POINTS @"points"
#define PARENTHOOD_EMAIL @"parenthoodEmail"
#define DESIRED_REWARD @"desiredReward"

/* Role types */
#define STUDENT_ROLE @"Student"
#define PARENT_ROLE @"Parent"
#define TEACHER_ROLE @"Teacher"

/* Parenthood table name and keys */
#define PARENTHOOD_CLASS_NAME @"Parenthood"
#define CHILD @"child"
#define PARENT @"parent"

/* Reward table name and keys */
#define REWARD_CLASS_NAME @"Reward"
#define REWARD_POINTS @"pointsRequired"
#define REWARD_TITLE @"title"
#define REWARD_DESCRIPTION @"description"

/* Class table */
#define CLASS_CLASS_NAME @"Class"
#define CLASS_NAME @"name"
#define CLASS_TEACHER @"teacher"

//
//  DBKeys.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <Foundation/Foundation.h>

/* User table keys */
#define USER_CLASS_NAME @"User"
#define USERNAME @"username"
#define PASSWORD @"password"
#define ROLE @"role"
#define FULL_NAME @"fullName"
#define POINTS @"points"
#define PARENTHOOD_EMAIL @"parenthoodEmail"
#define DESIRED_REWARD @"desiredReward"
#define PROFILE_PIC @"profilePic"

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
#define CLASS_CODE @"classCode"
#define CLASS_STUDENTS @"students"

/* Task table */
#define TASK_CLASS_NAME @"Task"
#define TASK_NAME @"name"
#define TASK_DESC @"description"
#define TASK_DUE_DATE @"dueDate"
#define TASK_POINTS @"points"
#define TASK_TEACHER @"teacher"
#define TASK_ASIGNEES @"asignees"

/* Task Completion table */
#define TASK_COMPLETION_CLASS_NAME @"TaskCompletion"
#define TASK_IS_COMPLETED @"isCompleted"
#define TASK_COMPLETION_TASK @"task"
#define TASK_COMPLETION_ASIGNEE @"asignee"
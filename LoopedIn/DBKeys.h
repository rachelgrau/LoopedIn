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
#define BOUGHT_REWARD @"boughtDesiredReward"
#define MY_CLASSES @"classes"

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
#define REWARD_CLASS @"class"

/* Class table */
#define CLASS_CLASS_NAME @"Class"
#define CLASS_NAME @"name"
#define CLASS_TEACHER @"teacher"
#define CLASS_CODE @"classCode"
#define CLASS_STUDENTS @"students"
#define CLASS_TYPE @"classType"

/* Task table -- for a task object (1 per task) */
#define TASK_CLASS_NAME @"Task"
#define TASK_NAME @"name"
#define TASK_DESC @"description"
#define TASK_DUE_DATE @"dueDate"
#define TASK_POINTS @"points"
#define TASK_TEACHER @"teacher"
#define TASK_CLASS @"myClass"
#define TASK_FOR_STUDENTS @"forStudents"
#define TASK_FOR_PARENTS @"forParents"

/* Task Completion join table b/t tasks and users (asignees) -- keeps track of individual tasks from student perspective (e.g. for each task, there is one TaskCompletion object for each person assigned to that task). Stores metadata like whether the task has been completed by the given user. */
#define TASK_COMPLETION_CLASS_NAME @"TaskCompletion"
#define TASK_IS_COMPLETED @"isCompleted"
#define TASK_COMPLETION_TASK @"task"
#define TASK_COMPLETION_ASIGNEE @"asignee"

/* Class types */
#define CLASS_TYPE_SCIENCE @"Science"
#define CLASS_TYPE_MATH @"Math"
#define CLASS_TYPE_ENGLISH @"English"
#define CLASS_TYPE_LANGUAGE @"Language"
#define CLASS_TYPE_HISTORY @"History"
#define CLASS_TYPE_ART @"Art"
//
//  Person+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by liuzhao on 2019/2/21.
//  Copyright © 2019 liuzhao. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;

@end

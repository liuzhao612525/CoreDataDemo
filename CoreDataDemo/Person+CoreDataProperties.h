//
//  Person+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by liuzhao on 2019/2/21.
//  Copyright © 2019 liuzhao. All rights reserved.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t age;

@end

NS_ASSUME_NONNULL_END

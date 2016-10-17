//
//  NSError+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 12/09/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
// https://developer.apple.com/library/mac/documentation/Cocoa/Reference/CoreDataFramework/Miscellaneous/CoreData_Constants/index.html

#import "NSError+MHD.h"

@implementation NSError (MHD)

- (BOOL)mhd_isValidation{
    if(self.domain != NSCocoaErrorDomain){
        return NO;
    }
    return self.code >= 1550 && self.code <= 1680;
}

- (BOOL)mhd_isConstraintMergeError{
    if(self.domain != NSCocoaErrorDomain){
        return NO;
    }
    
    return self.code == NSManagedObjectConstraintMergeError;
}

- (NSDictionary *)mhd_constraintConflictsByConstraint{
    if(!self.mhd_isConstraintMergeError){
        return nil;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSArray *conflictList = [self.userInfo objectForKey:@"conflictList"];
    
    for (NSConstraintConflict * conflict in conflictList) {
        NSString *constraint = [conflict.constraint componentsJoinedByString:@", "];
        NSString *msg = [NSString stringWithFormat:@"%ld conflicted objects", conflict.conflictingObjects.count];
        NSArray* messageArray = dict[constraint];
        if(!messageArray){
            messageArray = [NSArray arrayWithObject:msg];
        }else{
            messageArray = [messageArray arrayByAddingObject:msg];
        }
        dict[constraint] = messageArray;
    }
    return dict.copy;
}

- (NSDictionary *)mhd_validationDescriptionsByEntityName{
    if(!self.mhd_isValidation){
        return nil;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSArray *errors;
    // multiple errors?
    if (self.code == NSValidationMultipleErrorsError) {
        errors = [self.userInfo objectForKey:NSDetailedErrorsKey];
    } else {
        errors = [NSArray arrayWithObject:self];
    }
    
    for (NSError * error in errors) {
        
        NSManagedObject *object = [error.userInfo objectForKey:@"NSValidationErrorObject"];
        NSString *entityName = object.entity.name;
        if(!entityName){
            entityName = @"Unknown";
        }
        
        NSString *attributeName = [error.userInfo objectForKey:@"NSValidationErrorKey"];
        if(!attributeName){
            attributeName = @"unknown";
        }
        
        NSString *msg;
        switch (error.code) {
            case NSManagedObjectValidationError:
                msg = @"Generic validation error.";
                break;
            case NSManagedObjectConstraintValidationError:
                msg = @"Constraint validation error.";
                break;
            case NSValidationMissingMandatoryPropertyError:
                msg = [NSString stringWithFormat:@"The %@ property is required.", attributeName];
                break;
            case NSValidationRelationshipLacksMinimumCountError:
                msg = [NSString stringWithFormat:@"The %@ relationship lacks minimum count.", attributeName];
                break;
            case NSValidationRelationshipExceedsMaximumCountError:
                msg = [NSString stringWithFormat:@"The %@ relationship exceeds maximum count.", attributeName];
                break;
            case NSValidationRelationshipDeniedDeleteError:
                msg = [NSString stringWithFormat:@"The relationship %@ denied delete.", attributeName];
                break;
            case NSValidationNumberTooLargeError:
                msg = [NSString stringWithFormat:@"The %@ is too large.", attributeName];
                break;
            case NSValidationNumberTooSmallError:
                msg = [NSString stringWithFormat:@"The %@ is too small.", attributeName];
                break;
            case NSValidationDateTooLateError:
                msg = [NSString stringWithFormat:@"The %@ is too late.", attributeName];
                break;
            case NSValidationDateTooSoonError:
                msg = [NSString stringWithFormat:@"The %@ is too soon.", attributeName];
                break;
            case NSValidationInvalidDateError:
                msg = [NSString stringWithFormat:@"The %@ is not a valid date.", attributeName];
                break;
            case NSValidationStringTooLongError:
                msg = [NSString stringWithFormat:@"The %@ is too long.", attributeName];
                break;
            case NSValidationStringTooShortError:
                msg = [NSString stringWithFormat:@"The %@ is too short.", attributeName];
                break;
            case NSValidationStringPatternMatchingError:
                msg = [NSString stringWithFormat:@"The %@ does not match the required pattern.", attributeName];
                break;
            default:
                msg = [NSString stringWithFormat:@"Unknown error code %ld.", (long)error.code];
                break;
        }
        NSArray* messageArray = dict[entityName];
        if(!messageArray){
            messageArray = [NSArray arrayWithObject:msg];
        }else{
            messageArray = [messageArray arrayByAddingObject:msg];
        }
        dict[entityName] = messageArray;
    }
    return dict.copy;
}

- (NSString *)mhd_displayDescription{
    
    NSString *description;
    NSDictionary *dict;
    if(self.mhd_isValidation){
        dict = self.mhd_validationDescriptionsByEntityName;
    }
    else if(self.mhd_isConstraintMergeError){
        // e.g. id: 4 conflicted objects
        dict = self.mhd_constraintConflictsByConstraint;
    }
    
    if(dict){
        NSMutableArray* messages = [NSMutableArray array];
        for(NSString *key in dict.allKeys){
            NSArray* value = dict[key];
            NSString* message = [NSString stringWithFormat:@"%@: %@", key, [value componentsJoinedByString:@" "]];
            [messages addObject:message];
        }
        description = [messages componentsJoinedByString:@"\n"];
    }
    else{
        description = self.localizedDescription;
    }
    return description;
}

@end

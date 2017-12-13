//
//  MCDFetchedResultsTableViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 MAlcolm Hall. All rights reserved.
//

#import "MCDFetchedTableViewController.h"

//static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";
//static void * const kMCDFetchedResultsTableViewControllerKVOContext = (void *)&kMCDFetchedResultsTableViewControllerKVOContext;

@implementation MCDFetchedTableViewController{
    //NSString *_messageWhenNoRows;
}
@synthesize tableData = _tableData;

- (void)loadView{
    [super loadView]; // loads from nib or creates and calls setView
    self.tableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
}

- (void)setTableData:(MCDFetchedTableData *)tableData{
    if(_tableData != tableData){
        if(_tableData.delegate == self){
            _tableData.delegate = nil;
        }
        _tableData = tableData;
        if(!tableData.delegate){
            tableData.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if(!self.tableData.fetchedResultsController.fetchedObjects){
        [self.tableData.fetchedResultsController performFetch:nil];
    }
    [super viewWillAppear:animated]; // reloads table if there are currently no sections
}



//- (NSString *)messageWhenNoRows{
//    if(!_messageWhenNoRows){
//        _messageWhenNoRows = kDefaultmessageWhenNoRows;
//    }
//    return _messageWhenNoRows;
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    id object = [self objectAtTableViewIndexPath:indexPath];
//    if(!object){
//        return;
//    }
//    [self didSelectObject:object];
//}
//
//- (void)didSelectObject:(id)object{
//    return;
//}

//- (void)deselectObject:(id)object animated:(BOOL)animated{
//    NSIndexPath *indexPath = [self tableViewIndexPathForObject:object];
//    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
//}




@end

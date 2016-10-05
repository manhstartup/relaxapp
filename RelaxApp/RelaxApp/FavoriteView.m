//
//  FavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "FavoriteView.h"
#import "Define.h"
#import "AHTagTableViewCell.h"
#import "FileHelper.h"
static NSString *identifierSection1 = @"MyTableViewCell1";

@implementation FavoriteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    [self.tableControl registerNib:[UINib nibWithNibName:@"AHTagTableViewCell" bundle:nil] forCellReuseIdentifier:identifierSection1];
    self.tableControl.estimatedRowHeight = 60;
    self.tableControl.allowsSelectionDuringEditing = YES;
    [self loadCahe];
}
-(void)loadCahe
{
    //read in cache
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _arrMusic = [arrTmp mutableCopy];
    [self.tableControl reloadData];

}
-(IBAction)editingTableViewAction:(id)sender
{
    [self.tableControl setEditing: !self.tableControl.editing animated: YES];
}
//section Mes...Mes_groupes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrMusic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHTagTableViewCell *cell = nil;
    
    cell = (AHTagTableViewCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection1 forIndexPath:indexPath];
    
    NSDictionary *dicMusic = _arrMusic[indexPath.row];
    
    [cell fnSetDataWithDicMusic:dicMusic];
//    cell.btnSelect.tag=indexPath.row;
//    [cell.btnSelect addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];

    cell.backgroundColor=[UIColor clearColor];
    cell.tintColor = [UIColor blueColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak FavoriteView *wself = self;
    NSDictionary *dicMusic = _arrMusic[indexPath.row];
    if (tableView.editing) {
        //favorite
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self];
        self.vAddFavorite.modeType = MODE_EDIT;
        [self.vAddFavorite setCallback:^(NSDictionary *dicCategory)
         {
             [wself loadCahe];
         }];

        [self.vAddFavorite fnSetInfoFavorite:dicMusic];
        

    }
    else
    {
        if (_callback) {
            _callback(dicMusic);
            [self removeFromSuperview];
        }

    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrMusic removeObjectAtIndex:indexPath.row];
        //add code here for when you hit delete
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
        [_arrMusic writeToFile:strPath atomically:YES];
        [self.tableControl reloadData];
    }
}

@end
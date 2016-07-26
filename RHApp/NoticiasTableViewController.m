//
//  NoticiasTableViewController.m
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import "NoticiasTableViewController.h"
#import "APIManager.h"
#import <TSMessage.h>
#import "NewsEntry.h"
#import "DetalleViewController.h"


// Macro for RGB color definition
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString *const kNoticiasCellId = @"NoticiasCellId";

NSString *const kURLNoticias = @"http://feed.blogthinkbig.com";
NSString *const kNOTICIAITEM = @"item";
NSString *const kNOTICIATITLE = @"title";
NSString *const kNOTICIACREATOR = @"dc:creator";
NSString *const kNOTICIAPUBDATE = @"pubDate";
NSString *const kNOTICIADESCRIPTION = @"description";
NSString *const kNOTICIACONTENT = @"content:encoded";
NSString *const kNOTICIAIMAGE = @"image";
NSString *const kNOTICIALINK = @"link";


@interface NoticiasTableViewController () <NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *creator;
    NSMutableString *pubDate;
    NSMutableString *description;
    NSMutableString *content;
    NSString *element;
    NSString *location;
    NSMutableString *link;
}

@end

@implementation NoticiasTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadNewsEntries];
}

- (void)loadNewsEntries {
    feeds = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:kURLNoticias];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoticiasCellId
                                                            forIndexPath:indexPath];
    NSDictionary *feed = feeds[indexPath.row];
    
    UIImageView *noticiaImage = (UIImageView *)[cell viewWithTag:80];
    if ([feed objectForKey:kNOTICIAIMAGE]) {
        [noticiaImage sd_setImageWithURL:feed[kNOTICIAIMAGE]];
    }

    UILabel *titleLabel = (UILabel *)[cell viewWithTag:82];
    titleLabel.text = feed[kNOTICIATITLE];
    
    UILabel *authorLabel = (UILabel *)[cell viewWithTag:83];
    authorLabel.text = feed[kNOTICIACREATOR];

    UILabel *pubDateLabel = (UILabel *)[cell viewWithTag:84];
    pubDateLabel.text = feed[kNOTICIAPUBDATE];
    
    // Hacer transparentes las celdas
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    // Cambia el fondo al seleccionar una celda
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = UIColorFromRGB(0x4462A5);
    [cell setSelectedBackgroundView:myBackView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detalleNoticia" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detalleNoticia"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [(DetalleViewController *)[segue destinationViewController] setNoticia:feeds[indexPath.row]];
    }
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    if ([element isEqualToString:kNOTICIAITEM]) {
        item = [NSMutableDictionary dictionary];
        title = [NSMutableString new];
        creator = [NSMutableString new];
        pubDate = [NSMutableString new];
        description = [NSMutableString new];
        content = [NSMutableString new];
        link = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:kNOTICIATITLE]) {
        [title appendString:string];
    } else if ([element isEqualToString:kNOTICIACREATOR]) {
        [creator appendString:string];
    } else if ([element isEqualToString:kNOTICIAPUBDATE]) {
        [pubDate appendString:string];
    } else if ([element isEqualToString:kNOTICIADESCRIPTION]) {
        [description appendString:string];
    } else if ([element isEqualToString:kNOTICIACONTENT]) {
        [content appendString:string];
    } else if ([element isEqualToString:kNOTICIALINK]) {
        [link appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kNOTICIAITEM]) {
        [item setObject:[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIATITLE];
        [item setObject:[creator stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIACREATOR];
        [item setObject:[pubDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIAPUBDATE];
        [item setObject:[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIADESCRIPTION];
        [item setObject:[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIACONTENT];
        NSURL *urlImg = [self getURLFirstImageWithinText:content];
        if (urlImg) {
            [item setObject:urlImg forKey:kNOTICIAIMAGE];
        }
        [item setObject:[link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:kNOTICIALINK];
        
        [feeds addObject:[item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

#pragma mark - Utils methods

- (NSURL *)getURLFirstImageWithinText:(NSString *)text {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://[^\\s]*(.jpg)[^\\s]*"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!error) {
        NSRange range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
        if (range.location != NSNotFound) {
            NSString *urlImg = [text substringWithRange:range];
            return [NSURL URLWithString:[urlImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return nil;
}

@end

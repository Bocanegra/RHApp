//
//  VacantesTableViewController.m
//  RHApp
//
//  Created by Luis Ángel García Muñoz on 27/5/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import "VacantesTableViewController.h"
#import "MasInformacionController.h"
#import "HeaderTableViewCell.h"

#import <TSMessage.h>

static NSString *const kIdentifierDetailCellHeader = @"CellHeader";
static NSString *const kIdentifierVacanteCell = @"vacanteCell";

static NSString *const kITEM = @"item";
static NSString *const kTITLE = @"title";
static NSString *const kLINK = @"link";
static NSString *const kDESCRIPTION = @"description";
static NSString *const kPUBDATE = @"pubDate";
static NSString *const kLOCATION = @"location";


@interface VacantesTableViewController () <NSXMLParserDelegate, SectionHeaderViewDelegate> {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *description;
    NSMutableString *link;
    NSMutableString *pubDate;
    NSString *element;
    NSString *location;
}

@property (strong, nonatomic) NSArray *areasFuncionales;
@property (nonatomic) NSUInteger indiceSeccionAbierta;
@property (nonatomic) NSUInteger indiceSeccionAbriendo;

@end

@implementation VacantesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(reloadVacantes)
                  forControlEvents:UIControlEventValueChanged];
    
    // Registro de la cabecera con las Áreas funcionales
    UINib *headerNib = [UINib nibWithNibName:@"VacantesHeaderView" bundle:nil];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:kIdentifierDetailCellHeader];
    
    // Áreas funcionales
    [self loadAreasFuncionales];
}

#pragma mark - Data methods

- (void)loadAreasFuncionales {
    @try {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AreasFuncionales" ofType:@"plist"];
        self.areasFuncionales = [[NSArray alloc] initWithContentsOfFile:filePath];
        
        // Y se cargan las vacantes de la primera Área funcional
//        [self reloadVacantes];
    } @catch (NSException *exception) {
        [TSMessage showNotificationWithTitle:NSLocalizedString(@"Error", nil)
                                    subtitle:NSLocalizedString(@"Error al leer las áreas funcionales", nil)
                                        type:TSMessageNotificationTypeError];
    }
}

- (void)reloadVacantes {
    [self loadVacantes:0];
}

- (void)loadVacantes:(NSInteger)section {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.indiceSeccionAbriendo = section;
    NSString *urlFeed = [self.areasFuncionales objectAtIndex:section][1];
    
    feeds = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:urlFeed];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    if ([element isEqualToString:kITEM]) {
        item = [NSMutableDictionary dictionary];
        title = [NSMutableString new];
        link = [NSMutableString new];
        description = [NSMutableString new];
        pubDate = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:kTITLE]) {
        [title appendString:string];
    } else if ([element isEqualToString:kLINK]) {
        [link appendString:string];
    } else if ([element isEqualToString:kDESCRIPTION]) {
        [description appendString:string];
    } else if ([element isEqualToString:kPUBDATE]) {
        [pubDate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kITEM]) {
        [self obtainLocationFromTitle:title];
        [item setObject:link forKey:kLINK];
        [item setObject:description forKey:kDESCRIPTION];
        [item setObject:pubDate forKey:kPUBDATE];
        
        [feeds addObject:[item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self updateCellsOpenClose];
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.areasFuncionales count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // Altura de la cabecera
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Cabecera a partir de una celda, con información del Core
    HeaderTableViewCell *cellView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierDetailCellHeader];
    cellView.section = section;
    cellView.delegate = self;
    cellView.opened = (self.indiceSeccionAbierta == section);
    
    // Se pintan detalles de la cabecera
    NSArray *area = [self.areasFuncionales objectAtIndex:section];
    
    UILabel *nombreCore = (UILabel *)[cellView viewWithTag:301];
    nombreCore.text = [area objectAtIndex:0];
    
    return cellView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (feeds && section == self.indiceSeccionAbierta) {
        return [feeds count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierVacanteCell forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:90];
    titleLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:kTITLE];

    UILabel *pubDateLabel = (UILabel *)[cell viewWithTag:91];
    pubDateLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:kPUBDATE];

    UILabel *locationLabel = (UILabel *)[cell viewWithTag:92];
    locationLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:kLOCATION];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detalleVacante" sender:nil];
}

#pragma mark - SectionHeaderViewDelegate methods

- (void)sectionHeaderCell:(HeaderTableViewCell *)sectionHeaderCell sectionOpened:(NSInteger)section {
    NSLog(@"Abrir section %ld", (long)section);
    if (section != self.indiceSeccionAbierta) {
        [self loadVacantes:section];        
    }
}

- (void)updateCellsOpenClose {
    if (self.indiceSeccionAbriendo != NSNotFound) {
        // Creación de array con los indexPath de las filas a insertar
        NSMutableArray *indexPathsToInsert = [NSMutableArray array];
        for (NSInteger i = 0; i < [feeds count]; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:self.indiceSeccionAbriendo]];
        }
        
        // Creación de array con los indexPath de las filas a borrar
        NSMutableArray *indexPathsToDelete = [NSMutableArray array];
        NSInteger previousOpenSectionIndex = self.indiceSeccionAbierta;
        if (previousOpenSectionIndex != NSNotFound) {
            for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:previousOpenSectionIndex]; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
            }
        }
        
        // Animaciones hacia ambos arriba o abajo según se abra hacia un lado u otro
        UITableViewRowAnimation insertAnimation;
        UITableViewRowAnimation deleteAnimation;
        if (previousOpenSectionIndex == NSNotFound || self.indiceSeccionAbriendo < previousOpenSectionIndex) {
            insertAnimation = UITableViewRowAnimationTop;
            deleteAnimation = UITableViewRowAnimationBottom;
        } else {
            insertAnimation = UITableViewRowAnimationBottom;
            deleteAnimation = UITableViewRowAnimationTop;
        }
        self.indiceSeccionAbierta = self.indiceSeccionAbriendo;
        self.indiceSeccionAbriendo = NSNotFound;
        
        // Aplicamos los cambios
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
        [self.tableView endUpdates];
        
        // Se muestra la primera celda
        [self.tableView scrollToRowAtIndexPath:[indexPathsToInsert firstObject]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
}

- (void)sectionHeaderCell:(HeaderTableViewCell *)sectionHeaderCell sectionClosed:(NSInteger)section {
    NSLog(@"Cerrar section %ld", (long)section);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detalleVacante"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey:kLINK];
        [(MasInformacionController *)[segue destinationViewController] setUrlMasInfo:string];
    }
}

#pragma mark - Utils methods

- (void)obtainLocationFromTitle:(NSString *)input {
    NSScanner *scanner = [NSScanner scannerWithString:input];
    
    NSString *jobTitle;
    NSString *jobLocation;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"("] intoString:&jobTitle];
    [scanner scanString:@"(" intoString:NULL];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@")"] intoString:&jobLocation];
    
    [item setObject:jobTitle forKey:kTITLE];
    if (jobLocation) {
        [item setObject:jobLocation forKey:kLOCATION];
    } else {
        [item setObject:@"" forKey:kLOCATION];
    }
}

@end

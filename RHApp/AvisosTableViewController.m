//
//  LibretasViewController.m
//  Everpobre
//
//  Created by Luis Ángel García Muñoz on 25/4/16.
//  Copyright © 2016 Luis Ángel García Muñoz. All rights reserved.
//

#import "AvisosTableViewController.h"
#import "Notification.h"
#import "LASimpleCoreDataStack.h"

static NSString *const kIdentifierNotificationCell = @"NotificationCell";

@interface AvisosTableViewController ()

@property NSDateFormatter *formatoFecha;
@property (strong, nonatomic) LASimpleCoreDataStack *modelo;

@end

@implementation AvisosTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatoFecha = [[NSDateFormatter alloc] init];
    [self.formatoFecha setDateFormat:@"EEEE dd 'de' MMM, HH:mm"];

    // Se cargan las notificaciones
    [self loadNotifications];
}

- (void)loadNotifications {
    self.modelo = [LASimpleCoreDataStack coreDataStackWithModelName:@"Notifications"];
    
    // Se crea la búsqueda de todas las Notifications
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Notification entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:[NotificationAttributes receivedDate]
                                                          ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                        managedObjectContext:self.modelo.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

    // Si es la primera vez, se crea una de inicio
    if ([self.fetchedResultsController fetchedObjects].count == 0) {
        static NSString *firstContent = @"En este tablón recibirás noticias relevantes que consideramos de tu interés, así como ofertas de trabajo. Puedes borrarlas cuando desees.";
        [Notification notificationWithContent:firstContent context:self.fetchedResultsController.managedObjectContext];
        [self.modelo saveWithErrorBlock:nil];
    }
}

#pragma mark - Datasource

// Para eliminar Libretas
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Elegir la notificación a borrar
        Notification *objDel = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // Quitarla del modelo
        [self.fetchedResultsController.managedObjectContext deleteObject:objDel];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Averiguar cuál es el modelo, la notificación
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear una celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierNotificationCell];
    
    // Sincronizar notificación -> celda
    UILabel *fecha = (UILabel *)[cell viewWithTag:200];
    fecha.text = [NSString stringWithFormat:@"%@", [self.formatoFecha stringFromDate:notification.receivedDate]];
    
    UILabel *contenido = (UILabel *)[cell viewWithTag:201];
    contenido.text = notification.text;
    
    // Hacer transparentes las celdas
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];

    // Devolver la celda
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (notification.url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:notification.url]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

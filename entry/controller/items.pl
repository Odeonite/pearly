package Entry::Controller::Items;
use Mojo::Base 'Mojolicious::Controller';

sub list{
    my $self = shift;
    my Items = $self-> model('Items')->;
    $self->render(items => $Items);
}

sub add {
    my $self = shift;
#     my Items = $self-> model('Items')->;
#     $self->render(items => $Items);
    $self->model('Items')->create($self->param('name'));
    $self->redirect_to('list'); 
}

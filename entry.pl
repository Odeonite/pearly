# app.pl
use Mojolicious::Lite;
use Entry::Controller::Items;

# Connect to a sqlite database
helper sqlite => sub {
  state $sqlite = Mojo::SQLite->new('sqlite:app.db');
};

# Route handlers

my $r = app->routes;
$r->get('/items')->to('items#list'); 
$r->post('/items/add')->to('items#add');

app->start;

# Show all records
get '/' => sub {
  my $c = shift;
  my $rows = $c->sqlite->db->query('SELECT * FROM items')->hashref_array;
  $c->render(template => 'index', rows => $rows); 
};

# Show add record form
get '/add' => sub {
  my $c = shift;
  $c->render(template => 'add');
};

# Add a new record
post '/add' => sub {
  my $c = shift;
  my $name = $c->param('name');
  
  $c->sqlite->db->query('INSERT INTO items (name) VALUES (?)', $name);
  $c->redirect_to('index');
}; 

# Show edit record form  
get '/edit/:id' => sub {
  my $c = shift;
  my $row = $c->sqlite->db->query('SELECT * from items WHERE id=?', $c->param('id'))->hash;
  $c->render(template => 'edit', row => $row);
};

# Update a record
post '/edit/:id' => sub {
  my $c = shift;
  my $id = $c->param('id');
  my $name = $c->param('name');

  $c->sqlite->db->query('UPDATE items SET name=? WHERE id=?', $name, $id);
  $c->redirect_to('index');  
};

# Delete a record
get '/delete/:id' => sub {
  my $c = shift;
  my $id = $c->param('id');

  $c->sqlite->db->query('DELETE FROM items WHERE id=?', $id);
  $c->redirect_to('index');
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Items';

<h1>Items</h1>

<a href="/add">Add Item</a>

<table>
  % for my $row (@$rows) {
    <tr>
      <td><%= $row->{name} %></td>
      <td>
        <a href="/edit/<%= $row->{id} %>">Edit</a>
        <a href="/delete/<%= $row->{id} %>">Delete</a>  
      </td>
    </tr>
  % }
</table>

@@ add.html.ep
% layout 'default';
% title 'Add Item';

<h1>Add Item</h1>

<form action="/add" method="post">
  <input type="text" name="name">
  <button type="submit">Add</button>
</form>

@@ edit.html.ep
% layout 'default';
% title 'Edit Item';

<h1>Edit Item</h1>

<form action="/edit/<%= $row->{id} %>" method="post">
  <input type="text" name="name" value="<%= $row->{name} %>">
  <button type="submit">Save</button> 
</form>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
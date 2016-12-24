package Blog;
use Mojo::Base 'Mojolicious';

use Blog::Model::Posts;
use Blog::Model::Users;
use Blog::Model::OAuth2;
use Mojo::Pg;

sub startup {
  my $self = shift;

  # Configuration
  $self->plugin('Config');
  $self->secrets($self->config('secrets'));
  $self->plugin('ACME');
  $self->plugin("OAuth2Accounts" => {
    on_logout => '/',
    on_success => 'index',
    on_error => 'error',
    on_connect => sub { shift->_oauth2->store(@_) },
    providers => $self->config('oauth2'),
  });

  # Model
  $self->helper(pg => sub { state $pg = Mojo::Pg->new(shift->config('pg')) });
  $self->helper(
    posts => sub { state $posts = Blog::Model::Posts->new(pg => shift->pg) });
  $self->helper(
    users => sub { state $users = Blog::Model::Users->new(pg => shift->pg) });
  $self->helper(
    _oauth2 => sub { state $oauth2 = Blog::Model::OAuth2->new(pg => shift->pg) });

  # Migrate to latest version if necessary
  my $path = $self->home->rel_file('migrations/blog.sql');
  $self->pg->migrations->name('blog')->from_file($path)->migrate;

  # Controller
  my $r = $self->routes;

  $r->get('/' => sub { shift->redirect_to('posts') })->name('index');

  $r->get('/posts')->to('posts#index');
  $r->get('/posts/create')->to('posts#create')->name('create_post');
  $r->post('/posts')->to('posts#store')->name('store_post');
  $r->get('/posts/:id')->to('posts#show')->name('show_post');
  $r->get('/posts/:id/edit')->to('posts#edit')->name('edit_post');
  $r->put('/posts/:id')->to('posts#update')->name('update_post');
  $r->delete('/posts/:id')->to('posts#remove')->name('remove_post');

  $r->get('/users')->to('users#index');
  $r->get('/users/create')->to('users#create')->name('create_user');
  $r->post('/users')->to('users#store')->name('store_user');
  $r->get('/users/:id')->to('users#show')->name('show_user');
  $r->get('/users/:id/edit')->to('users#edit')->name('edit_user');
  $r->put('/users/:id')->to('users#update')->name('update_user');
  $r->delete('/users/:id')->to('users#remove')->name('remove_user');
}

1;

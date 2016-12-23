package Blog::Controller::Users;
use Mojo::Base 'Mojolicious::Controller';

sub create { shift->render(user => {}) }

sub edit {
  my $self = shift;
  $self->render(user => $self->users->find($self->param('id')));
}

sub index {
  my $self = shift;
  $self->render(users => $self->users->all);
}

sub remove {
  my $self = shift;
  $self->users->remove($self->param('id'));
  $self->redirect_to('users');
}

sub show {
  my $self = shift;
  $self->render(user => $self->users->find($self->param('id')));
}

sub store {
  my $self = shift;

  my $validation = $self->_validation;
  return $self->render(action => 'create', user => {})
    if $validation->has_error;

  my $id = $self->users->add($validation->output);
  $self->redirect_to('show_user', id => $id);
}

sub update {
  my $self = shift;

  my $validation = $self->_validation;
  return $self->render(action => 'edit', user => {}) if $validation->has_error;

  my $id = $self->param('id');
  $self->users->save($id, $validation->output);
  $self->redirect_to('show_user', id => $id);
}

sub _validation {
  my $self = shift;

  my $validation = $self->validation;
  $validation->required('email');
  $validation->required('name');

  return $validation;
}

1;

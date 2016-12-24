package Blog::Model::Users;
use Mojo::Base -base;

has 'pg';

sub add {
  my ($self, $user) = @_;
  my $sql = 'insert into users (email, name) values (?, ?) returning id';
  return $self->pg->db->query($sql, $user->{email}, $user->{name})->hash->{id};
}

sub all { shift->pg->db->query('select * from users')->hashes->to_array }

sub find {
  my ($self, $id) = @_;
  return $self->pg->db->query('select * from users where id = ?', $id)->hash;
}

sub remove { shift->pg->db->query('delete from users where id = ?', shift) }

sub save {
  my ($self, $id, $user) = @_;
  my $sql = 'update users set email = ?, name = ? where id = ?';
  $self->pg->db->query($sql, $user->{email}, $user->{name}, $id);
}

1;

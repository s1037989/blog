package Blog::Model::OAuth2;
use Mojo::Base -base;

use UUID::Tiny ':std';

has 'pg';

sub store {
  my $self = shift;
  if ( $#_ == 1 ) {
    my ($id, $provider) = @_;
    #warn '#1';
    my $r = $self->pg->db->query('select id from providers where id = ? and provider = ?', $id, $provider)->hash;
    return ref $r ? $r->{id} : undef;
  } elsif ( $#_ == 0 ) {
    my ($provider_id) = @_;
    #warn '#2';
    my $r = $self->pg->db->query('select id from providers where provider_id = ?', $provider_id)->hash;
    return ref $r ? $r->{id} : uuid_to_string(create_uuid(UUID_V4));
  } elsif ( $#_ > 1 ) {
    #warn '#3';
    my ($id, $provider, $json, $mapped) = @_;
    unless ( $self->pg->db->query('select id from users where id = ?', $id)->rows ) {
      #warn '#3.1';
      $self->pg->db->query('insert into users (id, email, name) values (?, ?, ?)', $id, $mapped->{email}, $mapped->{name});
    }
    unless ( $self->pg->db->query('select id from providers where provider_id = ?', $mapped->{id})->rows ) {
      #warn '#3.2';
      $self->pg->db->query('insert into providers (id, provider_id, provider) values (?, ?, ?)', $id, $mapped->{id}, $provider);
    }
  }
}

1;

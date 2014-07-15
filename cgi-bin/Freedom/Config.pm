package Freedom::Config;

sub new {
  my $proto = $_[0];
  my $class = ref($proto) || $proto;
  my $self = {config_file=>$_[1]};
  bless ($self, $class);
  return $self;
}

sub read {
  my $self = shift;
  my %config_hash;
  open (CONFIG, $self->{'config_file'});
  while (<CONFIG>) {
    chomp $_;
    my ($var, $var_value) = split(/=/, $_);
    $config_hash{$var} = $var_value;
  }
  close(CONFIG);
  return %config_hash;
}

sub one {
  my $self = shift;
  open (CONFIG, $self->{'config_file'});
  while (<CONFIG>) {
    chomp $_;
    my ($var, $var_value) = split(/=/, $_);
    if ($var eq $_[0]) {
      return $var_value;
    }
  }
}

1;
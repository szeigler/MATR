package Freedom::Validate;

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless ($self, $class);
  return $self;
}

sub blanks {
  my $self = shift;
  my $required_fields = $_[0];
  my $cgi_object = $_[1];
  my @required_fields = split(/ /, $required_fields);
  my $valid_data = 1;
  my $blanks;
  foreach my $field (@required_fields) {
    if ($cgi_object->param($field) eq '') {
      $blanks .= $field . '<br>';
      $valid_data = 0;
    }
  }
  $self->{'blanks'} = $blanks;
  return $valid_data;
}

sub email_address {
  my $self = shift;
  my $email = $_[0];
  my $valid_data = 1;
  if ($email =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)/ || $email !~ /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/) {
    $valid_data = 0;
  }
  return $valid_data;
}

sub credit_card_number {
  my $self = shift;
{
 # poorly scoped code someone else wrote - so I'll just turn -w and use strict; off for a minute:

  no strict;
  local $^W=0;
  
  $Credit_Card_Type = $_[0];
  $cardnumber = $_[1];
$badcardnumber = "false";

# Remove any spaces or dashes in card number
$cardnumber =~ s/ //g;
$cardnumber =~ s/-//g;
$length = length($cardnumber);

# Make sure that only numbers exist
if (!($cardnumber =~ /^[0-9]*$/)) {
 $badcardnumber = "true";
 }

# Verify correct length for each card type
if ($in{'Credit_Card_Type'} eq "Visa") { &vlen; }
if ($in{'Credit_Card_Type'} eq "Master_Card") { &mclen; }
if ($in{'Credit_Card_Type'} eq "American_Express") { &alen; }
if ($in{'Credit_Card_Type'} eq "Discovery") { &nlen; }

sub vlen {
    $badcardnumber = "true" unless (($length ==13) || ($length == 16));
}
sub mclen {
    $badcardnumber = "true" unless ($length == 16);    
}
sub alen {
    $badcardnumber = "true" unless ($length == 15);    
}
sub nlen {
    $badcardnumber = "true" unless ($length == 16);    
}

# Now Verify via Mod 10 for each one
if ($in{'Credit_Card_Type'} eq "Visa") { &vver; }
if ($in{'Credit_Card_Type'} eq "Master_Card") { &ver16; }
if ($in{'Credit_Card_Type'} eq "American_Express") { &ver15; }
if ($in{'Credit_Card_Type'} eq "Discovery") { &ver16; }

# pick one for Visa
sub vver {
	if ($length == 13) { &ver13; }
	if ($length == 16) { &ver16; }
}

# For 13 digit cards
sub ver13 {
        $cc0 = substr($cardnumber,0,1);
        $cc1 = substr($cardnumber,1,1);
        $cc2 = substr($cardnumber,2,1);
        $cc3 = substr($cardnumber,3,1);
        $cc4 = substr($cardnumber,4,1);
        $cc5 = substr($cardnumber,5,1);
        $cc6 = substr($cardnumber,6,1);
        $cc7 = substr($cardnumber,7,1);
        $cc8 = substr($cardnumber,8,1);
        $cc9 = substr($cardnumber,9,1);
        $cc10 = substr($cardnumber,10,1);
        $cc11 = substr($cardnumber,11,1);
        $cc12 = substr($cardnumber,12,1);

        $cc1a = $cc1 * 2;
        $cc3a = $cc3 * 2;
        $cc5a = $cc5 * 2;
        $cc7a = $cc7 * 2;
        $cc9a = $cc9 * 2;
        $cc11a = $cc11 * 2;

        if ($cc1a >= 10) {
            $cc1b = substr($cc1a,0,1);
            $cc1c = substr($cc1a,1,1);
            $cc1 = $cc1b+$cc1c;
        } else {
            $cc1 = $cc1a;
        }
        if ($cc3a >= 10) {
            $cc3b = substr($cc3a,0,1);
            $cc3c = substr($cc3a,1,1);
            $cc3 = $cc3b+$cc3c;
        } else {
            $cc3 = $cc3a;
        }
        if ($cc5a >= 10) {
            $cc5b = substr($cc5a,0,1);
            $cc5c = substr($cc5a,1,1);
            $cc5 = $cc5b+$cc5c;
        } else {
            $cc5 = $cc5a;
        }
        if ($cc7a >= 10) {
            $cc7b = substr($cc7a,0,1);
            $cc7c = substr($cc7a,1,1);
            $cc7 = $cc7b+$cc7c;
        } else {
            $cc7 = $cc7a;
        }
        if ($cc9a >= 10) {
            $cc9b = substr($cc9a,0,1);
            $cc9c = substr($cc9a,1,1);
            $cc9 = $cc9b+$cc9c;
        } else {
            $cc9 = $cc9a;
        }
        if ($cc11a >= 10) {
            $cc11b = substr($cc11a,0,1);
            $cc11c = substr($cc11a,1,1);
            $cc11 = $cc11b+$cc11c;
        } else {
            $cc11 = $cc11a;
        }

        $val = $cc0+$cc1+$cc2+$cc3+$cc4+$cc5+$cc6+$cc7+$cc8+$cc9+$cc10+$cc11+$cc12;
        if (substr($val,1,1) !=0 ) {
             $badcardnumber = "true";
        }
	}

# For 16 digit cards
sub ver16 {
        $cc0 = substr($cardnumber,0,1);
        $cc1 = substr($cardnumber,1,1);
        $cc2 = substr($cardnumber,2,1);
        $cc3 = substr($cardnumber,3,1);
        $cc4 = substr($cardnumber,4,1);
        $cc5 = substr($cardnumber,5,1);
        $cc6 = substr($cardnumber,6,1);
        $cc7 = substr($cardnumber,7,1);
        $cc8 = substr($cardnumber,8,1);
        $cc9 = substr($cardnumber,9,1);
        $cc10 = substr($cardnumber,10,1);
        $cc11 = substr($cardnumber,11,1);
        $cc12 = substr($cardnumber,12,1);
        $cc13 = substr($cardnumber,13,1);
        $cc14 = substr($cardnumber,14,1);
        $cc15 = substr($cardnumber,15,1);

        $cc0a = $cc0 * 2;
        $cc2a = $cc2 * 2;
        $cc4a = $cc4 * 2;
        $cc6a = $cc6 * 2;
        $cc8a = $cc8 * 2;
        $cc10a = $cc10 * 2;
        $cc12a = $cc12 * 2;
        $cc14a = $cc14 * 2;

        if ($cc0a >= 10) {
            $cc0b = substr($cc0a,0,1);
            $cc0c = substr($cc0a,1,1);
            $cc0 = $cc0b+$cc0c;
        } else {
            $cc0 = $cc0a;
        }
        if ($cc2a >= 10) {
            $cc2b = substr($cc2a,0,1);
            $cc2c = substr($cc2a,1,1);
            $cc2 = $cc2b+$cc2c;
        } else {
            $cc2 = $cc2a;
        }
        if ($cc4a >= 10) {
            $cc4b = substr($cc4a,0,1);
            $cc4c = substr($cc4a,1,1);
            $cc4 = $cc4b+$cc4c;
        } else {
            $cc4 = $cc4a;
        }
        if ($cc6a >= 10) {
            $cc6b = substr($cc6a,0,1);
            $cc6c = substr($cc6a,1,1);
            $cc6 = $cc6b+$cc6c;
        } else {
            $cc6 = $cc6a;
        }
        if ($cc8a >= 10) {
            $cc8b = substr($cc8a,0,1);
            $cc8c = substr($cc8a,1,1);
            $cc8 = $cc8b+$cc8c;
        } else {
            $cc8 = $cc8a;
        }
        if ($cc10a >= 10) {
            $cc10b = substr($cc10a,0,1);
            $cc10c = substr($cc10a,1,1);
            $cc10 = $cc10b+$cc10c;
        } else {
            $cc10 = $cc10a;
        }
        if ($cc12a >= 10) {
            $cc12b = substr($cc12a,0,1);
            $cc12c = substr($cc12a,1,1);
            $cc12 = $cc12b+$cc12c;
        } else {
            $cc12 = $cc12a;
        }
        if ($cc14a >= 10) {
            $cc14b = substr($cc14a,0,1);
            $cc14c = substr($cc14a,1,1);
            $cc14 = $cc14b+$cc14c;
        } else {
            $cc14 = $cc14a;
        }

        $val = $cc0+$cc1+$cc2+$cc3+$cc4+$cc5+$cc6+$cc7+$cc8+$cc9+$cc10+$cc11+$cc12+$cc13+$cc14+$cc15;
        if (substr($val,1,1) !=0 ) {
             $badcardnumber = "true";
        }
    }


# For 15 digit (American_Express) cards
sub ver15 {
        $cc0 = substr($cardnumber,0,1);
        $cc1 = substr($cardnumber,1,1);
        $cc2 = substr($cardnumber,2,1);
        $cc3 = substr($cardnumber,3,1);
        $cc4 = substr($cardnumber,4,1);
        $cc5 = substr($cardnumber,5,1);
        $cc6 = substr($cardnumber,6,1);
        $cc7 = substr($cardnumber,7,1);
        $cc8 = substr($cardnumber,8,1);
        $cc9 = substr($cardnumber,9,1);
        $cc10 = substr($cardnumber,10,1);
        $cc11 = substr($cardnumber,11,1);
        $cc12 = substr($cardnumber,12,1);
        $cc13 = substr($cardnumber,13,1);
        $cc14 = substr($cardnumber,14,1);

        $cc1a = $cc1 * 2;
        $cc3a = $cc3 * 2;
        $cc5a = $cc5 * 2;
        $cc7a = $cc7 * 2;
        $cc9a = $cc9 * 2;
        $cc11a = $cc11 * 2;
        $cc13a = $cc13 * 2;

        if ($cc1a >= 10) {
            $cc1b = substr($cc1a,0,1);
            $cc1c = substr($cc1a,1,1);
            $cc1 = $cc1b+$cc1c;
        } else {
            $cc1 = $cc1a;
        }
        if ($cc3a >= 10) {
            $cc3b = substr($cc3a,0,1);
            $cc3c = substr($cc3a,1,1);
            $cc3 = $cc3b+$cc3c;
        } else {
            $cc3 = $cc3a;
        }
        if ($cc5a >= 10) {
            $cc5b = substr($cc5a,0,1);
            $cc5c = substr($cc5a,1,1);
            $cc5 = $cc5b+$cc5c;
        } else {
            $cc5 = $cc5a;
        }
        if ($cc7a >= 10) {
            $cc7b = substr($cc7a,0,1);
            $cc7c = substr($cc7a,1,1);
            $cc7 = $cc7b+$cc7c;
        } else {
            $cc7 = $cc7a;
        }
        if ($cc9a >= 10) {
            $cc9b = substr($cc9a,0,1);
            $cc9c = substr($cc9a,1,1);
            $cc9 = $cc9b+$cc9c;
        } else {
            $cc9 = $cc9a;
        }
        if ($cc11a >= 10) {
            $cc11b = substr($cc11a,0,1);
            $cc11c = substr($cc11a,1,1);
            $cc11 = $cc11b+$cc11c;
        } else {
            $cc11 = $cc11a;
        }
        if ($cc13a >= 10) {
            $cc13b = substr($cc13a,0,1);
            $cc13c = substr($cc13a,1,1);
            $cc13 = $cc13b+$cc13c;
        } else {
            $cc13 = $cc13a;
        }

        $val = $cc0+$cc1+$cc2+$cc3+$cc4+$cc5+$cc6+$cc7+$cc8+$cc9+$cc10+$cc11+$cc12+$cc13+$cc14;
        if (substr($val,1,1) !=0 ) {
             $badcardnumber = "true";
        }
    }

if ($badcardnumber eq 'true') {
  return 0;
  $self->log_error('Invalid Credit Card Number');
} else {
  return 1;
}

} # this is the end of the turn off -w and strict scope

}

sub order_form {
  my $self = shift;
  my $boolean = 1;
  my $q = $_[0];
  if ($q->param('billing_first_name') eq '' ||
      $q->param('billing_last_name') eq '' ||
      $q->param('billing_email_address') eq '' ||
      $q->param('billing_home_phone_number') eq '' ||
      $q->param('billing_work_phone_number') eq '' ||
      $q->param('billing_address_1') eq '' ||
      $q->param('billing_city') eq '' ||
      $q->param('billing_state') eq '' ||
      $q->param('billing_zip_code') eq '' ||
      $q->param('billing_contact_method') eq '')
  {
    $boolean = 0;
    $self->log_error('Billing Information Not Completed.  Please fill in all ' . 
    'fields under the Billing Info section');
  }
  return $boolean;  
}

sub user_info {
  my $self = shift;
  my $boolean = 1;
  my $q = $_[0];
  if(length($q->param('username')) > 16 ||
     length($q->param('username')) < 4 ||
     length($q->param('password')) > 16 ||
     length($q->param('password')) < 4) {
    $boolean = 0;
    $self->log_error('Username and/or Password invalid length.' . 
                     'Your username and password must be greater than ' . 
                     'four characters and less than 16 characters.');
  }
  if($q->param('username') eq '' ||
     $q->param('password') eq '' ||
     $q->param('address_1') eq '' ||
     $q->param('city') eq '' ||
     $q->param('state') eq '' ||
     $q->param('zip_code') eq '' ||
     $q->param('home_phone_number') eq '' ||
     $q->param('first_name') eq '' ||
     $q->param('last_name') eq '' ||
     $q->param('contact_method') eq '') {
    $boolean = 0;
    $self->log_error('User Info Not Completed.  Please fill in all fields in user info section');
  }
  return $boolean;
}

sub log_error {
  my $self = shift;
  my $error = $_[0];
  my $existing_errors = $self->read_errors;
  $self->{'errors'} = $existing_errors . '<br>' . $error;
}

sub read_errors {
  my $self = shift;
  return $self->{'errors'};
}

1;

package Freedom::Emailer;

#use Net::SMTP;
use Freedom::Config;

sub new {
  #my $proto = shift;
  #my $class = ref($proto) || $proto;
  my $config_path = $_[1];
  my $config = Freedom::Config->new($config_path);
  my $self  = {sendmail_path=>$config->one('sendmail_path')};
  #bless ($self, $class);
  return bless $self;
}

sub send {

my $self = shift;

# read all needed variables from input passed to this object method as an anonymous hash

my %input_hash = @_;

my $sender_email = $input_hash{'from_email'};
my $sender_name = $input_hash{'from_name'};
my $email_address = $input_hash{'to_email'};
my $email_name = $input_hash{'to_name'};
my $email_subject = $input_hash{'subject'};
my $email_body = $input_hash{'message'};
my $use_sockets = $input_hash{'use_sockets'};
my $email_server = $input_hash{'email_server'};

# format the date in the first format, not the localtime format (second)

# Sat, 21 Jul 2001 16:31:34 -0700 (PDT)
# Sat Jul 21 16:33:10 2001

# Define arrays for the day of the week and month of the year.           #
my @days   = ('Sun','Mon','Tue','Wed',
               'Thu','Fri','Sat');
my @months = ('Jan','Feb','Mar','Apr','May','Jun','Jul',
	         'Aug','Sep','Oct','Nov','Dec');

# Get the current time and format the hour, minutes and seconds.  Add    #
# 1900 to the year to get the full 4 digit year.                         #
my ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
my $time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$year += 1900;

# format for the -0700 thingy

my $over_10;
my $first;
my $second;
my $minus_24 = $hour - 24;
$minus_24++;
my $tester = $minus_24;
$tester =~ s/-|0//g;
if ($tester > 9) {
  $over_10 = 1;
}

# if the number is over 10, I have to parse it differently

if ($over_10) {

  my $useless;
  my $remainder;
  $minus_24 .= "00";
  if ($minus_24 =~ /-/) {
    ($useless, $remainder) = split (/-/, $minus_24);
    # remainder is now "700" or the like
    my $next_minus_24 = "-" . $remainder;
    $minus_24 = $next_minus_24;
  }
#  print $minus_24;
} else {
  # then it's under 10
  my $useless;
  my $remainder;
  $minus_24 .= "00";
  if ($minus_24 =~ /-/) {
    ($useless, $remainder) = split (/-/, $minus_24);
    # remainder is now "700" or the like
    my $next_minus_24 = "-0" . $remainder;
    $minus_24 = $next_minus_24;
  } else {
    # then it's a positive number under 10
    my $next_minus_24 = "0" . $remainder;
    $minus_24 = $next_minus_24;
  }
}


# Format the date.                                                       #
my $date = "$days[$wday], $mday $months[$mon] $year $time $minus_24 (PDT)";

my $message = <<EOF;
Date: $date
From: $sender_email ($sender_name)
Subject: $email_subject
To: $email_address ($email_name)
X-Mailer: David's Perl Email Client
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit

$email_body
EOF

  
  #if ($use_sockets) {
    # do the non-sendmail (sockets/smtp) way of sending email: 
    # more security - use if possible!
  #  my $smtp = Net::SMTP->new($email_server, Debug=>1);
  #  $smtp->mail($email_address);
  #  $smtp->to($email_address);
  #  $smtp->data();
  #  $smtp->datasend($message);
  #  $smtp->dataend();
  #  $smtp->quit;
  #} else {
    # if this were unix or we installed sendmail on Win*, we could use this code: 
    # some crappy web hosting services don't let you specify 'oi' to sendmail...
    # open (PIPE_TO_SENDMAIL, "| $sendmail_path -t oi") || die ("could not open pipe to sendmail at $sendmail_path because $!");
    #use CGI qw(:standard);
    #print header, $self->{'sendmail_path'};
    #exit;
    open (PIPE_TO_SENDMAIL, "| $self->{'sendmail_path'} $email_address") || die ("could not open pipe to sendmail at $sendmail_path because $!");
    print PIPE_TO_SENDMAIL $message;
    close(PIPE_TO_SENDMAIL);
    #use CGI qw(:standard);
    #print header, $message;
    #exit;
  #}
}

1;

#!/usr/bin/perl -w

# Copyright David Nelson & Expert Web Installs
# Free software, licensed under the GPL ( http://www.gnu.org/licenses/gpl.txt )
# Visit http://www.expertwebinstalls.com/r/easy_tell_a_friend.html for installation help

use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);
my $sf = $ENV{'SCRIPT_FILENAME'};
my $r_sf = reverse $sf;
my ($script_name, @wanted_path_reverse) = split(/\//, $r_sf);
my $wanted_path_reverse = join('/', @wanted_path_reverse);
my $wanted_path = reverse $wanted_path_reverse;
$wanted_path = '/' . $wanted_path;
unless ($wanted_path =~ /:/) # windows machines
{
  $wanted_path = '/' . $wanted_path;
}
use lib qw($wanted_path);
my $config_path = $wanted_path . '/config.txt';
use Freedom::Emailer;
use Freedom::Config;
use Freedom::Validate;
use Freedom::Display;
my $config = Freedom::Config->new($config_path);
my $emailer = Freedom::Emailer->new($config_path);
my $validate = Freedom::Validate->new($config_path);
my $display = Freedom::Display->new($config_path);
my $url = url;
my $mode = param('mode');
if($mode eq 'bad_email')
{
  my $stored_referrer = param('stored_referrer');
  print $display->top('Either you or your friend\'s email was invalid.  Please try again.'), 
  start_form(-action=>$url, 
             -method=>'post'), 
  hidden(-name=>'mode', 
         -value=>'send_email', 
         -override=>1), 
  table(
    Tr( [
      td( [ b('Your Name'), textfield('your_name') ] ), 
      td( [ b('Your Email'), textfield('your_email') ] ), 
      td( [ b('Friend\'s Name'), textfield('friends_name') ] ), 
      td( [ b('Friend\'s Email'), textfield('friends_email') ] ), 
      td( [ b('A Quick Note'), textfield('specific_comments') ] ), 
      td( {-colspan=>2}, [ submit('Send Email') ] )
    ] )
  ), 
  hidden(-name=>'referrer_url', 
         -value=>$stored_referrer), 
  end_form, 
  $display->bottom;
}
elsif($mode eq 'send_email')
{
  my $referrer;
  my $to_name = param('friends_name');
  my $to_email = param('friends_email');
  my $from_name = param('your_name');
  my $from_email = param('your_email');
  my $specific_comments = param('specific_comments') || '';
  if(param('referrer_url') ne '')
  {
    $referrer = param('referrer_url');
  }
  else
  {
    $referrer = $ENV{'HTTP_REFERER'};
  }
  unless($validate->email_address(param('your_email')) &&
    $validate->email_address(param('friends_email')))
  {
    print redirect("$url?mode=bad_email&stored_referrer=$referrer&friends_name=$to_name&" . 
      "friends_email=$to_email&your_name=$from_name&your_email=$from_email&" . 
      "specific_comments=$specific_comments");
    exit;
  }
  my $comments_to_send;
  if($specific_comments ne '')
  {
    $comments_to_send .= "\n$from_name specifically wanted to mention:\n\n$specific_comments\n";
  }
  my $message_subject = $from_name . ' recommends you visit expertwebinstalls.com';
  my $message;
  open(F, "$wanted_path/tell_a_friend_message.txt") || die("could not open message file at $wanted_path/message.txt because: $!");
  while(<F>)
  {
    $message .= $_;
  }
  $message =~ s/%%to_name%%/$to_name/sg;
  $message =~ s/%%from_name%%/$from_name/sg;
  $message =~ s/%%comments_to_send%%/$comments_to_send/sg;
  $emailer->send(to_name=>$to_name, 
                 to_email=>$to_email, 
                 from_name=>$from_name, 
                 from_email=>$from_email, 
                 subject=>$message_subject, 
                 message=>$message); 
  
  print $display->full('Email sent successfully to ' . $to_name, 
    a({-href=>$referrer}, 'Click here to return to the page you came from.'));
}
else
{
  print $display->full('Bad Mode Specified.  Exiting');
}

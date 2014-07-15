package Freedom::Display;
use Freedom::Config;
use CGI qw(:standard);


sub new {

  #print header;
  #print <<STUFF;
#config_path: $_[1];
#shopcms: $_[2]
#STUFF
  #my $config = Freedom::Config->new($_[1]);
  #%config_hash = $config->read;
  #my $shopcms = 0;
  #if($_[2] eq 'shopcms')
  #{
  #  $shopcms = 1;
  #}
  my $self  = {
               config_file => $_[1], 
               template_top_location => $config_hash{'template_top_location'}, 
               template_bottom_location => $config_hash{'template_bottom_location'}, 
               admin_template_top_location => $config_hash{'admin_template_top_location'}, 
               admin_template_bottom_location => $config_hash{'admin_template_bottom_location'}, 
               style_sheet_location => $config_hash{'style_sheet_location'}, 
               #cookies_object => Freedom::Cookies->new($_[1]), 
               shopcms => $shopcms, 
               config_object => $config
               };
  return bless $self;
}

sub top {
  my $self = shift;
  my $template_top;
  my $style_sheet;
  open (FILE, $self->{'template_top_location'});
  while (<FILE>) {
    $template_top .= $_;
  }
  close (FILE);
  open (FILE, $self->{'style_sheet_location'});
  while (<FILE>) {
    $style_sheet .= $_;
  }
  close (FILE);
  
    return header, $template_top, h2($_[0]);

}

sub bottom {
  my $self = shift;
  my $template_bottom;
  open (FILE, $self->{'template_bottom_location'});
  while (<FILE>) {
    $template_bottom .= $_;
  }
  close (FILE);
  return $template_bottom;
}

sub full {
  my $self = shift;
  return $self->top($_[0], $_[2], '', $_[3]), 
  p($_[1]), 
  $self->bottom;
}

sub admin_top {
  my $self = shift;
  my $style_sheet;
  close (FILE);
  open (FILE, $self->{'style_sheet_location'});
  while (<FILE>) {
    $style_sheet .= $_;
  }
  close (FILE);
  # remove the top of the page if included accidentally in template
  $template_top =~ s/<html>(.*)<\/head>//gs;
  my $admin_template_top;
  open (FILE, $self->{'admin_template_top_location'}) || die('could not open admin top template at: ' . $self->{'admin_template_top_location'} . ' because perl said: ' . $!);
  while (<FILE>) {
    $admin_template_top .= $_;
  }
  close (FILE);
  $admin_template_top .= "<html><head><title>$_[0]</title></head><body bgcolor=\"#ffffff\">" . 
  h1($_[0]);
  return header, 
  $admin_template_top;
}

sub admin_bottom {
  my $self = shift;
  my $admin_template_bottom;
  open (FILE, $self->{'admin_template_bottom_location'}) || die('could not open admin bottom template at: ' . $self->{'admin_template_bottom_location'} . ' because perl said: ' . $!);
  while (<FILE>) {
    $admin_template_bottom .= $_;
  }
  close (FILE);
  return $admin_template_bottom;
}

sub admin_full {
  my $self = shift;
  return $self->admin_top($_[0], $_[2]), 
  p($_[1]), 
  $self->admin_bottom;
}


sub members_top {
  my $self = shift;
  my $style_sheet;
  close (FILE);
  open (FILE, $style_sheet_location);
  while (<FILE>) {
    $style_sheet .= $_;
  }
  close (FILE);
  # remove the top of the page if included accidentally in template
  $template_top =~ s/<html>(.*)<\/head>//gs;
  my $members_template_top;
  open (FILE, $config->one('members_template_top_location'));
  while (<FILE>) {
    $members_template_top .= $_;
  }
  close (FILE);
  $members_template_top .= "<html><head><title>$_[0]</title><style>$style_sheet</style></head><body bgcolor=\"#ffffff\">" . 
  h1($_[0]);
  return header, 
  $members_template_top;
}

sub members_bottom {
  my $self = shift;
  my $members_template_bottom;
  open (FILE, $config->one('members_template_bottom_location'));
  while (<FILE>) {
    $members_template_bottom .= $_;
  }
  close (FILE);
  return $members_template_bottom;
}

sub members_full {
  my $self = shift;
  return $self->members_top($_[0], $_[2]), 
  p($_[1]), 
  $self->members_bottom;
}


sub credit_card_expiration_month_list {
  my $self = shift;
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my $months_aref = \@months;
  my %labels;
  foreach my $month (@months) {
    $labels{$month} = $month;
  }  
  return popup_menu(-name=>'credit_card_expiration_month',
                    -values=>$months_aref,
                    -default=>'01',
                    -labels=>\%labels);
}

sub credit_card_expiration_year_list {
  my $self = shift;
  my @years = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my $years_aref = \@years;
  my %labels;
  foreach my $year (@years) {
    $labels{$year} = $year;
  }  
  return popup_menu(-name=>'credit_card_expiration_year',
                    -values=>$years_aref,
                    -default=>'01',
                    -labels=>\%labels);
}

sub states_list {
  my $self = shift;
  my $states_text;
  if ($_[0] eq 'billing') {
    $states_text = '<select name="billing_state">';
  } else {
     $states_text = '<select name="state">';
  }
  $states_text .= <<STATES_TEXT;
                      <option selected>Choose from list... </option>
                      <option value="AK">Alaska </option>
                      <option value="AL">Alabama </option>
                      <option value="AR">Arkansas </option>
                      <option value="AZ">Arizona </option>
                      <option value="CA">California </option>
                      <option value="CO">Colorado </option>
                      <option value="CT">Connecticut </option>
                      <option value="DC">District of Columbia </option>
                      <option value="DE">Delaware </option>
                      <option value="FL">Florida </option>
                      <option value="GA">Georgia </option>
                      <option value="HI">Hawaii </option>
                      <option value="IA">Iowa </option>
                      <option value="ID">Idaho </option>
                      <option value="IL">Illinois </option>
                      <option value="IN">Indiana </option>
                      <option value="KS">Kansas </option>
                      <option value="KY">Kentucky </option>
                      <option value="LA">Louisiana </option>
                      <option value="MA">Massachusetts </option>
                      <option value="MD">Maryland </option>
                      <option value="ME">Maine </option>
                      <option value="MI">Michigan </option>
                      <option value="MN">Minnesota </option>
                      <option value="MO">Missouri </option>
                      <option value="MS">Mississippi </option>
                      <option value="MT">Montana </option>
                      <option value="NC">North Carolina </option>
                      <option value="ND">North Dakota </option>
                      <option value="NE">Nebraska </option>
                      <option value="NH">New Hampshire </option>
                      <option value="NJ">New Jersey </option>
                      <option value="NM">New Mexico </option>
                      <option value="NV">Nevada </option>
                      <option value="NY">New York </option>
                      <option value="OH">Ohio </option>
                      <option value="OK">Oklahoma </option>
                      <option value="OR">Oregon </option>
                      <option value="PA">Pennsylvania </option>
                      <option value="RI">Rhode Island </option>
                      <option value="SC">South Carolina </option>
                      <option value="SD">South Dakota </option>
                      <option value="TN">Tennessee </option>
                      <option value="TX">Texas </option>
                      <option value="UT">Utah </option>
                      <option value="VA">Virginia </option>
                      <option value="VT">Vermont </option>
                      <option value="WA">Washington </option>
                      <option value="WI">Wisconsin </option>
                      <option value="WV">West Virginia </option>
                      <option value="WY">Wyoming </option>
                      <option>------------------- </option>
                      <option>&nbsp;Canadian Provinces </option>
                      <option>------------------- </option>
                      <option value="AB">Alberta </option>
                      <option value="BC">British Columbia </option>
                      <option value="NF">Labrador </option>
                      <option value="MB">Manitoba </option>
                      <option value="NB">New Brunswick </option>
                      <option value="NF">Newfoundland </option>
                      <option value="NT">North West Territories </option>
                      <option value="NS">Nova Scotia </option>
                      <option value="ON">Ontario </option>
                      <option value="PE">Prince Edward Island </option>
                      <option value="QC">Quebec </option>
                      <option value="SK">Saskatchewan </option>
                      <option value="YT">Yukon Territories </option>
                    </select>
STATES_TEXT
  return $states_text;
}

sub countries_list {
  my $self = shift;
  my $countries_text;
  if ($_[0] eq 'billing') {
    $countries_text = '<select name="billing_country">';
  } else {
     $countries_text = '<select name="country">';
  }
  $countries_text .= <<COUNTRIES_TEXT;
                      <option value="AL">Albania </option>
                      <option value="DZ">Algeria </option>
                      <option value="AS">American Samoa </option>
                      <option value="AD">Andorra </option>
                      <option value="AI">Anguilla </option>
                      <option value="AG">Antigua &amp; Barbuda </option>
                      <option value="AR">Argentina </option>
                      <option value="AW">Aruba </option>
                      <option value="AU">Australia </option>
                      <option value="AT">Austria </option>
                      <option value="AP">Azores </option>
                      <option value="BS">Bahamas </option>
                      <option value="BH">Bahrain </option>
                      <option value="BD">Bangladesh </option>
                      <option value="BB">Barbados </option>
                      <option value="BE">Belgium </option>
                      <option value="BZ">Belize </option>
                      <option value="BY">Belarus </option>
                      <option value="BJ">Benin </option>
                      <option value="BM">Bermuda </option>
                      <option value="BO">Bolivia </option>
                      <option value="BL">Bonaire </option>
                      <option value="BA">Bosnia </option>
                      <option value="BW">Botswana </option>
                      <option value="BR">Brazil </option>
                      <option value="VG">British Virgin Islands </option>
                      <option value="BN">Brunei </option>
                      <option value="BG">Bulgaria </option>
                      <option value="BF">Burkina Faso </option>
                      <option value="BI">Burundi </option>
                      <option value="KH">Cambodia </option>
                      <option value="CM">Cameroon </option>
                      <option value="CA">Canada * </option>
                      <option value="IC">Canary Islands </option>
                      <option value="CV">Cape Verde Islands </option>
                      <option value="KY">Cayman Islands </option>
                      <option value="CF">Central African Republic </option>
                      <option value="TD">Chad </option>
                      <option value="CD">Channel Islands </option>
                      <option value="CL">Chile </option>
                      <option value="CN">China, Peoples Republic of </option>
                      <option value="CO">Colombia </option>
                      <option value="CG">Congo </option>
                      <option value="CK">Cook Islands </option>
                      <option value="CR">Costa Rica </option>
                      <option value="HR">Croatia </option>
                      <option value="CB">Curacao </option>
                      <option value="CY">Cyprus </option>
                      <option value="CZ">Czech Republic </option>
                      <option value="DK">Denmark </option>
                      <option value="DJ">Djibouti </option>
                      <option value="DM">Dominica </option>
                      <option value="DO">Dominican Republic </option>
                      <option value="EC">Ecuador </option>
                      <option value="EG">Egypt </option>
                      <option value="SV">El Salvador </option>
                      <option value="EN">England </option>
                      <option value="GQ">Equitorial Guinea </option>
                      <option value="ER">Eritrea </option>
                      <option value="EE">Estonia </option>
                      <option value="ET">Ethiopia </option>
                      <option value="FO">Faeroe Islands </option>
                      <option value="FM">Federated Micronesia </option>
                      <option value="FJ">Fiji </option>
                      <option value="FI">Finland </option>
                      <option value="FR">France </option>
                      <option value="GF">French Guiana </option>
                      <option value="PF">French Polynesia </option>
                      <option value="GA">Gabon </option>
                      <option value="GM">Gambia </option>
                      <option value="GE">Georgia </option>
                      <option value="DE">Germany </option>
                      <option value="GH">Ghana </option>
                      <option value="GI">Gibraltar </option>
                      <option value="GR">Greece </option>
                      <option value="GL">Greenland </option>
                      <option value="GD">Grenada </option>
                      <option value="GP">Guadeloupe </option>
                      <option value="GU">Guam </option>
                      <option value="GT">Guatemala </option>
                      <option value="GN">Guinea </option>
                      <option value="GW">Guinea-Bissau </option>
                      <option value="GY">Guyana </option>
                      <option value="HT">Haiti </option>
                      <option value="HO">Holland </option>
                      <option value="HN">Honduras </option>
                      <option value="HK">Hong Kong </option>
                      <option value="HU">Hungary </option>
                      <option value="IS">Iceland </option>
                      <option value="IN">India </option>
                      <option value="ID">Indonesia </option>
                      <option value="IL">Israel </option>
                      <option value="IT">Italy </option>
                      <option value="CI">Ivory Coast </option>
                      <option value="JM">Jamaica </option>
                      <option value="JP">Japan </option>
                      <option value="JO">Jordan </option>
                      <option value="KZ">Kazakhstan </option>
                      <option value="KE">Kenya </option>
                      <option value="KI">Kiribati </option>
                      <option value="KO">Kosrae </option>
                      <option value="KW">Kuwait </option>
                      <option value="KG">Kyrgyzstan </option>
                      <option value="LA">Laos </option>
                      <option value="LV">Latvia </option>
                      <option value="LB">Lebanon </option>
                      <option value="LS">Lesotho </option>
                      <option value="LR">Liberia </option>
                      <option value="LI">Liechtenstein </option>
                      <option value="LT">Lithuania </option>
                      <option value="LU">Luxembourg </option>
                      <option value="MO">Macau </option>
                      <option value="MK">Macedonia </option>
                      <option value="MG">Madagascar </option>
                      <option value="ME">Madeira </option>
                      <option value="MW">Malawi </option>
                      <option value="MY">Malaysia </option>
                      <option value="MV">Maldives </option>
                      <option value="ML">Mali </option>
                      <option value="MT">Malta </option>
                      <option value="MH">Marshall Islands </option>
                      <option value="MQ">Martinique </option>
                      <option value="MR">Mauritania </option>
                      <option value="MU">Mauritius </option>
                      <option value="MX">Mexico </option>
                      <option value="MD">Moldova </option>
                      <option value="MC">Monaco </option>
                      <option value="MS">Montserrat </option>
                      <option value="MA">Morocco </option>
                      <option value="MZ">Mozambique </option>
                      <option value="MM">Myanmar </option>
                      <option value="NA">Namibia </option>
                      <option value="NP">Nepal </option>
                      <option value="NL">Netherlands </option>
                      <option value="AN">Netherlands Antilles </option>
                      <option value="NC">New Caledonia </option>
                      <option value="NZ">New Zealand </option>
                      <option value="NI">Nicaragua </option>
                      <option value="NE">Niger </option>
                      <option value="NG">Nigeria </option>
                      <option value="NF">Norfolk Island </option>
                      <option value="NB">Northern Ireland </option>
                      <option value="MP">Northern Mariana Islands </option>
                      <option value="NO">Norway </option>
                      <option value="OM">Oman </option>
                      <option value="PK">Pakistan </option>
                      <option value="PW">Palau </option>
                      <option value="PA">Panama </option>
                      <option value="PG">Papua New Guinea </option>
                      <option value="PY">Paraguay </option>
                      <option value="PE">Peru </option>
                      <option value="PH">Philippines </option>
                      <option value="PL">Poland </option>
                      <option value="PO">Ponape </option>
                      <option value="PT">Portugal </option>
                      <option value="PR">Puerto Rico * </option>
                      <option value="QA">Qatar </option>
                      <option value="IE">Republic of Ireland </option>
                      <option value="YE">Republic of Yemen </option>
                      <option value="RE">Reunion </option>
                      <option value="RO">Romania </option>
                      <option value="RT">Rota </option>
                      <option value="RU">Russia </option>
                      <option value="RW">Rwanda </option>
                      <option value="SS">Saba </option>
                      <option value="SP">Saipan </option>
                      <option value="SA">Saudi Arabia </option>
                      <option value="SF">Scotland </option>
                      <option value="SN">Senegal </option>
                      <option value="SC">Seychelles </option>
                      <option value="SL">Sierra Leone </option>
                      <option value="SG">Singapore </option>
                      <option value="SK">Slovakia </option>
                      <option value="SI">Slovenia </option>
                      <option value="SB">Solomon Islands </option>
                      <option value="ZA">South Africa </option>
                      <option value="KR">South Korea </option>
                      <option value="ES">Spain </option>
                      <option value="LK">Sri Lanka </option>
                      <option value="NT">St. Barthelemy </option>
                      <option value="SW">St. Christopher </option>
                      <option value="SX">St. Croix </option>
                      <option value="EU">St. Eustatius </option>
                      <option value="UV">St. John </option>
                      <option value="KN">St. Kitts &amp; Nevis </option>
                      <option value="LC">St. Lucia </option>
                      <option value="MB">St. Maarten </option>
                      <option value="TB">St. Martin </option>
                      <option value="VL">St. Thomas </option>
                      <option value="VC">St. Vincent &amp; the Grenadines </option>
                      <option value="SD">Sudan </option>
                      <option value="SR">Suriname </option>
                      <option value="SZ">Swaziland </option>
                      <option value="SE">Sweden </option>
                      <option value="CH">Switzerland </option>
                      <option value="SY">Syria </option>
                      <option value="TA">Tahiti </option>
                      <option value="TW">Taiwan </option>
                      <option value="TJ">Tajikistan </option>
                      <option value="TZ">Tanzania </option>
                      <option value="TH">Thailand </option>
                      <option value="TI">Tinian </option>
                      <option value="TG">Togo </option>
                      <option value="TO">Tonga </option>
                      <option value="TL">Tortola </option>
                      <option value="TT">Trinidad &amp; Tobago </option>
                      <option value="TU">Truk </option>
                      <option value="TN">Tunisia </option>
                      <option value="TR">Turkey </option>
                      <option value="TC">Turks &amp; Caicos Islands </option>
                      <option value="TV">Tuvalu </option>
                      <option value="UG">Uganda </option>
                      <option value="UA">Ukraine </option>
                      <option value="UI">Union Island </option>
                      <option value="AE">United Arab Emirates </option>
                      <option value="GB">United Kingdom </option>
                      <option value="US" selected>United States </option>
                      <option value="UY">Uruguay </option>
                      <option value="VI">US Virgin Islands </option>
                      <option value="UZ">Uzbekistan </option>
                      <option value="VU">Vanuatu </option>
                      <option value="VE">Venezuela </option>
                      <option value="VN">Vietnam </option>
                      <option value="VR">Virgin Gorda </option>
                      <option value="WK">Wake Island </option>
                      <option value="WL">Wales </option>
                      <option value="WF">Wallis &amp; Futuna Islands </option>
                      <option value="WS">Western Samoa </option>
                      <option value="YA">Yap </option>
                      <option value="YU">Yugoslavia </option>
                      <option value="ZR">Zaire </option>
                      <option value="ZM">Zambia </option>
                      <option value="ZW">Zimbabwe </option>
                    </select>
COUNTRIES_TEXT
  return $countries_text;
}

sub no_header_redir {
  my $self = shift;
  my $url = $_[0];
  my $return = <<STUFF;
<html>
<head>
<meta http-equiv="refresh" content="0; URL=$url">
<body bgcolor="#ffffff">
</body>
</html>
STUFF
  return $return;
}

sub redir {
  my $self = shift;
  my $url = $_[0];
  my $return = <<STUFF;
Content-type: text/html  

<html>
<head>
<meta http-equiv="refresh" content="0; URL=$url">
<body bgcolor="#ffffff">
</body>
</html>
STUFF
  return $return;
}

sub cart_domains {
  my $self = shift;
  my $domains = $cookies->one('domains');
  my @domains = split(/\|/, $domains);
  my $domains_aref = \@domains;
  return $domains_aref;
}

sub format_date {
  my $self = shift;
  # Define arrays for the day of the week and month of the year.           #
  my @days   = ('Sunday','Monday','Tuesday','Wednesday',
                'Thursday','Friday','Saturday');
  my @months = ('January','February','March','April','May','June','July',
	         'August','September','October','November','December');
  # Get the current time and format the hour, minutes and seconds.  Add    #
  # 1900 to the year to get the full 4 digit year.                         #
  my ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime($_[0]))[0,1,2,3,4,5,6];
  my $time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
  $year += 1900;
  # Format the date.                                                       #
  my $date = "$days[$wday], $months[$mon] $mday, $year at $time";
  return $date;
}

sub return_button_code {
  my $primary = $_[0];
  my $secondary = $_[1];
  my $dbh = $dbi->db_connect;
  # DEBUG
  my $button_html;
  my $which_brand = cookie('which_brand') || '';
  if ($which_brand eq '') {
    $button_html .= '<img src="/pics/home_page_off.gif" width="86" height="20" alt="" border="0">';
  } else {
    $button_html .= '<a href="/index.html"><img src="/pics/home_page_selected.gif" width="86" height="20" alt="" border="0"></a>';
  }
  my $sth = $dbh->prepare('select * from brands');
  $sth->execute;
  my %image_widths;
  $image_widths{'1'} = '95'; 
  $image_widths{'2'} = '98';
  $image_widths{'3'} = '84'; 
  $image_widths{'4'} = '49'; 
  $image_widths{'5'} = '98'; 
  $image_widths{'6'} = '68'; 
  $image_widths{'7'} = '0';
  $image_widths{'8'} = '0';
  $image_widths{'11'} = '0';
  while (my $row_href = $sth->fetchrow_hashref) {
    my $id = $row_href->{'id'};
    unless ($image_widths{$id} eq 0) {
	  my $which_brand = cookie('which_brand');
      $button_html .= '<img src="/pics/spacer.gif" height="1" width="1">';
      if ($primary eq $id || $which_brand eq $id) {
        $button_html .= '<img src="/pics/brand_' . $id . '_off.gif" width="' . $image_widths{$id} . '" ' . 'height="20" alt="" border="0">';
      } else {
        $button_html .= '<a href="/cgi-bin/shopcms/public?primary=' . $id . '&secondary="><img src="/pics/brand_' . $id . '_selected.gif" width="' . $image_widths{$id} . '" height="20" alt="" border="0"></a>';
      }
    }
  }
  $sth->finish;
  $dbh->disconnect;
  $button_html .= '<br>';
  return $button_html;
}

sub return_side_link_code {
  my $self = shift;
  my $primary = $_[0];
  my $secondary = $_[1];
#  print header;
#  print <<TEST;
#<br>
#self: $self<br>
#config_file: $self->{'config_file'}<br>
#primary: $primary<br>
#secondary: $secondary<br>
#TEST
#exit;
  my $dbi = Freedom::DBI->new($self->{'config_file'});
  my $dbh = $dbi->db_connect;  
  #my $config = $self->{'config_object'};
  #my $paypal_email = $config->one('paypal_email');
  my $paypal_email = $self->{'config_object'}->one('paypal_email');
  my $paypal_text = <<STUFF_GOES_HERE;

  <form name="_xclick" target="paypal" action="https://www.paypal.com/cgi-bin/webscr" method="post">
  <input type="hidden" name="cmd" value="_cart">
  <input type="hidden" name="business" value="$paypal_email">
  <input type="image" src="/pics/shopcms/view_cart.gif" border="0" name="submit" alt="Make payments with PayPal - it's fast, free and secure!">
  <input type="hidden" name="display" value="1">
</form> 

<b>Choose A Category:</b><p>  
STUFF_GOES_HERE
  my $side_html = $paypal_text;
  my $which_brand = cookie('which_brand') || '';
  # if there is a brand cookie, we only show categories
  # that this brand has products in
  if ($which_brand ne '') {
    # does the brand id currently in the cookie have any
	# categories associated w/ it?
    $brand_matched = 0;
	my $sth = $dbh->prepare('select category_id, brand_id from brands_categories where brand_id = ?');
    $sth->execute($which_brand);
	while (my $row_href = $sth->fetchrow_hashref) {
	  $side_html .= '<a href="/cgi-bin/shopcms/public?primary=' . $row_href->{'brand_id'} . '&secondary=' . $row_href->{'category_id'} . '&only_primary=true">' . 
      '<img src="/pics/shopcms/plus_sign.gif" width="9" ' . 
      'height="9" alt="" border="0"></a> <a href="/cgi-bin/shopcms/public?primary=' . $row_href->{'brand_id'} . '&secondary=' . $row_href->{'category_id'} . '&only_primary=true">';
	  my $sth2 = $dbh->prepare('select category from categories where id = ?');
	  $sth2->execute($row_href->{'category_id'});
	  my $rh2 = $sth2->fetchrow_hashref;
	  my $category = $rh2->{'category'};
      $side_html .= $category . '</a><br>';
	}
  } else {
    # there is no brand cookie so show all categories
    my $sth = $dbh->prepare('select * from categories order by category');
    $sth->execute;
    while (my $row_href = $sth->fetchrow_hashref) {
      # otherwise, if there's no which_brand cookie, we just
  	  # show a list of all brands under this category
      if ($secondary eq $row_href->{'id'}) {
        $side_html .= '<a href="/cgi-bin/shopcms/public?mode=home">' . 
        '<img src="/pics/shopcms/minus_sign.gif" width="9" ' . 
        'height="9" alt="" border="0"></a> <a href="/cgi-bin/shopcms/public?' . 
        'mode=home">' . 
        $row_href->{'category'} . '</a><br>';
        $side_html .= $self->get_relational($dbh, $row_href->{'id'});
      } else {
        $side_html .= '<a href="/cgi-bin/shopcms/public?primary=&secondary=' . 
        $row_href->{'id'} . '"><img src="/pics/shopcms/plus_sign.gif" width="9" ' . 
        'height="9" alt="" border="0"></a> <a href="/cgi-bin/shopcms/public?' . 
        'primary=&secondary=' . $row_href->{'id'} . '">' . 
        $row_href->{'category'} . '</a><br>';
      }
    }
  }
  $dbh->disconnect;
  return $side_html;
}

sub get_relational {
  my $self = shift;
  my $dbh = $_[0];
  my $input_id = $_[1];
  my $side_html;

  # This lists all of the brands that sell
  # something in one particular category.
  
  my $statement = qq|
                     select distinct brands.id, brands.brand_name
                     from brands left join catalog
                     on brands.id=catalog.brand_id
                     where catalog.category = ?
  |;
  my $sth = $dbh->prepare($statement);
  $sth->execute($input_id);
  while (my $row_href = $sth->fetchrow_hashref) {
    my $brand_name = $row_href->{'brand_name'};
    my $brand_id = $row_href->{'id'};
	#$brand_name =~ s/_/ /;
    #$brand_name =~ s/\b(\w)/\U$1/g;
    $side_html .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="' . $url . 
      '?primary=' . $brand_id . '&secondary=' . $input_id . 
        '&only_primary=true' . '">' . $brand_name . '</a><br>' . "\n";
  }
  return $side_html;
}

sub get_just_this_brand {
  my $dbh = $_[0];
  my $input_brand_id = $_[1];
  my $side_html;

  # This lists all of the brands that sell
  # something in one particular category.
  
  #my $statement = qq|
  #                   select distinct brands.id, brands.brand_name
  #                   from brands left join catalog
  #                   on brands.id=catalog.brand_id
  #                   where catalog.category = ?
  #|;
  #my $sth_first = $dbh->prepare('select 
  my $statement = 'select * from brands where id = ?';
  my $sth = $dbh->prepare($statement);
  $sth->execute($input_brand_id);
  while (my $row_href = $sth->fetchrow_hashref) {
    my $brand_name = $row_href->{'brand_name'};
    #$brand_name =~ s/_/ /;
    #$brand_name =~ s/\b(\w)/\U$1/g;
    $side_html .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="' . $url . 
      '?primary=' . $input_brand_id . $brand_name . '&secondary=' . 
        '&only_primary=true' . '">' . $brand_name . '</a><br>' . "\n";
  }
  return $side_html;
}

1;

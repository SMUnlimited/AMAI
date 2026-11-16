use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use FindBin;

# Load the production helper without starting the Strategy Manager GUI.
open my $source_file, '<', "$FindBin::Bin/../AMAIStrategyManager.pl" or die $!;
my $source = do { local $/; <$source_file> };
close $source_file;
my ($helper) = $source =~ /^(sub GetLockStatus \{.*?)(?=^sub UpdateLockStatus \{)/ms;
die 'Lock status helper not found' unless defined $helper;
eval $helper;
die $@ if $@;

sub status_for {
  my ($settings, $option, $kind, @names) = @_;
  my ($file, $path) = tempfile(UNLINK => 1);
  print $file $settings;
  close $file;
  return GetLockStatus($path, $option, $kind, @names);
}

subtest 'Saved strategy locks show the strategy name and unlocking clears it' => sub {
  is(status_for("debug_strategy\tSTRAT_NormalHuman\tComment\n", 'debug_strategy', 'strategy'),
    'Locked strategy: NormalHuman', 'A saved lock is visible when loaded');
  is(status_for("debug_strategy\t-1\tComment\n", 'debug_strategy', 'strategy'),
    'No strategy locked', 'Unlocking has an explicit status');
  is(status_for("other_setting\t1\tComment\n", 'debug_strategy', 'strategy'),
    'No strategy locked', 'A missing setting uses the unlocked default');
};

subtest 'Numeric locks show names from the current race or version' => sub {
  is(status_for("debug_strategy\t0\tComment\n", 'debug_strategy', 'strategy', 'NormalHuman', 'MassSp'),
    'Locked strategy: NormalHuman', 'Strategy index zero is supported');
  is(status_for("debug_profile\t1\tComment\n", 'debug_profile', 'profile', 'Hunter', 'Crazy_Rusher'),
    'Locked profile: Crazy_Rusher', 'Profiles show their names instead of indices');
  is(status_for("debug_profile\t99\tComment\n", 'debug_profile', 'profile', 'Hunter'),
    'Locked profile: 99', 'An unresolved lock remains visible');
};

{
  package LockNotebook;
  sub raised { $_[0]->{tab} }
  package LockWindow;
  sub messageBox { my $self = shift; push @{$self->{messages}}, {@_} }
  package LockProfiles;
  sub get { ('Hunter', 'Crazy_Rusher') }
}

my ($lock_button) = $source =~ /^(create_button\(\$bframe, 'Lock',.*?^\}, 6, [^\n]+\n)/ms;
die 'Lock button not found' unless defined $lock_button;
my ($index_helper) = $source =~ /^(sub GetArrayIndex \{.*?)(?=^sub SetRaceOption \{)/ms;
eval $index_helper;
die $@ if $@;
my ($bframe, $lock, @saved, $refreshes);
my $notebook = bless {tab => 'strat'}, 'LockNotebook';
my $main = bless {messages => []}, 'LockWindow';
my $profilelb = bless {}, 'LockProfiles';
my ($ver, $race, $strat, $profile) = ('REFORGED', 'Human', ['NormalHuman'], ['Crazy_Rusher']);
sub create_button { $lock = $_[2] }
sub SetRaceOption { push @saved, [@_] }
sub SetVerOption { push @saved, [@_] }
sub UpdateLockStatus { $refreshes++ }
eval $lock_button;
die $@ if $@;

subtest 'Clicking Lock saves the selected strategy and refreshes its status' => sub {
  @saved = ();
  $refreshes = 0;

  $lock->();

  is_deeply(\@saved, [['REFORGED', 'Human', 'debug_strategy', 'STRAT_NormalHuman']],
    'The button writes the selected strategy');
  is($refreshes, 1, 'The visible status refreshes after saving');
};

subtest 'Clicking Lock on the Profiles tab saves the selected profile index' => sub {
  @saved = ();
  $refreshes = 0;
  $notebook->{tab} = 'profile';

  $lock->();

  is_deeply(\@saved, [['REFORGED', 'debug_profile', 1]], 'The selected profile is saved');
  is($refreshes, 1, 'The profile status refreshes');
};

subtest 'Clicking Lock without a selection explains what to do and leaves settings alone' => sub {
  @saved = ();
  $refreshes = 0;
  $notebook->{tab} = 'strat';
  $strat = [];

  $lock->();

  is(scalar @saved, 0, 'No lock is written without a selection');
  like($main->{messages}[-1]{'-message'}, qr/Select a strategy or profile/, 'The click shows guidance');
};

done_testing;

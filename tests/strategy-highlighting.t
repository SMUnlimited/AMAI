use strict;
use warnings;
use Test::More;
use FindBin;

# Load the production helpers without starting the Strategy Manager GUI.
open my $file, '<', "$FindBin::Bin/../AMAIStrategyManager.pl" or die $!;
my $source = do { local $/; <$file> };
close $file;
my ($helpers) = $source =~ /^(sub HighlightJass \{.*?)(?=^sub FillTexts \{)/ms;
die 'Highlighting helpers not found' unless defined $helpers;
eval $helpers;
die $@ if $@;

{
  package CodeField;
  sub new { bless { source => $_[1], tags => [], scans => 0 }, $_[0] }
  sub get { $_[0]->{source} }
  sub tagConfigure { }
  sub tagRaise { $_[0]->{raised} = $_[1] }
  sub tagRemove {
    my ($self, $tag) = @_;
    $self->{tags} = [grep { $_->[0] ne $tag } @{$self->{tags}}];
    $self->{scans}++ if $tag eq 'jass_keyword';
  }
  sub tagAdd {
    my ($self, $tag, $start, $end) = @_;
    my ($line, $column) = split /\./, $start;
    my (undef, $last) = split /\./, $end;
    my @lines = split /\n/, $self->{source};
    push @{$self->{tags}}, [$tag, substr($lines[$line - 1], $column, $last - $column)];
  }
  sub repeat { $_[0]->{refresh} = $_[2] }
}

subtest 'JASS tokens are coloured without highlighting words inside literals or comments' => sub {
  my $field = CodeField->new(<<'JASS');
call Build('hfoo', 12, 0.5, .25, $FF)
set message = "if \"then\" // else" // call 123 "text"
call endif_helper(true)
JASS

  EnableJassHighlighting($field);

  is_deeply($field->{tags}, [
    ['jass_keyword', 'call'], ['jass_literal', "'hfoo'"],
    ['jass_number', '12'], ['jass_number', '0.5'],
    ['jass_number', '.25'], ['jass_number', '$FF'],
    ['jass_keyword', 'set'], ['jass_literal', '"if \\"then\\" // else"'],
    ['jass_comment', '// call 123 "text"'],
    ['jass_keyword', 'call'], ['jass_keyword', 'true'],
  ], 'Only complete tokens receive syntax tags across multiple lines');
  is($field->{raised}, 'sel', 'Selection remains above the syntax colours');
};

subtest 'Typing, paste and undo refresh colours while unchanged text is skipped' => sub {
  my $field = CodeField->new('call Build()');
  EnableJassHighlighting($field);

  $field->{refresh}->();
  is($field->{scans}, 1, 'Unchanged text is not scanned again');

  for my $edited ('// call Build()', 'set x = 42', 'call Build()', '') {
    $field->{source} = $edited;
    $field->{refresh}->();

    my $fresh = CodeField->new($edited);
    HighlightJass($fresh, $edited);
    is_deeply($field->{tags}, $fresh->{tags}, 'Changed text replaces all previous colours');
    is($field->{source}, $edited, 'Highlighting preserves the editable text');
  }
};

subtest 'Unfinished literals keep their contents coloured while typing' => sub {
  my $field = CodeField->new("set x = \"if // call\ncall Next()");

  EnableJassHighlighting($field);

  is_deeply($field->{tags}, [
    ['jass_keyword', 'set'], ['jass_literal', '"if // call'],
    ['jass_keyword', 'call'],
  ], 'An unfinished string does not consume the next line');
};

done_testing;

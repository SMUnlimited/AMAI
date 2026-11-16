use strict;
use warnings;
use Test::More;
use FindBin;
use Tk;
use Tk::TextUndo;
use Tk::NoteBook;
use Tk::Panedwindow;
use Tk::Table;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use File::Copy qw(copy);

# Exercise the production helpers using real Tk text and undo behaviour.
open my $file, '<', "$FindBin::Bin/../AMAIStrategyManager.pl" or die $!;
my $source = do { local $/; <$file> };
close $file;
my ($helpers) = $source =~ /^(sub GuardEditorCancel \{.*?)(?=^sub HighlightJass \{)/ms;
die 'Editor helpers not found' unless defined $helpers;
eval $helpers;
die $@ if $@;
for my $name (qw(EditStrat GetVarList ExtendTable ExtendOptList GetOptList
    OptionmenuAddOptions GetUnitLists FillTable AssembleTable HighlightJass
    EnableJassHighlighting FillTexts SaveStrat EditRacialBuilds LoadRacialBuild
    SaveRacialBuild mouse_wheel)) {
  my ($function) = $source =~ /^(sub $name \{.*?^\})/ms;
  die "Missing production function $name" unless defined $function;
  eval $function;
  die $@ if $@;
}

my $main = MainWindow->new;
$main->withdraw;

sub code_field {
  my ($content) = @_;
  my $text = $main->TextUndo(-exportselection => 0, -wrap => 'none');
  $text->insert('1.0', $content);
  $text->ResetUndo;
  $text->markSet('insert', '1.0');
  return $text;
}

subtest 'Find selects literal text and wraps to the beginning' => sub {
  my $text = code_field("call Build()\ncall Build()\nCALL Build()");

  ok(FindCodeText($text, 'Build()'), 'Find first literal match');
  is($text->index('sel.first'), '1.5', 'Select first occurrence');
  ok(FindCodeText($text, 'Build()'), 'Find next occurrence');
  is($text->index('sel.first'), '2.5', 'Advance to next line');
  $text->markSet('insert', 'end-1c');
  ok(FindCodeText($text, 'Build()'), 'Wrap after the last occurrence');
  is($text->index('sel.first'), '1.5', 'Wrap to the first occurrence');
  ok(!FindCodeText($text, 'build()'), 'Search is case sensitive');
  ok(!FindCodeText($text, ''), 'Empty search is ignored');
  $text->destroy;
};

subtest 'Replace changes only a matching selection and supports undo' => sub {
  my $text = code_field("call Build()\ncall Build()");
  $text->tagAdd('sel', '1.0', '1.4');

  is(ReplaceCodeText($text, 'Build()', 'Train()', 0), 1, 'Replace finds a matching occurrence');
  is($text->get('1.0', 'end-1c'), "call Train()\ncall Build()", 'Unrelated selection and second match are preserved');
  $text->undo;
  $text->undo;
  is($text->get('1.0', 'end-1c'), "call Build()\ncall Build()", 'Undo restores the original text');
  $text->destroy;
};

subtest 'Replace All advances past replacements without rescanning them' => sub {
  my $text = code_field('aaa');

  is(ReplaceCodeText($text, 'a', 'aa', 1), 3, 'Inserted matches are not replaced again');
  is($text->get('1.0', 'end-1c'), 'aaaaaa', 'Each original match is replaced once');
  is(ReplaceCodeText($text, 'aa', '', 1), 3, 'Adjacent matches can be deleted');
  is($text->get('1.0', 'end-1c'), '', 'Empty replacement removes all matches');
  is(ReplaceCodeText($text, '', 'x', 1), 0, 'Empty search cannot loop');
  $text->insert('1.0', "a.b\na.b");
  is(ReplaceCodeText($text, 'a.b', "x\ny", 1), 2, 'Literal punctuation and multiline replacements work');
  is($text->get('1.0', 'end-1c'), "x\ny\nx\ny", 'Line breaks in replacements are preserved');
  $text->destroy;
};

subtest 'Find and replace dialog buttons operate on their code field' => sub {
  my $text = code_field('Build Build');
  my $dialog = ShowCodeFindReplace($text);
  $dialog->withdraw;
  my @entries = grep { $_->isa('Tk::Entry') } $dialog->children;
  my ($buttons) = grep { $_->isa('Tk::Frame') } $dialog->children;
  my %button = map { $_->cget('-text') => $_ } $buttons->children;
  $entries[0]->insert('0', 'Build');
  $entries[1]->insert('0', 'Train');

  $button{'Find Next'}->invoke;
  is($text->get('sel.first', 'sel.last'), 'Build', 'Find button selects the search term');
  is($text->get('search_match.first', 'search_match.last'), 'Build',
    'Match has a persistent highlight while the dialog holds focus');
  is($text->tagCget('search_match', '-background'), '#FFE082',
    'Search highlight has its own background independent of selection focus');
  $button{'Find Next'}->invoke;
  is($text->index('search_match.first'), '1.6', 'Find Next moves the persistent highlight');
  $button{'Find Next'}->invoke;
  $button{'Replace'}->invoke;
  is($text->get('1.0', 'end-1c'), 'Train Build', 'Replace button changes one match');
  is_deeply([$text->tagRanges('search_match')], [], 'Replacing clears the previous match highlight');
  $button{'Find Next'}->invoke;
  $button{'Replace All'}->invoke;
  is($text->get('1.0', 'end-1c'), 'Train Train', 'Replace All button changes remaining matches');
  $entries[0]->delete('0', 'end');
  $entries[0]->insert('0', 'Train');
  $button{'Find Next'}->invoke;
  $button{'Close'}->invoke;
  ok(!Tk::Exists($dialog), 'Close dismisses the dialog');
  is_deeply([$text->tagRanges('search_match')], [], 'Closing search removes its highlight');
  $text->destroy;
};

{
  package EditorWindow;
  sub new { bless { prompts => 0, response => 'No' }, shift }
  sub protocol { $_[0]->{close} = $_[2] }
  sub messageBox {
    my ($self, %options) = @_;
    $self->{prompts}++;
    $self->{default} = $options{-default};
    return $self->{response};
  }
  sub destroy { $_[0]->{destroyed}++ }
}

subtest 'Cancel and window close warn only when current values differ' => sub {
  my $edit = EditorWindow->new;
  my @values = ('original code', 'original option');
  my $cancel = GuardEditorCancel($edit, sub { [@values] });

  $values[1] = 'changed option';
  $cancel->();
  is($edit->{prompts}, 1, 'Option changes trigger a warning');
  is($edit->{default}, 'no', 'Keeping edits is the default choice');
  ok(!$edit->{destroyed}, 'No keeps the editor open');

  $values[1] = 'original option';
  $values[0] = 'changed code';
  $edit->{close}->();
  is($edit->{prompts}, 2, 'Window close also warns for code changes');
  ok(!$edit->{destroyed}, 'Declining window close preserves edits');

  $values[0] = 'original code';
  $cancel->();
  is($edit->{prompts}, 2, 'Reverting all edits avoids a warning');
  is($edit->{destroyed}, 1, 'Unchanged editor closes immediately');

  $values[0] = 'new code';
  $edit->{response} = 'Yes';
  $cancel->();
  is($edit->{destroyed}, 2, 'Yes discards changes and closes');
};

subtest 'Line numbers follow visible lines and update after insertion and scrolling' => sub {
  # Layout widgets off screen so dlineinfo uses real font and scroll geometry.
  my $window = $main->Toplevel;
  $window->geometry('600x250+10000+10000');
  my $text = CreateCodeField($window, 6);
  $text->insert('1.0', join("\n", map { "call Step$_()" } 1..100));
  $window->update;
  my ($frame) = $window->children;
  my ($gutter) = grep { $_->isa('Tk::Canvas') } $frame->children;

  DrawCodeLineNumbers($text, $gutter);
  my @items = $gutter->find('all');
  is($gutter->itemcget($items[0], '-text'), 1, 'First visible line is numbered one');
  my @coords = $gutter->coords($items[0]);
  my @box = $text->dlineinfo('1.0');
  is($coords[1], $box[1], 'Number aligns with its text line');

  $text->yview('50.0');
  $window->update;
  DrawCodeLineNumbers($text, $gutter);
  @items = $gutter->find('all');
  my ($top) = split /\./, $text->index('@0,0');
  is($gutter->itemcget($items[0], '-text'), $top, 'Scrolling keeps the correct line numbers');

  $text->insert('1.0', "new line\n");
  $text->see('end');
  $window->update;
  DrawCodeLineNumbers($text, $gutter);
  @items = $gutter->find('all');
  is($gutter->itemcget($items[-1], '-text'), 101, 'Newlines update the last line number');
  $window->destroy;
};

sub editor_fixture {
  my $version = tempdir(CLEANUP => 1);
  make_path("$version/Human");
  for my $path (qw(StandardUnits.txt Races.txt Human/Tiers.txt Human/Strategy.txt Human/BuildSequence.ai)) {
    copy("$FindBin::Bin/../REFORGED/$path", "$version/$path") or die $!;
  }
  return $version;
}

sub editor_buttons {
  my ($edit) = @_;
  my ($bar) = grep { $_->isa('Tk::Frame') && !$_->isa('Tk::Panedwindow') } $edit->children;
  return map { $_->cget('-text') => $_ } $bar->children;
}

subtest 'Strategy tabs resize with the divider and retain edits when saved' => sub {
  my $version = editor_fixture();
  my $edit = EditStrat($main, $version, 'Human', ['NormalHuman']);
  $edit->geometry('1000x650+10000+10000');
  $edit->update;
  my ($panes) = grep { $_->isa('Tk::Panedwindow') } $edit->children;
  my ($left, $right) = $panes->children;
  my ($notebook) = grep { $_->isa('Tk::NoteBook') } $left->children;
  my %buttons = editor_buttons($edit);
  is_deeply([$notebook->pages], [qw(code0 code1 code2 code3 all)], 'Initialization, every configured tier and All have a tab');
  is($notebook->pagecget('code0', '-label'), 'Initialization', 'Initialization tab is clearly named');
  my $init = $edit->{active_code_field};
  my $original_init = $init->get('1.0', 'end-1c');
  my $original_width = $init->width;
  $panes->sashPlace(0, 400, 0);
  $edit->update;
  cmp_ok($init->width, '<', $original_width, 'Dragging the divider changes the code width');
  my $original_height = $init->height;
  $edit->geometry('1100x750+10000+10000');
  $edit->update;
  cmp_ok($init->height, '>', $original_height, 'Code grows when the window grows');
  ok($buttons{OK}->ismapped && $buttons{Cancel}->ismapped, 'Bottom buttons remain visible after resizing');

  $notebook->raise('code2');
  my $tier2 = $edit->{active_code_field};
  my $original_tier2 = $tier2->get('1.0', 'end-1c');
  $tier2->ResetUndo;
  $tier2->insert('1.0', "// edited tier two\n");
  $tier2->markSet('insert', '2.0');
  $notebook->raise('code0');
  is($init->get('1.0', 'end-1c'), $original_init, 'Switching tabs preserves initialization');
  $notebook->raise('code2');
  is($tier2->index('insert'), '2.0', 'Cursor position survives tab switching');
  $tier2->undo;
  is($tier2->get('1.0', 'end-1c'), $original_tier2, 'Undo history survives tab switching');
  $tier2->insert('1.0', "// edited tier two\n");
  $notebook->raise('code0');
  $buttons{OK}->invoke;
  ok(!Tk::Exists($edit), 'Saving closes the editor');

  $edit = EditStrat($main, $version, 'Human', ['NormalHuman']);
  $edit->geometry('1000x650+10000+10000');
  ($panes) = grep { $_->isa('Tk::Panedwindow') } $edit->children;
  ($left, $right) = $panes->children;
  ($notebook) = grep { $_->isa('Tk::NoteBook') } $left->children;
  is($edit->{active_code_field}->get('1.0', 'end-1c'), $original_init . "\n", 'Initialization reloads with the existing save format\'s trailing newline');
  $notebook->raise('code2');
  like($edit->{active_code_field}->get('1.0', 'end-1c'), qr{^// edited tier two\n}, 'Saving includes edits in an inactive tier tab');
  %buttons = editor_buttons($edit);
  $buttons{Cancel}->invoke;
  ok(!Tk::Exists($edit), 'An unchanged tabbed editor cancels without a prompt');
};

subtest 'An open search dialog follows the active racial-build tab' => sub {
  my $version = editor_fixture();
  my $edit = EditRacialBuilds($main, $version, 'Human');
  $edit->geometry('900x600+10000+10000');
  my ($notebook) = grep { $_->isa('Tk::NoteBook') } $edit->children;
  is_deeply([$notebook->pages], [qw(code0 code1 all)], 'Racial builds have initialization, build and All tabs');
  my $init = $edit->{active_code_field};
  my $dialog = ShowCodeFindReplace($init);
  $dialog->withdraw;
  my @entries = grep { $_->isa('Tk::Entry') } $dialog->children;
  my ($bar) = grep { $_->isa('Tk::Frame') } $dialog->children;
  my %search = map { $_->cget('-text') => $_ } $bar->children;
  $entries[0]->insert('0', 'call');
  $entries[1]->insert('0', 'CALL');
  $search{'Find Next'}->invoke;
  is($init->get('search_match.first', 'search_match.last'), 'call', 'Initial search highlights initialization code');

  $notebook->raise('code1');
  my $build = $edit->{active_code_field};
  is_deeply([$init->tagRanges('search_match')], [], 'Switching tabs clears the hidden search highlight');
  $search{'Find Next'}->invoke;
  is($build->get('search_match.first', 'search_match.last'), 'call', 'Find Next searches the active build tab');
  $search{Replace}->invoke;
  like($build->get('1.0', 'end-1c'), qr/CALL/, 'Replace changes the active tab');
  unlike($init->get('1.0', 'end-1c'), qr/CALL/, 'Replace leaves the inactive tab untouched');
  is(ShowCodeFindReplace($build), $dialog, 'Opening search from another tab reuses the dialog');
  $search{Close}->invoke;

  # Cancel must also check changes in a tab that is no longer visible.
  $notebook->raise('code0');
  my %buttons = editor_buttons($edit);
  my $prompts = 0;
  {
    no warnings qw(redefine once);
    local *Tk::Widget::messageBox = sub { $prompts++; return 'No' };
    $buttons{Cancel}->invoke;
  }
  is($prompts, 1, 'Cancel warns about edits in the hidden build tab');
  ok(Tk::Exists($edit), 'Declining discard keeps the editor open');
  $buttons{OK}->invoke;
  $edit = EditRacialBuilds($main, $version, 'Human');
  $edit->geometry('900x600+10000+10000');
  ($notebook) = grep { $_->isa('Tk::NoteBook') } $edit->children;
  $notebook->raise('code1');
  like($edit->{active_code_field}->get('1.0', 'end-1c'), qr/CALL/, 'Racial-build save includes edits in the hidden tab');
  %buttons = editor_buttons($edit);
  $buttons{Cancel}->invoke;
};

subtest 'All supports cross-tier replacement and saves synchronized section edits' => sub {
  my $version = editor_fixture();
  my $edit = EditStrat($main, $version, 'Human', ['NormalHuman']);
  $edit->geometry('1000x650+10000+10000');
  my ($panes) = grep { $_->isa('Tk::Panedwindow') } $edit->children;
  my ($left) = $panes->children;
  my ($notebook) = grep { $_->isa('Tk::NoteBook') } $left->children;
  my @fields = @{$edit->{code_fields}};
  $_->insert('1.0', "// shared-token\n") for @fields;
  my @original = map { $_->get('1.0', 'end-1c') } @fields;

  $notebook->raise('all');
  my $all = $edit->{active_code_field};
  is($all, $edit->{all_code_field}, 'All is the active editable code field');
  is_deeply(ReadCodeTabValues($edit), \@original, 'Combining sections preserves code and whitespace exactly');
  my $dialog = ShowCodeFindReplace($all);
  $dialog->withdraw;
  my @entries = grep { $_->isa('Tk::Entry') } $dialog->children;
  my ($bar) = grep { $_->isa('Tk::Frame') } $dialog->children;
  my %search = map { $_->cget('-text') => $_ } $bar->children;
  $entries[0]->insert('0', 'shared-token');
  $entries[1]->insert('0', 'updated-token');
  $search{'Replace All'}->invoke;
  my $values = ReadCodeTabValues($edit);
  like($_, qr{^// updated-token\n}, 'Replace All reaches each section') for @$values;
  $search{Close}->invoke;

  $notebook->raise('code2');
  like($fields[2]->get('1.0', 'end-1c'), qr{^// updated-token\n}, 'All edits synchronize into the tier tab');
  $fields[2]->insert('1.0', "// individual edit\n");
  $notebook->raise('all');
  like($all->get('1.0', 'end-1c'), qr{// individual edit\n// updated-token}, 'Individual edits synchronize back into All');
  $all->insert('end-1c', "// saved directly from All\n");
  my %buttons = editor_buttons($edit);
  $buttons{OK}->invoke;

  $edit = EditStrat($main, $version, 'Human', ['NormalHuman']);
  $edit->geometry('1000x650+10000+10000');
  @fields = @{$edit->{code_fields}};
  like($_->get('1.0', 'end-1c'), qr{updated-token}, 'Cross-section replacement survives saving and reloading') for @fields;
  like($fields[2]->get('1.0', 'end-1c'), qr{^// individual edit}, 'Individual tier edits survive the combined save');
  like($fields[3]->get('1.0', 'end-1c'), qr{// saved directly from All}, 'Saving All includes its latest unsynchronized edits');
  unlike($_->get('1.0', 'end-1c'), qr{// === AMAI section:}, 'Display headings are excluded from saved code') for @fields;
  %buttons = editor_buttons($edit);
  $buttons{Cancel}->invoke;
};

subtest 'All validates boundaries and warns before discarding combined edits' => sub {
  my $version = editor_fixture();
  my $edit = EditRacialBuilds($main, $version, 'Human');
  $edit->geometry('900x600+10000+10000');
  my ($notebook) = grep { $_->isa('Tk::NoteBook') } $edit->children;
  my @original = @{ReadCodeTabValues($edit)};
  $notebook->raise('all');
  my $all = $edit->{active_code_field};
  is_deeply(ReadCodeTabValues($edit), \@original, 'Simply visiting All does not create unsaved changes');
  $all->ResetUndo;
  $all->delete('1.0', '2.0');
  ok(!ParseAllCode($edit), 'A deleted heading fails validation');
  my %buttons = editor_buttons($edit);
  my @prompts;
  {
    no warnings qw(redefine once);
    local *Tk::Widget::messageBox = sub { my ($self, %args) = @_; push @prompts, $args{-title}; return 'No' };
    $buttons{OK}->invoke;
    ok(Tk::Exists($edit), 'Invalid boundaries block saving');
    $notebook->raise('code1');
    is($notebook->raised, 'all', 'Invalid boundaries keep the combined buffer visible');
    is_deeply([map { $_->get('1.0', 'end-1c') } @{$edit->{code_fields}}], \@original, 'Rejected edits leave individual sections untouched');
    $buttons{Cancel}->invoke;
    ok(Tk::Exists($edit), 'Declining discard preserves the invalid buffer for repair');
  }
  is_deeply(\@prompts, ['Section headings changed', 'Section headings changed', 'Discard changes?'],
    'Saving, switching and cancelling provide the appropriate warnings');
  $all->undo;
  is_deeply(ReadCodeTabValues($edit), \@original, 'Undo restores boundaries and the original code');
  $buttons{Cancel}->invoke;
  ok(!Tk::Exists($edit), 'Reverted All edits cancel without a warning');
};

$main->destroy;
done_testing;

#! /usr/bin/perl5 -w

use strict;

sub process_dir {
	my $dirname = $_[0];
	my $commander = $_[1];
	my $filename;

	opendir my $DIR, $dirname or die "Could not open $dirname\n";

	while ($filename = readdir($DIR)) {
		next if $filename eq "." || $filename eq "..";
		if ((-d "$dirname/$filename") ) {
			print "Uninstalling AMAI and Commander and Icon to dir $dirname\\$filename\n";
			process_dir ("$dirname\\$filename", $commander);
		} elsif ($filename =~ m/\.w3m$/ || $filename =~ m/\.w3x$/ ) {
			print "Uninstalling AMAI and Commander and Icon to $dirname/$filename\n";
			system "MPQEditor htsize \"$dirname/$filename\" 128";

			system "MPQEditor d \"$dirname/$filename\" Scripts\\common.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\elf.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\human.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\orc.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\undead.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\elf2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\human2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\orc2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\undead2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\Blizzard.j";

			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClawsOfAttack+3.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClawsOfAttack+6.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClawsOfAttack+9.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClawsOfAttack+12.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClawsOfAttack+15.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRingGreen+1.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRingGreen+2.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRingGreen+3.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRingGreen+4.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRingGreen+5.blp";

			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+4.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+5.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+8.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+9.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+12.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIClaw+15.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRoP+3.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRoP+4.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtons\\BTN_AMAIRoP+5.dds";

			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClawsOfAttack+3.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClawsOfAttack+6.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClawsOfAttack+9.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClawsOfAttack+12.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClawsOfAttack+15.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRingGreen+1.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRingGreen+2.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRingGreen+3.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRingGreen+4.blp";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRingGreen+5.blp";

			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+4.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+5.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+8.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+9.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+12.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIClaw+15.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRoP+3.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRoP+4.dds";
			system "MPQEditor d \"$dirname/$filename\" ReplaceableTextures\\CommandButtonsDisabled\\DISBTN_AMAI_AMAIRoP+5.dds";

			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainLife.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainLife.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainMana.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainMana.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainPower.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-FountainPower.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\MiniMap-Gold.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-GragonRoost.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-GragonRoost.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\MiniMapIconCreepLoc.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\MiniMapIconCreepLoc2.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Laboratory.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Laboratory.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Mercenary.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Mercenary.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-NeutralBuilding.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-ShipYard.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-ShipYard.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Shop.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Shop.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Tavern.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-Tavern.mdx";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-WaypointMarker.dds";
			system "MPQEditor d \"$dirname/$filename\" UI\\MiniMap\\AMAI_MiniMap-WaypointMarker.mdx";

			system "MPQEditor d \"$dirname/$filename\" war3map.imp";
			system "MPQEditor d \"$dirname/$filename\" war3mapSkin.w3t";

			system "MPQEditor f \"$dirname/$filename\""

		}
	}

	closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1]);
#!/bin/sh
echo "Install AMAI into $1"
`../MPQEditor.exe htsize $1 64`
echo "Processing: MPQEditor.exe htsize $1 64"
`../AddToMPQ.exe $1 ../Scripts/TFT/common.ai ../Scripts/common.ai ../Scripts/Blizzard.j ../Scripts/Blizzard.j`
echo "Processing: AddToMPQ.exe $1 ../Scripts/TFT/common.ai ../Scripts/common.ai ../Scripts/Blizzard.j ../Scripts/Blizzard.j"
`../AddToMPQ.exe $1 Scripts/TFT/elf.ai Scripts/elf.ai Scripts/TFT/human.ai Scripts/human.ai Scripts/TFT/orc.ai Scripts/orc.ai Scripts/TFT/undead.ai Scripts/undead.ai`
echo "Processing: AddToMPQ.exe $1 Scripts/TFT/elf.ai Scripts/elf.ai Scripts/TFT/human.ai Scripts/human.ai Scripts/TFT/orc.ai Scripts/orc.ai Scripts/TFT/undead.ai Scripts/undead.ai"
`../AddToMPQ.exe \"$dirname/$filename\" Scripts/TFT/elf2.ai Scripts/elf2.ai Scripts/TFT/human2.ai Scripts/human2.ai Scripts/TFT/orc2.ai Scripts/orc2.ai Scripts/TFT/undead2.ai Scripts/undead2.ai`
echo "Processing: AddToMPQ.exe \"$dirname/$filename\" Scripts/TFT/elf2.ai Scripts/elf2.ai Scripts/TFT/human2.ai Scripts/human2.ai Scripts/TFT/orc2.ai Scripts/orc2.ai Scripts/TFT/undead2.ai Scripts/undead2.ai"

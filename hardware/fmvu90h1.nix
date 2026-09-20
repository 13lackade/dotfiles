# Configuration for FMV LIFEBOOK UH90/H1
{
  boot.kernelParams = [
    "snd_sof.tplg_filename=sof-hda-generic-2ch-pdm1.tplg"
    "snd_sof_pci.tplg_filename=sof-hda-generic-2ch-pdm1.tplg"
  ];

  boot.extraModprobeConfig = ''
    options snd-sof tplg_filename=sof-hda-generic-2ch-pdm1.tplg
    options snd-sof-pci tplg_filename=sof-hda-generic-2ch-pdm1.tplg
  '';

  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };
}

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  php,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kanboard";
  version = "1.2.44";

  src = fetchFromGitHub {
    owner = "kanboard";
    repo = "kanboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0vMHNB0wEyjp8oNWh1PZ2oT/Lpk/eiXrDNA5Dzv8xqI=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kanboard
    cp -rv . $out/share/kanboard

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      inherit (nixosTests) kanboard;
    };
  };

  meta = {
    inherit (php.meta) platforms;
    description = "Kanban project management software";
    homepage = "https://kanboard.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
})

{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    hledger
    hledger-ui
    hledger-web
    hledger-check-fancyassertions
    ledger
    gnucash
  ];

  home.sessionVariables = {
    LEDGER_FILE = "${config.home.homeDirectory}/repos/financas/current.journal";
  };
}

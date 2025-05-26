{ ... }:
{
  /*
    TODO
    - add / update all the certificates and trust them
    - validate / fix kerberos for chrome
    - setup vpn
    - enhance vpn with script that fetches kerberos ticket
    - ensure traffic to confluence + jira goes through vpn and authenticates with kerberos to get rid of logins
  */

  # Needs a kerberos ticket
  # kinit --keychain vbu2858@BKKVBU.LOCAL
  # or Ticket-Viewer.app -> refresh 'vbu2858@BKKVBU.LOCAL' or add via "Identität Hinzufügen"
  environment.etc = {
    # Enable kerberos authentication in Safari
    "krb5.conf" = {
      text = ''
        [libdefaults]
        default_realm = BKKVBU.LOCAL
        dns_lookup_realm = true
        dns_lookup_kdc = true

        [domain_realm]
        .root.intern = BKKVBU.LOCAL
        .meine-krankenkasse.de = BKKVBU.LOCAL
        .bkk-vbu.de = BKKVBU.LOCAL
        .bkkvbu.local = BKKVBU.LOCAL
      '';
    };
  };

  # CustomUserPreferences is deprecated, but no alternative is available yet
  # To keep it working, I need
  system.primaryUser = "dwt";

  system.defaults.CustomUserPreferences = {
    # Enable kerberos authentication in Firefox
    # https://devdoc.net/web/developer.mozilla.org/en-US/docs/Mozilla/Integrated_authentication.html
    # https://mozilla.github.io/policy-templates/#authentication
    # https://github.com/mozilla/policy-templates/tree/master/mac
    "org.mozilla.firefox" = {
      "EnterprisePoliciesEnabled" = true;
      "Authentication" = {
        "SPNEGO" = [
          ".meine-krankenkasse.de"
          ".bkk-vbu.de"
          ".bkkvbu.local"
          ".root.intern"
        ];
        "AllowNonFQDN" = {
          "SPNEGO" = true;
        };
      };
    };

    # Enable kerberos authentication in Chrome
    "com.google.Chrome" =
      let
        domains = "*.meine-krankenkasse.de,*.bkk-vbu.de,*.bkkvbu.local,*.root.intern";
      in
      {
        # https://chromeenterprise.google/policies/#AuthServerAllowlist
        "AuthServerAllowlist" = domains;
        # https://chromeenterprise.google/policies/#AuthNegotiateDelegateAllowlist
        "AuthNegotiateDelegateAllowlist" = domains;
      };
  };

}

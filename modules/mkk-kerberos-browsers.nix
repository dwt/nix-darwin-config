{ pkgs, inputs, ... }:
{
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

  # Enable kerberos authentication in Firefox
  # https://devdoc.net/web/developer.mozilla.org/en-US/docs/Mozilla/Integrated_authentication.html
  # https://mozilla.github.io/policy-templates/#authentication
  # https://github.com/mozilla/policy-templates/tree/master/mac
  system.defaults.CustomUserPreferences = {
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
  };

}

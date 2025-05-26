{ ... }:
{
  # allow sudo with touch id
  security.pam.services.sudo_local.touchIdAuth = true;
}

echo 'user_pref("dom.private-attribution.submission.enabled", false);' | tee -a  $HOME/.mozilla/firefox/$(grep "Default=.*\.default*" "$HOME/.mozilla/firefox/profiles.ini" | cut -d"=" -f2)/user.js
echo 'Restart Firefox for the change to have effect'

# What is this about? Read more here: 
# https://www.theregister.com/2024/06/18/mozilla_buys_anonym_betting_privacy/
# https://blog.mozilla.org/en/mozilla/privacy-preserving-attribution-for-advertising/
#
# How to use: 
# curl https://make-firefox-private-again.com | sh
#
#
#
# Verify, or do it manually:
#
# about:config
#
# dom.private-attribution.submission.enabled
#
# set to false
#
#
#
#
# Report issues to @eloy@hsnl.social, but 
# don't complain about curl | sh please.
# I have only tested this on Fedora, let 
# me know if it worked or not on others.
# 
# I am aware there are Firefox forks that
# have sane defaults with regards to this
# and other aspects. I prefer keep using
# Firefox itself, because maintaining a 
# browser is an incredible difficult job
# and I don't trust small projects to be 
# able to this, despite that my trust in 
# Mozilla is pretty low these days.  
# 
# Inspired by https://web.archive.org/web/0/https://make-linux-fast-again.com/

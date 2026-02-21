#!/bin/zsh

rsync -rt --modify-window=1 \
     --exclude='Barbara' \
     --include='*.jpg' --include='*.jpeg' --include='*.png' \
     --include='*.gif' --include='*.mov' --include='*.mp4' \
     --include='*.heic' --include='*/' --exclude='*' \
     --prune-empty-dirs --info=progress2 \
      /Volumes/pwv_repo/ images/

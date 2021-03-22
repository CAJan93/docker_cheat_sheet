
# git rmeove submodule
# https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule
0. mv a/submodule a/submodule_tmp
1. git submodule deinit -f -- a/submodule    
2. rm -rf .git/modules/a/submodule
3. git rm -f a/submodule
# Note: a/submodule (no trailing slash)
# or, if you want to leave it in your working tree and have done step 0
3.   git rm --cached a/submodule
3bis mv a/submodule_tmp a/submodule

# git pull hard
git fetch --all
#Backup your current branch:
git checkout -b backup-master
git reset --hard origin/master # or to whatever branch you want to pull
# now your current branch is same as origin/master

#!/bin/bash

TIMESTAMP=$(date +%F_%H-%M-%S)
DATESTAMP=$(date +%F)

show_file_changes_by_commit() {
  git show --name-only --pretty=format: "$1" | tail -n +2
}


# Update master
git remote update origin
if [[ $? -ne 0 ]] ; then
  echo "ERROR: git remote update failed with $?"
  exit 1
fi

LAST_COMMIT_HASH=$(cat $0 | tail -n 1 | awk '{print $2}')
CURR_COMMIT_HASH=$(git rev-parse origin/master)

if [[ $LAST_COMMIT_HASH == $CURR_COMMIT_HASH ]] ; then
  echo "Done: no more commit to see at $TIMESTAMP."
  exit 0
fi

COMMIT_LIST=$(git rev-list $CURR_COMMIT_HASH ^$LAST_COMMIT_HASH | tac)

for commit in $COMMIT_LIST ; do
  ALL_FILE_CHANGE=$(show_file_changes_by_commit $commit)
  ARM_FILE_CHANGE=$(for file in $ALL_FILE_CHANGE ; do echo $file ; done | grep '[-]arm')
  PPC_FILE_CHANGE=$(for file in $ALL_FILE_CHANGE ; do echo $file ; done | grep '[-]ppc')
  if [[ ${#PPC_FILE_CHANGE} -ne 0 ]] || \
     [[ ${#ARM_FILE_CHANGE} -ne 0 ]]; then
    git show --stat $commit
  fi
done >> progress-$DATESTAMP.txt

# Update last checkpoint
echo "# $CURR_COMMIT_HASH $TIMESTAMP" >> $0

# this is the last checkpoint history:
# 992ae64de0b3539ab59235c7700426aa008b607f 2016-03-17_14-42-14
# 240a09615b3d86a804a44855f6aab18002c3733c 2016-03-17_14-48-24
# 71d525a3b836d88bcff6d6414520228d6b3ece3d 2016-03-17_15-05-28
# 87090ee9def4bf6e41ecc3d3e45c08512b4e2a77 2016-03-17_16-01-37
# 0395c50c607870561fa4f38604beff5f0b286d31 2016-03-17_16-52-30
# c6f9883d53b05b882d41dc887385636d6c7d29fe 2016-03-18_10-47-32
# 45616bfb27266359daeb0aded1a24f89a58a1b80 2016-03-18_11-04-06
# 04c4bbb445d91ddc0504ec89a95ca22ad01e8020 2016-03-19_22-20-11
# 08edc78b5ad773d18d66802b22322e12a32392c6 2016-03-21_08-33-05
# fdb0784d0a050ad6d511cdfb9c6e031da01efd05 2016-03-21_12-10-42
# 09ac4f295c111811fffc91dcc9fd468c2c3207be 2016-03-21_13-54-50
# 34fe5ee92904abd08622eaad143c1474565098af 2016-03-21_15-44-20
# 43fe7d6854ef4a831cdaaf83d2897ac1ca54c066 2016-03-22_09-48-57
# f0d88f9084729a7b0600b35b117fc1e48307e8d3 2016-03-22_12-58-31
# a68b1fdc06874f94d7186ab284b291cd4d075545 2016-03-22_16-40-02
# afd2d68db92e4ecdd5d65c1bc0e6ff8969d24cf8 2016-03-23_08-51-24
# db18219e4b8b1af73b31e6f3481b0fefa1d20954 2016-03-23_09-53-07
# 1ac34fadd082a06248fbe69c6f564ed8acf3057a 2016-03-23_12-34-46
# 2ef81f1d17d778753e0fc15bdf3a77a4c6af2772 2016-03-23_12-38-31
# e2c2a095db05fbd0e7d13cafbfa7d09c3528fef6 2016-03-23_14-38-45
# 529c0328070888fba87a39f7ad6eb0ac0d814e68 2016-03-24_09-12-15
# 1798f3fe84faff32ba44e09f6aed79245dd98d80 2016-03-24_11-44-47
# f5b85cb74c149c008ed1edd56870fd4218350a4d 2016-03-28_12-39-15
# 80803aa89e31839b8f73959776fa7e1923c6b461 2016-03-28_18-29-32
# 8d866e6e3f51b4549049684ea4b9c0b6f4f8c432 2016-03-29_12-56-00
# 14570528745be33c583d23b441c0f3e7a4ea315a 2016-03-29_22-37-03
# a3f941aed4afb475232b2d7d11179720d5e52fd6 2016-03-30_13-16-46
# 5951a5898348aba8cb980b09230a9d08250ba627 2016-03-31_09-52-47
# da934aba4a6a2ca62fb840dcd01489269958e11a 2016-03-31_12-25-52
# 223001850421e2af3006631cf79d526cfcb408dc 2016-03-31_13-34-23
# da97b701add1db601f74d5b5df9a456eec3174d4 2016-03-31_15-37-22
# 0c32e98eab67704bfa0cbc76bf9f1541dc8371fe 2016-04-01_09-09-37
# 58f2be4307a58159b5dc61f0d01e3a24be725846 2016-04-01_09-21-49
# c279138010961ef4040c8bfce790b8e1298cdfbc 2016-04-01_09-41-00
# bdfe29afad9c4332230c271639bcf38683e3cc21 2016-04-01_11-40-17
# 3e284d19aa66f819689965672be18892112f3ea5 2016-04-01_13-53-34
# 6ae6d3f8b70e05eb5dd0cdaff77b530486c08ad2 2016-04-01_15-11-38
# 6c38fde94e3f0996854be741f369a16aa65e871a 2016-04-01_16-11-46
# 3dc43a7550c7142c940681492e3f792dc91f0122 2016-04-04_09-12-06
# 99eea1e109b2d8b3c4cdcc94fb4b2bfe0afd2e53 2016-04-05_09-34-18
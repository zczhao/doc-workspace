#!/bin/bash

gender="male"
# 使用变量
echo $gender
echo ${gender}

# 只读变量
readonly gender
# gender="female"
# .\shell-002-variable.sh: line 10: gender: readonly variable

# 删除变量
name="knight"
unset name
# 变量被删除后不能使用，unset不能删除只读变量
echo $name

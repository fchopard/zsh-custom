#!/usr/bin/zsh

# remove a value from the path, heavily inspired from http://stackoverflow.com/questions/3435355/remove-entry-from-array/3435429#3435429
function remove-value-from-path() {
  local valueToRemove=$1
  
  path=("${(@)path:#$valueToRemove}")
}

function prepend-to-path() {
  local valueToPrepend=$1

  remove-value-from-path $valueToPrepend
  path=($valueToPrepend $path)
}

function append-to-path() {
  local valueToAppend=$1

  remove-value-from-path $valueToAppend
  path=($path $valueToAppend)
}

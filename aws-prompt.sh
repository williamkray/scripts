#!/usr/bin/env bash

## use the setaws command to change profiles at a bash prompt
## run without arguments to unset
setaws() {
  if ! [ $1 ]; then
    unset AWS_PROFILE
    unset AWS_DEFAULT_PROFILE
  else
    export AWS_DEFAULT_PROFILE=$1
    export AWS_PROFILE=$1
  fi
}

## put this in your custom bash prompt somewhere to print the
## currently active AWS profile in cool orange lettering
__aws_prompt () {    
  if [ -z ${AWS_DEFAULT_PROFILE+x} ] ; then        
    AWS_PROFILE_SHOW=""    
  else        
    AWS_PROFILE_SHOW=" \e[0;33m($AWS_DEFAULT_PROFILE)\e[m"    
  fi    

  echo -eE "$AWS_PROFILE_SHOW"
}

## define tab-completion values for the setaws command
_setaws_completion() {
  local cur

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  profiles=$(cat ~/.aws/config | grep profile | cut -d ' ' -f2- | tr ']' ' ')

  case "$cur" in
    
    *)
      COMPREPLY=( $( compgen -W "${profiles}" -- $cur ))
      ;;
  esac

  return 0
}

complete -F _setaws_completion -o filenames setaws

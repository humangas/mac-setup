#!/bin/bash
#########################################################################################################
# installation shell for macOS setup
# see also: https://github.com/humangas/mac-setup
#########################################################################################################

# Const
readonly REPOSITORY_NAME='github.com/humangas/mac-setup'

# Check HTTP Status
function check_http_status() {
  httpstatus=`curl -LI https://${REPOSITORY_NAME} -o /dev/null -w '%{http_code}\n' -s`
  if [ "$httpstatus" -ne 200 ]; then
    echo 'Error Could not connect: '"https://${REPOSITORY_NAME}" "HTTP_STATUS: $httpstatus"
    exit 1
  fi
}

# Install Homebrew
function install_homebrew() {
  which brew > /dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    echo 'Install Homebrew...'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo 'Homebrew has already been installed.'
  fi
}

# Install Ansible
function install_ansible() {
  which ansible > /dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    echo "Install ansible..."
    brew install ansible
  else
    echo 'Ansible has already been installed.'
  fi
}

# Download Setup Repository
function download_setup_repository() {
  echo 'Download Setup Repository...'
  curl -L https://${REPOSITORY_NAME}/archive/master.tar.gz -# | tar xz -C ${worktmpdir} --strip=1
}

# Execute Ansible Playbook
function execute_ansible() {
  local ymlname=${1:-'site'}
  local workdir=${worktmpdir:-'.'}
  echo 'Execute Ansible Playbook...'
  ansible-playbook -i ${workdir}/ansible/hosts -vv ${workdir}/ansible/${ymlname}.yml --ask-become-pass
}

# Main: default
function main() {
  check_http_status
  worktmpdir=`mktemp -d`
  trap "rm -rf ${worktmpdir}" 0 1 2 3 15
  download_setup_repository
  install_homebrew
  install_ansible
  execute_ansible
}

# Main: --local
function main_local() {
  install_homebrew
  install_ansible
  execute_ansible
}

# main
case $# in
  0) main ;; 
  *) case $1 in
       --local) main_local ;;
       *)       echo 'Usage: $ bash install.sh [--local]'; exit 1 ;;
     esac 
esac


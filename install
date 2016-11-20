#!/bin/bash
#########################################################################################################
# Installation shell for macOS setup
#
# Usage:
# Install All:             $ bash install.sh
# Install Any Option: e.g. $ bash install.sh --tags dotfiles
# Show Roles and Tags      $ bash install.sh --show
#
# see also: https://github.com/humangas/mac-setup
#########################################################################################################

# Const
readonly REPOSITORY_NAME='github.com/humangas/mac-setup'
readonly LOCAL_EXEC_PATH="$HOME/src/$REPOSITORY_NAME"

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
  local workdir=${worktmpdir:-'.'}
  echo 'Execute Ansible Playbook...'
  echo "-> $ ansible-playbook -i ${workdir}/ansible/hosts -vv ${workdir}/ansible/site.yml --ask-become-pass" "$@"
  ansible-playbook -i ${workdir}/ansible/hosts -vv ${workdir}/ansible/site.yml --ask-become-pass "$@"
}

# Check Local Execute
function check_local_exec() {
  [ `pwd` == "$LOCAL_EXEC_PATH" ] && return 0
}

# Show roles and tags
function show_roles() {
  grep -ve '.*#.*' ansible/site.yml | grep -oe '- { role:.*}*'
}

# Main
function main() {
  check_local_exec
  if [ $? -ne 0 ]; then
    check_http_status
    worktmpdir=`mktemp -d`
    trap "rm -rf ${worktmpdir}" 0 1 2 3 15
    download_setup_repository
    install_homebrew
    install_ansible
  fi
  execute_ansible "$@"
}

case "$1" in
  --show) show_roles ;;
    *)    main $@ ;;
esac

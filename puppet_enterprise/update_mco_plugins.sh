#!/bin/bash

pe_plugin_dir="$(pwd)/files/mcollective/plugins"
pe_plugin_dirs=$(ls $pe_plugin_dir/)
work_dir="mco_plugin_work_dir/"
pe_plugin_versions="${pe_plugin_dir}/mco_plugin_versions"
echo "Updated plugins on $(date)" >> "${pe_plugin_versions}"

cd "${work_dir}"

for repo in mcollective-puppetral-agent mcollective-puppet-agent mcollective-sshkey-security mcollective-package-agent mcollective-service-agent; do
  echo "Checking ${repo}..."
  if [ ! -d "${repo}" ]; then
    git clone "git@github.com:puppetlabs/${repo}.git"
  fi
  pushd .
  cd "${repo}"
  git pull origin

  for dir in $pe_plugin_dirs; do
    if [ -d "${dir}" ]; then
      cp -r "${dir}" "${pe_plugin_dir}"
    fi
  done
  echo "puppetlabs/${repo} is currently up to commit:" >> "${pe_plugin_versions}"
  git show --oneline >> "${pe_plugin_versions}"

  popd
done

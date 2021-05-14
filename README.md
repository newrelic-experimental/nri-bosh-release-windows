# nri-bosh-release-windows
A bosh release for deploying the New Relic Infrastructure agent on Windows

This is a self contained bosh release for installing the New Relic Infrastructure agent. It includes the deb package as a blob and has an install script that installs the package. The package is the install package for Windows.

The release is meant to be installed as an addon. In order to facilitate that, a sample runtime.yml file is included.
*** Please remember to update the license_key to your license key and double check version number.

To use, upload the release:
```bash
bosh upload-release nri-bosh-release-windows-1.17.1.tgz
```

and. Then update the runtime config (add license key, etc.)
```bash
bosh update-runtime-config runtime.yml
```

Then redeploy to pick up the addon.

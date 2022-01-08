[![Community Project header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

# NRI BOSH Release - Windows

> A bosh release for deploying the New Relic Infrastructure agent to CLoud Foundry

This is a self contained bosh release for installing the New Relic Infrastructure agent on Cloud Foundry Windows cells. It includes New Relic Infrastructure agent [.msi] executable as a blob and has an install script that installs the package on Windows cells. It is a standard BOSH install package for Windows 2019.

The release is meant to be installed as an addon. In order to facilitate that, a sample runtime.yml file is included with properties required for the installation procedure.


## Installation

### Upload the release

To use, upload the release:
```bash
bosh upload-release ~/Downloads/nr-bosh-release-windows-1.20.7.tgz
```

### Update runtime config

In the sample runtime.yml file in the base directory of the repo, set the `license_key` parameter to the target New Relic account's license key to which you'd like infrastructure agents to report. 

If there are other values that you wish to modify (e.g. agent properties, custom attributes) you could make those changes here.

<strong>Note:</strong> runtime.yml contains settings for both xenial and windows cells. The xenial settings were added for convenience. You could remove all xenial-related settings if you'd prefer to do so.

...and then, use the following bosh command to update the runtime config:
```bash
bosh update-runtime-config runtime.yml
```

### Deploy to Cloud Foundry

Finally, use <strong>`"bosh deploy"`</strong> command to redeploy the release.
<br/>
<strong>Note:</strong> bosh deploy command arguments vary. Please refer to BOSH documentation for [bosh deploy](https://bosh.io/docs/cli-v2/#deploy) command options for your CF foundation.




## Usage
- Login to [New Relic One](https://one.newrelic.com) 
- From the top menu bar select <strong>"Infrastructure"</strong> 
- View all infrastructure agents reporting to your New Relic account
- Refer to New Relic documentation for [Infrastructure UI](https://docs.newrelic.com/docs/infrastructure/infrastructure-ui-pages/infrastructure-ui-entities/)
- You could filter by tags and all other properties to view only the nodes that are reporting from Cloud Foundry Foundation


## Build & Release

### Prerequisites
- make sure `git cli` is installed on your system
- make sure `bosh cli` is installed and configured on your system to target [bosh director](https://bosh.io/docs/director-certs-openssl/#target)

### Build the release
- clone this repo
```bash
git clone https://github.com/newrelic/nri-bosh-release-windows.git
```

- change directory to the local repo you just cloned
```bash
cd nri-bosh-release-windows
```

- run the following command to capture the previous infrastructure agent file name and version
```bash
bosh blobs
```

- remove the existing infrastructure agent binary from the blob
```bash
bosh remove-blob <PREVIOUS_INFRASTRUCTURE_BLOB_PATH>
```

- download the latest <strong>"msi"</strong> installation for Infrastructure agent (e.g. `newrelic-infra.1.20.7.msi`)
```bash
wget -q https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.<CURRENT_RELEASE>.msi
```

- add the newly downloaded infrastructure agent to the blobsstore
```bash
bosh add-blob newrelic-infra.<CURRENT_RELEASE>.msi newrelic-infra.<CURRENT_RELEASE>.msi
```

- edit the following files and update the infrastructure agent version to the new version you downloaded
```
	jobs/install-nri/templates/nri.ps1
	packages/nr-infra/packaging
	packages/nr-infra/spec
```

- make sure the <strong>version</strong> property in runtime.yml matches the release version you're creating

- run the following command to build the release package
```bash
bosh create-release --version=<CURRENT_RELEASE> --tarball=release/nri-bosh-release-windows-<CURRENT_RELEASE>.tgz --[force | final]
```


## Issues / Enhancement Requests

Issues and enhancement requests can be submitted in the [Issues tab of this repository](https://github.com/newrelic/nri-bosh-release-windows/issues). Please search for and review the existing open issues before submitting a new issue.


## Contribute

We encourage your contributions to improve [project name]! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

<strong>A note about vulnerabilities</strong>

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

## License
nri-bosh-release-windows is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.

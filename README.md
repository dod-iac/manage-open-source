# Manage Open Source

This repository is meant to be used to manage DoD IAC open source projects like terraform modules.

## Managing Terraform modules

To manage terraform repos make sure this repository is checked out in the same directory as all other terraform repos being managed.
Then run this script:

```sh
cd project_dir
git clone git@github.com:dod-iac/terraform-module-template.git
git clone git@github.com:dod-iac/terraform-aws-EXAMPLE-MODULE.git
git clone git@github.com:dod-iac/manage-open-source.git
cd manage-open-source
./scripts/fix-terraform-repos.sh
```

This will copy files from the `dod-iac/terraform-module-template` repo to the other repos being managed. The goal here is that
the template repo should be the source of truth for current best practices.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit terraform terraform-docs
pre-commit install --install-hooks
```

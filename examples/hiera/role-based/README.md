# Role-Based

This profile is an example of how role-based configurations can work.

Each OpenStack server will be labeled with a role -- for example, a custom Facter fact. For this example, there are two roles: a Cloud Controller and a Compute Node.

All servers will have access to all settings in `common.yaml`.

Then depending on the servers' role, they will have access to the settings in either `roles/compute.yaml` or `roles/controller.yaml`.
